//
//  ExtensionsView.swift
//  iOSControlCenter
//
//  Created by Pham on 4/21/23.
//

import SwiftUI

extension View {
      func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
            UIImpactFeedbackGenerator(style: style).impactOccurred()
      }
      
      @ViewBuilder
      func addRoundedBackground() -> some View {
            self
                  .background {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                              .fill(.thinMaterial)
                  }
      }
      
      @ViewBuilder
      func hideView(_ configs: [SliderConfiguration]) -> some View {
            let status = configs.contains { $0.expand }
            
            self
                  .opacity(status ? 0 : 1)
                  .animation(.easeInOut(duration: 0.2), value: status)
      }
      
      @ViewBuilder
      func reverseMask<Content: View>(@ViewBuilder content: @escaping() -> Content) -> some View {
            self
                  .mask {
                        Rectangle()
                              .overlay {
                                    content()
                                          .blendMode(.destinationOut)
                              }
                  }
      }
}
