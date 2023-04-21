//
//  ContentView.swift
//  iOSControlCenter
//
//  Created by Pham on 4/21/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
          GeometryReader{
                let size = $0.size
                let safeArea = $0.safeAreaInsets
                
                ControlView(size: size,safeArea: safeArea)
                      .ignoresSafeArea(.container, edges: .all)
          }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
