//
//  FullStatusView.swift
//  driverstation
//
//  Created by Oliver Howe on 6/19/22.
//

import SwiftUI

struct FullStatusView: View {
  var body: some View {
    HStack(spacing: 60) {
      VStack {
        RobotModeSelector()
        EnableDisableButtons()
      }
      RobotStatusLights()
    }
  }
}

struct FullStatusView_Previews: PreviewProvider {
  static var previews: some View {
    FullStatusView()
      .previewInterfaceOrientation(.landscapeLeft)
      .environmentObject(DriverStationController())
      .background(.gray)
  }
}
