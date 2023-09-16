//
//  ContentView.swift
//  Shared
//
//  Created by Oliver Howe on 6/19/22.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      FullStatusView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.gray)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .previewInterfaceOrientation(.landscapeLeft)
      .environmentObject(DriverStationController())
  }
}
