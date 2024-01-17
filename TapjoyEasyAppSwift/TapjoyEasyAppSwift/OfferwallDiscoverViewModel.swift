//
//  OfferwallDiscoverViewModel.swift
//  TapjoyEasyAppSwift
//
//  Created by Luke Bowman on 28/03/2023.
//

import Foundation
import Tapjoy
import SwiftUI
class OfferwallDiscoverViewModel: NSObject, UIApplicationDelegate, TJOfferwallDiscoverDelegate, ObservableObject {
    
    @Published var pluginToggle: Bool = false
    @Published var frameWidthTextField: CGFloat = UIScreen.main.bounds.width
    @Published var frameHeightTextField: CGFloat = 262
    @Published var placementTextField: String = "offerwall_discover"
    @Published var statusMessageLbl: String = "Status Message"
    
    var pluginAPI = TapjoyPluginAPI()
    
    // MARK: Button Handlers
    
    func onTapRequest(height: Int) {
        statusMessageLbl = "Click Request"
        if (pluginToggle) {
            pluginAPI.requestOfferwallDiscover(placementTextField, height: CGFloat(height), delegate: self)
        } 
    }
    
    func onTapClear() {
        pluginAPI.destroyOfferwallDiscover() 
    }
    
    func onTapResize(width: Int, height: Int) {
        if let interfaceOrientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation {
            let largestDimension = max(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
            let smallestDimension = min(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
            if (interfaceOrientation.isLandscape) {
                frameWidthTextField = min(CGFloat(width), largestDimension)
            } else {
                frameWidthTextField = min(CGFloat(width), smallestDimension)
            }
            frameHeightTextField = CGFloat(height)
        }
    }
    
    // MARK: TJDiscoverViewDelegate methods
    
    func requestDidSucceed(for view: TJOfferwallDiscoverView) {
        guard let view = UIApplication.shared.windows.first!.rootViewController!.view else {
            print("Error unwrapping View Controller")
            return
        }
        statusMessageLbl = "ReqeustDidSucceed"
        
        if (pluginToggle) {
                pluginAPI.showOfferwallDiscover(view)
        }
    }
    
    func requestDidFail(for view: TJOfferwallDiscoverView, error: Error?) {
        guard let error = error else { return }
        statusMessageLbl = "RequestDidFail -  \(error.localizedDescription) "
    }
    
    func contentIsReady(for view: TJOfferwallDiscoverView) {
        statusMessageLbl = "contentIsReady"
    }
    
    func contentError(for view: TJOfferwallDiscoverView, error: Error?) {
        guard let error = error else { return }
        statusMessageLbl = "contentError \(error.localizedDescription)"
    }
}
