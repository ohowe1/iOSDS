//
//  EnableDisableButtonsView.swift
//  driverstation
//
//  Created by Oliver Howe on 6/19/22.
//

import SwiftUI

extension Text {
  func withRobotStatusStyle() -> some View {
    self
      .frame(width: 125)
      .padding(.vertical, 25)
      .font(.title.bold())
      .border(.black)
  }
}

struct EnableDisableButtons: View {
  @EnvironmentObject var controller: DriverStationController
  var body: some View {
    HStack(spacing: 0) {
      Button(action: {
        controller.isEnabled = true
      }) {
        Text("Enable")
          .withRobotStatusStyle()
          .foregroundColor(.green)
          .background(controller.isEnabled ? Color(red: 45 / 255, green: 45 / 255, blue: 45 / 255) : .gray)
      }
      Button(action: {
        controller.isEnabled = false
      }) {
        Text("Disable")
          .withRobotStatusStyle()
          .foregroundColor(Color(red: 187 / 255, green: 19 / 255, blue: 21 / 255))
          .background(!controller.isEnabled ? Color(red: 45 / 255, green: 45 / 255, blue: 45 / 255) : .gray)
      }
    }
  }
}

struct EnableDisableButtons_Previews: PreviewProvider {
  static var previews: some View {
    EnableDisableButtons()
      .previewInterfaceOrientation(.landscapeLeft)
      .environmentObject(DriverStationController())
  }
}
