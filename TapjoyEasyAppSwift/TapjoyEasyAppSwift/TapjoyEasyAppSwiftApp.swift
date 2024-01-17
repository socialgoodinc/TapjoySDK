//
//  TapjoyEasyAppSwiftApp.swift
//  TapjoyEasyAppSwift
//
//  Created by Luke Bowman on 26/09/2022.
//

import SwiftUI
import UIKit
import Tapjoy
import os

// no changes in your AppDelegate class


@main
struct TapjoyEasyAppSwiftApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
