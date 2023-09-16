//
//  UDPConnection.swift
//  driverstation
//
//  Created by Oliver Howe on 6/23/22.
//

import Foundation
import Network

class UDPConnection {
  @Published var lastRecievedMessage: Data?
  var isReady: Bool = false
  var isListening: Bool = false
  var connection: NWConnection
  
    convenience init (address: String, port: Int) {
      self.init(address: NWEndpoint.Host(address), port: NWEndpoint.Port(integerLiteral: NWEndpoint.Port.IntegerLiteralType(port)))
    }
  
  init(address: NWEndpoint.Host, port: NWEndpoint.Port) {
    connection = NWConnection(host: address, port: port, using: .udp)
    
    connection.stateUpdateHandler = { state in
      if state == .ready {
        print("UDP Ready")
        self.isReady = true
        self.isListening = true
        self.recieve()
      }
    }
  }
  
  func start() {
    connection.start(queue: .global())
  }
  
  func cancel() {
    connection.cancel()
  }
  
  deinit {
    cancel()
  }
  
  func recieve() {
    connection.receiveMessage { data, context, complete, error in
      print("Recieved message")
      if (error == nil && complete && data != nil) {
        self.lastRecievedMessage = data
      }
      
      if (self.isListening) {
        self.recieve()
      }
    }
  }
  
  func send(_ data: Data) {
    if (!isReady) {
      return
    }
    connection.send(content: data, completion: .contentProcessed { error in
      if (error != nil) {
        print(error!)
      }
    })
  }
}
