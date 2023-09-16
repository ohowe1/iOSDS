//
//  IPSelector.swift
//  driverstation
//
//  Created by Oliver Howe on 6/26/22.
//

import SwiftUI

struct IPSelector: View {
  @EnvironmentObject var controller: DriverStationController
  @SceneStorage("ip") var typedIP = ""
  @State var isInvalidIP: Bool = false
  var body: some View {
    HStack {
      TextField("Roborio IP Address", text: $typedIP)
      Button(action: connectWithIP) {
        Text("Connect")
      }
    }
    .alert("Invalid IP Address", isPresented: $isInvalidIP) {
      Button("OK") {
        
      }
    } message: {
      Text("For a physical roborio this will most likely be 10.TE.AM.2 with TEAM being your team number. For simulation 127.0.0.1")
    }
  }
  
  func connectWithIP() {
    isInvalidIP = true;
  }
}

struct IPSelector_Previews: PreviewProvider {
  static var previews: some View {
    IPSelector()
      .environmentObject(DriverStationController())
  }
}
