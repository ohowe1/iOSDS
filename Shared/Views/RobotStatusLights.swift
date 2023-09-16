//
//  StatusLightsView.swift
//  driverstation
//
//  Created by Oliver Howe on 6/26/22.
//

import SwiftUI

struct RobotStatusLights: View {
  @EnvironmentObject var controller: DriverStationController
  
  var body: some View {
    VStack(alignment: .trailing, spacing: 3) {
      StatusLight(text: "Communications", value: controller.communicationsStatus)
      StatusLight(text: "Robot Code", value: controller.codeStatus)
    }
    
  }
}

struct RobotStatusLights_Previews: PreviewProvider {
  static var previews: some View {
    RobotStatusLights()
      .environmentObject(DriverStationController())
  }
}
