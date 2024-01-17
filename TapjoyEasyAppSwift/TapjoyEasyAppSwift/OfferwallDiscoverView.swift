//
//  OfferwallDiscoverView.swift
//  TapjoyEasyAppSwift
//
//  Created by Luke Bowman on 28/03/2023.
//

import SwiftUI
import Tapjoy

struct OfferwallDiscoverView: View {
    @EnvironmentObject var offerwallDiscoverViewModel: OfferwallDiscoverViewModel
    @StateObject private var coordinator = CoordinatorBridge()
    @State private var widthTextField: Int = Int(UIScreen.main.bounds.width)
    @State private var heightTextField: Int = 262
    @State var orientation = UIDevice.current.orientation
    
    let screenHeight = Int(UIScreen.main.bounds.height)
    let screenWidth = Int(UIScreen.main.bounds.width)
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .makeConnectable()
            .autoconnect()

    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
                ScrollView {
                    VStack {
                        HStack {
                            Text(offerwallDiscoverViewModel.statusMessageLbl)
                                .foregroundColor(Color("TextColor"))
                            Spacer()
                            Toggle(isOn: $offerwallDiscoverViewModel.pluginToggle) {
                                Text("Plugin")
                                    .foregroundColor(Color("TextColor"))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        } .padding(.all)
                        HStack {
                            Text("Width")
                                .foregroundColor(Color("TextColor"))
                            TextField("", value: $widthTextField, formatter: NumberFormatter())
                                .padding(.leading, 10)
                                .frame(height: 40)
                                .background(Color.white)
                                .autocapitalization(.none)
                                .cornerRadius(8)
                                .foregroundColor(Color.black)
                                .keyboardType(.numberPad)
                            Text("Height")
                                .foregroundColor(Color("TextColor"))
                            TextField("", value: $heightTextField, formatter: NumberFormatter())
                                .padding(.leading, 10)
                                .frame(height: 40)
                                .background(Color.white)
                                .autocapitalization(.none)
                                .cornerRadius(8)
                                .foregroundColor(Color.black)
                                .keyboardType(.numberPad)
                            Button(action: {
                                tapResize(width: widthTextField, height: heightTextField)
                                hideKeyboard()
                            }){
                                Text("Resize")
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                    .font(Font.headline)
                                    .padding()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.70)
                                
                            }
                            .frame(maxHeight: 40)
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        TextField("", text: $offerwallDiscoverViewModel.placementTextField)
                            .padding(.leading, 10)
                            .frame(height: 40)
                            .background(Color.white)
                            .autocapitalization(.none)
                            .cornerRadius(8)
                            .foregroundColor(Color.black)
                            .padding(.horizontal)
                        HStack {
                            Button(action: {
                                tapRequest()
                            }){
                                Text("Request")
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                    .font(Font.headline)
                                    .padding()
                            }
                            .frame(maxHeight: 40)
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                            Button(action: {
                                tapClear()
                            }){
                                Text("Clear")
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 30)
                                    .font(Font.headline)
                                    .padding()
                            }
                            .frame(maxHeight: 40)
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        HStack {
                            OfferwallDiscoverViewControllerWrapper(statusMessageLbl: $offerwallDiscoverViewModel.statusMessageLbl, coordinatorBridge: coordinator)
                                .frame(width: UIDevice.current.orientation.isLandscape ?  offerwallDiscoverViewModel.frameWidthTextField : offerwallDiscoverViewModel.frameWidthTextField , height: offerwallDiscoverViewModel.frameHeightTextField )
                                .background(Color("OWDBackgroundColor"))
                                .onReceive(orientationChanged) { _ in
                                    orientationDidChange()
                                }
                                .ignoresSafeArea()

                            Spacer()
                        }
                    }
                }
                .padding()
        }
    }
    
    private func orientationDidChange() {
        if (UIDevice.current.orientation.isFlat) {
            return
        }
        let width: Int
        let isPhone = UIDevice.current.userInterfaceIdiom == .phone
        let isLandscape = UIDevice.current.orientation.isLandscape
        let largestDimension = max(screenHeight, screenWidth)
        let smallestDimension = min(screenHeight, screenWidth)

        if (isPhone && (UIDevice.current.orientation == .portraitUpsideDown  || UIDevice.current.orientation.isLandscape)) {
            width = largestDimension - 100
        } else {
            width = isLandscape ? largestDimension : smallestDimension
        }

        guard widthTextField != width else { return }

        tapResize(width: width, height: heightTextField)
        widthTextField = width
        hideKeyboard()
    }
    
    private func tapClear() {
        if offerwallDiscoverViewModel.pluginToggle {
            offerwallDiscoverViewModel.onTapClear()
        } else {
            coordinator.viewController.onTapClearViewController()
        }
    }
    
    private func tapResize(width: Int, height: Int) {
        offerwallDiscoverViewModel.onTapResize(width: width, height: height)
        coordinator.viewController.onTapResizeViewController(width: offerwallDiscoverViewModel.frameWidthTextField, height: offerwallDiscoverViewModel.frameHeightTextField)
    }
    
    private func tapRequest() {
        if offerwallDiscoverViewModel.pluginToggle {
            offerwallDiscoverViewModel.onTapRequest(height: heightTextField)
        } else {
            coordinator.viewController.onTapRequestViewController(placement: offerwallDiscoverViewModel.placementTextField, width: Int(offerwallDiscoverViewModel.frameWidthTextField), height: Int(offerwallDiscoverViewModel.frameHeightTextField))
        }
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
