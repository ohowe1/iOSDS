//
//  NetworkController.swift
//  driverstation
//
//  Created by Oliver Howe on 6/23/22.
//

import Combine
import Foundation

extension Numeric {
  var bytes: [UInt8] {
    var self_ = self
    return Array(Data(bytes: &self_, count: MemoryLayout<Self>.size))
  }
}

extension Array where Element == UInt8 {
  func toFloat() -> Float {
    return Data(bytes: self, count: 4).withUnsafeBytes { $0.load(as: Float.self )}
  }
}

enum Modes: String, CaseIterable, Equatable {
  case teleop = "Teleop"
  case autonomous = "Autonomous"
  case test = "Test"
  
  var mask: UInt8 {
    switch self {
    case .teleop:
      return 0x00
    case .test:
      return 0x01
    case .autonomous:
      return 0x02
    }
  }
}

func getBatteryVoltage(left: UInt8, right: UInt8) -> Double {
  return (Double(left) + (Double(right) / 255.0))
}

class DriverStationController: ObservableObject {
  @Published var isEnabled: Bool = false
  @Published var mode: Modes = .teleop
  @Published private(set) var canUsage: Double = 0.0
  @Published private(set) var batteryVoltage: Double = 0.0
  @Published private(set) var communicationsStatus: Bool = false
  @Published private(set) var codeStatus: Bool = false;
  @Published private(set) var isEmergencyStopped: Bool = false;
  
  private var sequenceNum: UInt16 = 0
  
  private var requestingTime: Bool = false
  
  private let driverStationQueue = DispatchQueue(label: "Driver Station", qos: .userInitiated)
  private var udpConnection: UDPConnection?
  private var messageListener: AnyCancellable?
  private var broadcaster: AnyCancellable?
  private var communicationsTimeout: Timer?
  
  init() {
  }
  
  func begin(connectTo ipAddress: String) {
    udpConnection = UDPConnection(address: ipAddress, port: 1110)
    guard let udpConnection = udpConnection else {
      return
    }
    udpConnection.start()
    broadcaster = Timer.publish(every: 0.05, on: .main, in: .common)
      .autoconnect()
      .receive(on: driverStationQueue)
      .sink(receiveValue: { _ in
        self.sendDriverStationPacket()
      })
    messageListener = udpConnection
      .$lastRecievedMessage
      .receive(on: driverStationQueue)
      .sink { message in
        if (message != nil) {
          self.handleRobotMessage(message!)
        }
      }
  }
  
  func resetTimeout() {
    communicationsTimeout?.invalidate()
    
    communicationsTimeout = Timer(timeInterval: 3, repeats: false) { _ in
      self.communicationsStatus = false
    }
  }
  
  func handleRobotMessage(_ message: Data) {
    print("Recieved byte")
    if (message.count < 7) {
      return
    }
    let byteArray: [UInt8] = [UInt8](message)
    let controlByte = byteArray[2]
    let statusByte = byteArray[3]
    
    self.codeStatus = (statusByte & 0b00100000) != 0
    self.isEmergencyStopped = ((controlByte & 0b10000000)) != 0
    self.batteryVoltage = getBatteryVoltage(left: byteArray[5], right: byteArray[6])
    
    self.requestingTime = byteArray[7] != 0
    
    if (byteArray.count > 9) {
      if (byteArray[8] == 0x0e) {
        let canUtilizaitonData: [UInt8] = Array(byteArray[9...13])
        canUsage = Double(canUtilizaitonData.toFloat())
      }
    }
    
    
    self.communicationsStatus = true
    resetTimeout()
  }
  
  
  private func getTimeInfo() -> [UInt8] {
    return TimeTag(Date()).getBytes() + TimezoneTag(TimeZone.current).getBytes()
  }
  
  func sendDriverStationPacket() {
    var controlByte: UInt8 = mode.mask
    if (isEnabled) {
      controlByte |= 1 << 2
    }
    
    
    // TODO: Request and alliance
    var toSend: [UInt8] = sequenceNum.bytes + [0x01, controlByte, 0x00, 0x01]
    
    if (requestingTime) {
      toSend += getTimeInfo()
      requestingTime = false
    }
    
    udpConnection?.send(Data(bytes: toSend, count: toSend.count))
    
    sequenceNum += 1
  }
}
