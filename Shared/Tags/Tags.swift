//
//  Tags.swift
//  iOSDS (iOS)
//
//  Created by Oliver Howe on 6/30/22.
//

import Foundation

protocol Tag {
  var id: UInt8 { get }
  var data: [UInt8] { get }
}

extension Tag {
  func getBytes() -> [UInt8] {
    // Length (data length + id length), id, data
    return [UInt8(1 + data.count), id] + data
  }
}

class TimeTag: Tag {
  var id: UInt8 = 0x0f
  
  var data: [UInt8]
  
  init(_ date: Date) {
    var cal = Calendar(identifier: .gregorian)
    let utcTime = TimeZone(identifier: "UTC")!
    cal.timeZone = utcTime
    let microsecond = UInt32(cal.component(.nanosecond, from: date) / 1000)
    let second = UInt8(cal.component(.second, from: date))
    let minute = UInt8(cal.component(.minute, from: date))
    let hour = UInt8(cal.component(.hour, from: date))
    let day = UInt8(cal.component(.day, from: date))
    let month = UInt8(cal.component(.month, from: date) - 1)
    let year = UInt8(cal.component(.year, from: date) - 1900)
    
    self.data = microsecond.bytes + [second, minute, hour, day, month, year]
  }
}

class TimezoneTag: Tag {
  static private func stringsToBytes(_ str: String?) -> [UInt8]? {
    guard let str = str else {
      return nil
    }
    var arr: [UInt8] = []
    
    for ch in str {
      if ch.isASCII {
        arr.append(ch.asciiValue!)
      } else {
        return nil
      }
    }
    return arr
  }
  
  var id: UInt8 = 0x10
  var data: [UInt8]
  
  init(_ timeZone: TimeZone) {
    // mst best timezone
    self.data = TimezoneTag.stringsToBytes(timeZone.abbreviation()) ?? TimezoneTag.stringsToBytes("MST")!
  }
}
