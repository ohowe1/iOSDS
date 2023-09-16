//
//  iOSDSApp.swift
//  Shared
//
//  Created by Oliver Howe on 6/28/22.
//

import SwiftUI

@main
struct iOSDSApp: App {
  @StateObject var controller = DriverStationController()
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(controller)
        .task {
          controller.begin(connectTo: "127.0.0.1")
        }
    }
  }
}
