//
//  CustomSlider.swift
//  iOSControlCenter
//
//  Created by Pham on 4/21/23.
//

import SwiftUI

struct CustomSlider: View {
      var thumbImage: String
      var animationId: String
      
      var cornerRadius: CGFloat = 18
      var nameSpaceId: Namespace.ID
      
      var display: Bool
      
      @Binding var setting: SliderConfiguration
      
    var body: some View {
          GeometryReader {
                let size = $0.size
                
                ZStack {
                      if display {
                            Rectangle()
                                  .fill(.thinMaterial)
                                  .overlay(alignment: .bottom) {
                                        Rectangle()
                                              .fill(.white)
                                              .scaleEffect(y: setting.progress, anchor: .bottom)
                                  }
                                  .overlay(alignment: .bottom) {
                                        Image(systemName: thumbImage, variableValue: setting.progress)
                                              .font(.title)
                                              .blendMode(.exclusion)
                                              .foregroundColor(.gray)
                                              .padding(.bottom, 20)
                                              .opacity(setting.animateContent && display ? 0 : 1)
                                  }
                                  .clipShape(RoundedRectangle(cornerRadius: setting.animateContent ? cornerRadius : 18, style: .continuous))
                                  .animation(.easeInOut(duration: 0.2), value: setting.animateContent)
                                  .scaleEffect(setting.shrink ? 0.95 : 1)
                                  .animation(.easeInOut(duration: 0.25), value: setting.shrink)
                                  .matchedGeometryEffect(id: animationId, in: nameSpaceId)
                      }
                }
                .gesture(
                  LongPressGesture(minimumDuration: 0.3).onEnded({ _ in
                        expandView()
                  }).simultaneously(with: DragGesture().onChanged({ value in
                          if !setting.shrink{
                                let startLocation = value.startLocation.y
                                let currentLocation = value.location.y
                                let offset = startLocation - currentLocation
                             
                                var progress = (offset / size.height) + setting.lastProgress
                             
                                progress = max(0, progress)
                                progress = min(1, progress)
                                setting.progress = progress
                          }
                    }).onEnded({ value in
                          setting.lastProgress = setting.progress
                    })))
          }
    }
      
      func expandView() {
            setting.shrink = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                  setting.shrink = false
                  
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        setting.expand = true
                        haptics(.medium)
                  }
            }
      }
}
