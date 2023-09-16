//
//  StatusLightView.swift
//  driverstation
//
//  Created by Oliver Howe on 6/26/22.
//

import SwiftUI

struct StatusLight: View {
  let text: String
  var value: Bool
  var body: some View {
    HStack {
      Text(text)
        .foregroundColor(.white)
        .font(.title2.bold())
      RoundedRectangle(cornerRadius: 2)
        .frame(width: 30, height: 20)
        .foregroundColor(value ? .green : .red)
    }
  }
}

struct StatusLights_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      VStack(alignment: .trailing, spacing: 3) {
        StatusLight(text: "True", value: true)
        StatusLight(text: "False", value: false)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .background(.gray)
  }
}
