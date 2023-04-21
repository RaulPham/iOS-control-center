//
//  ControlView.swift
//  iOSControlCenter
//
//  Created by Pham on 4/21/23.
//

import SwiftUI

struct ControlView: View {
      var size: CGSize
      var safeArea: EdgeInsets
      
      @State private var volumeSetting: SliderConfiguration = .init()
      @State private var brightnessSetting: SliderConfiguration = .init()
      @Namespace private var nameSpace
      
    var body: some View {
          ZStack {
                let paddedW = size.width - 50
                
                Image("Background")
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: size.width)
                      .blur(radius: 45, opaque: true)
                      .clipped()
                      .onTapGesture(perform: resetSetting)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
                      ActionView()
                            .frame(height: paddedW * 0.5)
                            .background {
                                  RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .fill(.thinMaterial)
                                        .reverseMask {
                                              ActionView(true)
                                        }
                            }
                            .hideView([volumeSetting, brightnessSetting])
                      
                      AudioControl()
                            .frame(height: paddedW * 0.5)
                            .hideView([volumeSetting, brightnessSetting])
                      AccessibilityControls()
                            .frame(height: paddedW * 0.5)
                            .hideView([volumeSetting, brightnessSetting])
                      InteractiveControls()
                            .frame(height: paddedW * 0.5)
                            .hideView([volumeSetting, brightnessSetting])
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.vertical, 15)
                .padding(.horizontal, 25)
                .padding(.top, safeArea.top)
                .overlay(content: {
                      ExpandVolumeControl(paddedW)
                            .overlay(alignment: .top) {
                                  ZStack {
                                        if volumeSetting.animateContent {
                                              Image(systemName: "speaker.wave.3.fill", variableValue: volumeSetting.progress)
                                                    .font(.title)
                                                    .blendMode(.overlay)
                                                    .offset(y: -110)
                                                    .transition(.opacity)
                                        }
                                  }
                                  .animation(.easeInOut(duration: 0.2), value: volumeSetting.animateContent)
                            }
                      
                      ExpandBrightnessControl(paddedW)
                            .overlay(alignment: .top) {
                                  ZStack {
                                        if brightnessSetting.animateContent {
                                              Image(systemName: "sun.max.fill", variableValue: brightnessSetting.progress)
                                                    .font(.title)
                                                    .blendMode(.overlay)
                                                    .offset(y: -110)
                                                    .transition(.opacity)
                                        }
                                  }
                                  .animation(.easeInOut(duration: 0.2), value: brightnessSetting.animateContent)
                            }
                })
                .animation(.easeInOut(duration: 0.2), value: volumeSetting.expand)
                .animation(.easeInOut(duration: 0.2), value: brightnessSetting.expand)
                .environment(\.colorScheme, .dark)
          }
    }
      
      func resetSetting() {
            volumeSetting.expand = false
            brightnessSetting.expand = false
            
            volumeSetting.animateContent = false
            brightnessSetting.animateContent = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                  volumeSetting.showContent = false
                  brightnessSetting.showContent = false
            }
      }
      
      @ViewBuilder
      func ActionView(_ mask: Bool = false) -> some View {
            VStack(spacing: 15) {
                  HStack(spacing: 15) {
                        ButtonView(image: "airplane", mask)
                        ButtonView(image: "antenna.radiowaves.left.and.right", mask)
                  }
                  HStack(spacing: 15) {
                        ButtonView(image: "wifi", mask)
                        ButtonView(image: "personalhotspot", mask)
                  }
            }
            .padding(15)
      }
      
      @ViewBuilder
      func ButtonView(image: String, _ mask: Bool = false) -> some View {
            Image(systemName: image)
                  .font(.title2)
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
                  .background {
                        if mask {
                              Circle()
                        }
                  }
      }
      
      @ViewBuilder
      func AccessibilityControls() -> some View {
            VStack(spacing: 15) {
                  HStack(spacing: 15) {
                        Image(systemName: "lock.open.rotation")
                              .font(.title)
                              .frame(maxWidth: .infinity, maxHeight: .infinity)
                              .addRoundedBackground()
                        
                        Image(systemName: "rectangle.on.rectangle")
                              .font(.title)
                              .frame(maxWidth: .infinity, maxHeight: .infinity)
                              .addRoundedBackground()
                  }
                  HStack(spacing: 10) {
                        Image(systemName: "person.fill")
                              .font(.title2)
                              .frame(width: 50, height: 50)
                        
                        Text("Focus")
                              .fontWeight(.medium)
                  }
                  .padding(.horizontal, 10)
                  .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                  .background {
                        Color.clear
                              .addRoundedBackground()
                              .reverseMask {
                                    Circle()
                                          .frame(width: 50, height: 50)
                                          .frame(maxWidth: .infinity, alignment: .leading)
                                          .padding(.leading, 10)
                              }
                  }
            }
      }
      
      @ViewBuilder
      func InteractiveControls()->some View{
            HStack(spacing: 15){
                  CustomSlider(
                        thumbImage: "sun.max.fill",
                        animationId: "EXPANDBRIGHTNESS",
                        nameSpaceId: nameSpace,
                        display: !brightnessSetting.expand,
                        setting: $brightnessSetting
                  )
                  .opacity(brightnessSetting.showContent ? 0 : 1)
                  
                  CustomSlider(
                        thumbImage: "speaker.wave.3.fill",
                        animationId: "EXPANDVOLUME",
                        nameSpaceId: nameSpace,
                        display: !volumeSetting.expand,
                        setting: $volumeSetting
                  )
                  .opacity(volumeSetting.showContent ? 0 : 1)
            }
      }
      
      @ViewBuilder
      func ExpandBrightnessControl(_ width: CGFloat) -> some View {
            if brightnessSetting.expand {
                  VStack {
                        CustomSlider(
                              thumbImage: "sun.max.fill",
                              animationId: "EXPANDBRIGHTNESS",
                              cornerRadius: 30,
                              nameSpaceId: nameSpace,
                              display: brightnessSetting.expand,
                              setting: $brightnessSetting
                        )
                        .opacity(brightnessSetting.showContent ? 1 : 0)
                        .frame(width: width * 0.35, height: width)
                  }
                  .transition(.offset(x: 1, y: 1))
                  .onAppear {
                        brightnessSetting.showContent = true
                        brightnessSetting.animateContent = true
                  }
            }
      }
      
      @ViewBuilder
      func ExpandVolumeControl(_ width: CGFloat) -> some View {
            if volumeSetting.expand {
                  VStack {
                        CustomSlider(
                              thumbImage: "speaker.wave.3.fill",
                              animationId: "EXPANDVOLUME",
                              cornerRadius: 30,
                              nameSpaceId: nameSpace,
                              display: volumeSetting.expand,
                              setting: $volumeSetting
                        )
                        .opacity(volumeSetting.showContent ? 1 : 0)
                        .frame(width: width * 0.35, height: width)
                  }
                  .transition(.offset(x: 1, y: 1))
                  .onAppear {
                        volumeSetting.showContent = true
                        volumeSetting.animateContent = true
                  }
            }
      }
      
      @ViewBuilder
      func AudioControl() -> some View {
            VStack {
                  HStack(spacing: 0) {
                        Image(systemName: "backward.fill")
                              .foregroundColor(.gray)
                        
                        Image(systemName: "play.fill")
                              .foregroundColor(.white)
                              .frame(maxWidth: .infinity)
                        
                        Image(systemName: "forward.fill")
                              .foregroundColor(.gray)
                  }
                  .font(.title3)
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 30)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .addRoundedBackground()
      }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
