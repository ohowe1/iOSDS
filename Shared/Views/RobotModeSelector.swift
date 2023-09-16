//
//  EnableDisableButtonsView.swift
//  driverstation
//
//  Created by Oliver Howe on 6/19/22.
//

import SwiftUI

extension Text {
  func withRobotModeStyle() -> some View {
    self
      .foregroundColor(.white)
      .padding(.leading, 20)
      .padding(.vertical)
      .frame(width: 250, alignment: .leading)
      .font(.title2.bold())
      .border(.black)
  }
}

struct RobotModeSelector: View {
  @EnvironmentObject var controller: DriverStationController
  var body: some View {
    VStack(spacing: 0) {
      ForEach(Modes.allCases, id: \.self) { value in
        Button(action: {
          if (controller.mode != value) {
            controller.isEnabled = false
            controller.mode = value
          }
        }) {
          Text(value.rawValue)
            .withRobotModeStyle()
            .background(controller.mode == value ? Color(red: 45 / 255, green: 45 / 255, blue: 45 / 255) : .gray)
        }
      }
    }
  }
}

struct RobotModeSelector_Previews: PreviewProvider {
  static var previews: some View {
    RobotModeSelector()
      .previewInterfaceOrientation(.landscapeLeft)
      .environmentObject(DriverStationController())
  }
}
