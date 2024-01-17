//
//  CustomEventsViewModel.swift
//  TapjoyEasyAppSwift
//
//  Created by Luke Bowman on 11/10/2022.
//

import Foundation
import Tapjoy

class CustomEventsViewModel: ObservableObject{
    @Published var statusMessage = "Status Message"
    
    func noneButton() {
        Tapjoy.trackEvent("SDKTestEvent", category: "test", parameter1: nil, parameter2: nil)
        statusMessage = "trackEvent with category: test"
    }
    
    func p1EventButton() {
        Tapjoy.trackEvent("SDKTestEvent", category: "test", parameter1: "testP1", parameter2: nil)
        statusMessage = "trackEvent with category: test, p1:testP1"
    }
    
    func vEventButton() {
        Tapjoy.trackEvent("SDKTestEvent", category: "test", parameter1: nil, parameter2: nil, value: 78)
        statusMessage = "trackEvent with category: test, v:78"
    }
    
    func p1p2EventButton() {
        Tapjoy.trackEvent("SDKTestEvent", category: "test", parameter1: "testP1", parameter2: "testP2")
        statusMessage = "trackEvent with category: test, p1:testP1, p2:testP2"
    }
    
    func p1vEventButton() {
        Tapjoy.trackEvent("SDKTestEvent", category: "test", parameter1: "testp1", parameter2: nil, value: 234)
        statusMessage = "trackEvent with category: test, p1:testP1, v:234"
    }
    
    func p1p2vEventButton() {
        Tapjoy.trackEvent("SDKTestEvent", category: "test", parameter1: "testP1", parameter2: "testP2", value: 56789)
        statusMessage = "trackEvent with category: test, p1:testP1, p2:testP2, v:56789"
    }
    
    func p1p2v1v2EventButton() {
        Tapjoy.trackEvent("SDKTestEvent", category: "test", parameter1: "testP1", parameter2: "testP2", value1name: "v1", value1: 1, value2name: "v2", value2: 99)
        statusMessage = "trackEvent with category: test, p1:testP1, p2:testP2, v1name:v1, v1:1, v2name:v2, v2:99"
    }
    
    func allEventButton() {
        Tapjoy.trackEvent("SDKTestEvent", category: "test", parameter1: "testP1", parameter2: "testP2", value1name: "v1", value1: 5, value2name: "v2", value2: 19, value3name: "v3", value3: 985)
        statusMessage = "trackEvent with category: test, p1:testP1, p2:testP2, v1name:v1, v1:5, v2name:v2, v2:19, v3name:v3, v3:985"
    }
}
