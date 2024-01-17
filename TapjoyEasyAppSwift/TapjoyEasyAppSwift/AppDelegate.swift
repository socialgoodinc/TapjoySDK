//
//  AppDelegate.swift
//  TapjoyEasyAppSwift
//
//  Created by Luke Bowman on 30/09/2022.
//
import SwiftUI
import UIKit
import Tapjoy
import os
import AppTrackingTransparency


class AppDelegate: NSObject, UIApplicationDelegate, TJPlacementDelegate, TJPlacementVideoDelegate, ObservableObject {
    
    @Published var placementString = ""
    @Published var sdkVersion = Tapjoy.getVersion()
    @Published var debugSwitch = true
    @Published var statusMessage = "Status Message"
    @Published var supportURLString = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var manualConnect = false
    @Published var currencyId = ""
    @Published var currencyBalanceString = ""
    @Published var currencyRequiredAmountString = ""
    var selectedEntryPoint = TJEntryPoint.unknown;
    var entryPoints: [TJEntryPoint] = [ .unknown, .other, .mainMenu, .hud, .exit, .fail, .complete, .inbox, .initialisation, .store ]

    func titleFor(entryPoint: TJEntryPoint) -> String {
        switch entryPoint {
        case .other:
            return "Other"
        case .mainMenu:
            return "Main Menu"
        case .hud:
            return "Head-up Display"
        case .exit:
            return "Exit"
        case .fail:
            return "Level Failed"
        case .complete:
            return "Level Complete"
        case .inbox:
            return "Inbox"
        case .initialisation:
            return "Initialisation"
        case .store:
            return "Store"
        case .unknown:
            fallthrough
        default:
            return "Select"
        }
    }

    let PlacementNameKey = "placementName"
    let defaults = UserDefaults.standard
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "network")
    let DEFAULT_KEY = "E7CuaoUWRAWdz_5OUmSGsgEBXHdOwPa8de7p4aseeYP01mecluf-GfNgtXlF"
    
    var directPlayPlacement = TJPlacement()
    var offerwallPlacement = TJPlacement()
    var testPlacement = TJPlacement()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.tjcConnectSuccess(notif:)), name: NSNotification.Name(rawValue: TJC_CONNECT_SUCCESS), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.tjcConnectFail(notif:)), name: NSNotification.Name(rawValue: TJC_CONNECT_FAILED), object: nil)
        
        placementString = defaults.string(forKey: PlacementNameKey) ?? ""
        //Turn on Tapjoy debug mode
        Tapjoy.setDebugEnabled(true) //Only enable debug mode for development. Disable it before publishing your app.
        
        return true
    }
    
    func connectToTapjoy() {
        
        //If you are using Self-Managed currency, you need to set a user ID using the connect flags.
        //           let connectFlags = [TJC_OPTION_USER_ID : "<USER_ID_HERE>"]
        //           Tapjoy.connect("E7CuaoUWRAWdz_5OUmSGsgEBXHdOwPa8de7p4aseeYP01mecluf-GfNgtXlF", options: connectFlags)
        
        //If you are not using connect flags, you can omit them
        
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            if(self.defaults.bool(forKey: "autoConnectStatus") || self.manualConnect) {
                Tapjoy.connect(self.defaults.string(forKey: "sdkDefaultKey") ?? self.DEFAULT_KEY )
                self.attResponse(status: status)
            } else if (!Tapjoy.isConnected()) {
                self.statusMessage = "Tapjoy not connected to new key."
            }
        })
    }
    
    func attResponse(status: ATTrackingManager.AuthorizationStatus) {
        switch status {
        case .authorized:
            logger.log("App tracking permission is authorized")
        case .denied:
            logger.log("App tracking permission is denied")
        case .notDetermined:
            logger.log("App tracking permission is not determined")
        case .restricted:
            logger.log("App tracking permission is restricted")
        default:
            logger.log("")
        }
    }
    
    func placementNameDidChange(){
        defaults.removeObject(forKey: PlacementNameKey)
        defaults.set(placementString, forKey: PlacementNameKey)
    }
    
    // MARK: Tapjoy Related Methods
    
    @objc func tjcConnectSuccess(notif: NSNotification) {
        logger.log("Tapjoy connect succeeded")
        
        statusMessage = "Tapjoy Connect succeeded"
        
        if let optionalDirectPlay = TJPlacement(name: "video_unit", delegate: self) {
            directPlayPlacement = optionalDirectPlay
        }
        
        if let optionalOfferwall =  TJPlacement(name: "offerwall_unit", delegate: self) {
            offerwallPlacement = optionalOfferwall
        }
        if let urlString = Tapjoy.getSupportURL() {
            supportURLString = urlString
        }
    }
    
    @objc func tjcConnectFail(notif: NSNotification) {
        var message = "Tapjoy Connect Failed"
        if let error = notif.userInfo?[TJC_CONNECT_USER_INFO_ERROR] as? NSError {
            message.append("\nError: \(error.code) - \(error.localizedDescription)")
            if let underlyingError = error.userInfo[NSUnderlyingErrorKey] as? NSError {
                message.append("\nUnderlying Error: \(underlyingError.code) - \(underlyingError.localizedDescription)")
            }
        }
        logger.log("\(message)")
        statusMessage = message
        manualConnect = false
    }
    
    func getDirectPlayVideoAdAction() {
        if (directPlayPlacement.isContentAvailable) {
            
            if (directPlayPlacement.isContentReady) {
                directPlayPlacement.showContent(with: nil)
            }
            else {
                statusMessage = "Direct play video not ready to show"
            }
        }
        else {
            statusMessage = "No direct play video to show"
        }
        
        if (!directPlayPlacement.isContentAvailable) {
            directPlayPlacement.requestContent()
        }
    }
    
    func showOfferwallAction() {
        if (offerwallPlacement.isContentReady) {
            offerwallPlacement.showContent(with: nil)
            statusMessage = "Offerwall request success"
        }
        if (!offerwallPlacement.isContentAvailable) {
            offerwallPlacement.entryPoint = selectedEntryPoint
            if currencyId.count > 0 {
                if currencyBalanceString.count > 0, let balance = Int(currencyBalanceString) {
                    offerwallPlacement.setBalance(balance, forCurrencyId: currencyId) { error in
                        if let error = error {
                            print("Failed to set currency balance:\n\t\(self.currencyId)\n\t\(balance)\n\t\(error.localizedDescription)")
                        }
                    }
                }


                if currencyRequiredAmountString.count > 0, let requiredAmount = Int(currencyRequiredAmountString) {
                    offerwallPlacement.setRequiredAmount(requiredAmount, forCurrencyId: currencyId) { error in
                        if let error = error {
                            print("Failed to set currency required amount:\n\t\(self.currencyId)\n\t\(requiredAmount)\n\t\(error.localizedDescription)")
                        }
                    }
                }
            }
            offerwallPlacement.requestContent()
        }
    }
    
    func getCurrencyBalanceAction() {
        Tapjoy.getCurrencyBalance(completion: { parameters, error in
            
            if let balanceError = error {
                self.statusMessage = "getCurrencyBalance error: \(balanceError.localizedDescription)"
            }
            else {
                guard let params = parameters else {
                    self.statusMessage = "getCurrencyBalance error: Missing parameters"
                    return
                }
                if let currencyName = params["currencyName"], let amount = params["amount"] {
                    self.statusMessage = "getCurrencyBalance returned \(currencyName): \(amount)"
                }
            }
        })
    }
    
    func spendCurrencyAction() {
        Tapjoy.spendCurrency(10, completion: { parameters, error in
            if let spendError = error {
                self.statusMessage = "spendCurrency error: \(spendError.localizedDescription)"
            }
            else {
                guard let params = parameters else {
                    self.statusMessage = "spendCurrency error: Missing parameters"
                    return
                }
                if let currencyName = params["currencyName"], let amount = params["amount"] {
                    self.statusMessage = "spendCurrency returned \(currencyName): \(amount)"
                }
            }
        })
    }
    
    func awardCurrencyAction() {
        Tapjoy.awardCurrency(10, completion: { parameters, error in
            if let awardError = error {
                self.statusMessage = "awardCurrency error: \(awardError.localizedDescription)"
            }
            else{
                guard let params = parameters else {
                    self.statusMessage = "awardCurrency error: Missing parameters"
                    return
                }
                if let currencyName = params["currencyName"], let amount = params["amount"] {
                    self.alertMessage = "You've been awarded \(amount) \(currencyName)!"
                    self.showAlert = true
                    
                    self.statusMessage = "awardCurrency returned \(currencyName): \(amount)"
                }
            }
        })
    }
    
    func requestContentAction(placementName: String) {
        if (!placementName.isEmpty) {
            if let test = TJPlacement(name: placementName, delegate: self) {
                testPlacement = test
            }
            testPlacement.videoDelegate = self
            testPlacement.entryPoint = selectedEntryPoint
            if currencyId.count > 0 {
                if currencyBalanceString.count > 0, let balance = Int(currencyBalanceString) {
                    testPlacement.setBalance(balance, forCurrencyId: currencyId) { error in
                        if let error = error {
                            print("Failed to set currency balance:\n\t\(self.currencyId)\n\t\(balance)\n\t\(error.localizedDescription)")
                        }
                    }
                }

                if currencyRequiredAmountString.count > 0, let requiredAmount = Int(currencyRequiredAmountString) {
                    testPlacement.setRequiredAmount(requiredAmount, forCurrencyId: currencyId) { error in
                        if let error = error {
                            print("Failed to set currency required amount:\n\t\(self.currencyId)\n\t\(requiredAmount)\n\t\(error.localizedDescription)")
                        }
                    }
                }
            }
            testPlacement.requestContent()
            statusMessage = "Requesting content for placement \(placementName)"
        }
        else {
            statusMessage = "Invalid placement!"
            logger.log("Invalid Placement")
        }
    }
    
    func showContentAction() {
        if (testPlacement.isContentAvailable) {
            testPlacement.showContent(with: nil)
        }
    }
    
    func sendPurchaseEventAction() {
        Tapjoy.trackPurchase("product1", currencyCode: "USD", price: 0.99, campaignId: nil, transactionId: nil)
    }
    
    func sendPurchaseWithCampaignEventAction() {
        Tapjoy.trackPurchase("product2", currencyCode: "USD", price: 1.99, campaignId: "TestCampaignID", transactionId: nil)
        
    }
    
    func toggleDebugEnabled() {
        Tapjoy.setDebugEnabled(debugSwitch)
    }
    
    // MARK: TJPlacementDelegate methods
    
    func requestDidSucceed(_ placement: TJPlacement) {
        statusMessage = "Tapjoy request content complete, isContentAvailable:\(placement.isContentAvailable)"
        
        if (placement.isContentAvailable) {
            if(placement == offerwallPlacement || placement == directPlayPlacement) {
                placement.showContent(with: nil )
            }
        }
    }
    
    func requestDidFail(_ placement: TJPlacement, error: Error?) {
        statusMessage = "Tapjoy request content failed with error \(String(describing: error?.localizedDescription))"
    }
    
    func contentIsReady(_ placement: TJPlacement) {
        statusMessage = "Tapjoy placement content is ready to display"
    }
    
    func contentDidAppear(_ placement: TJPlacement) {
        logger.log("Content did appear for \(placement.placementName) placement")
    }
    
    func contentDidDisappear(_ placement: TJPlacement) {
        logger.log("Content did disappear for \(placement.placementName) placement")
    }
    
    func didClick(_ placement: TJPlacement) {
        logger.log("didClick for \(placement.placementName) placement")
    }
    
    func placement(_ placement: TJPlacement, didRequestPurchase request: TJActionRequest?, productId: String?) {
        
        if let token = request?.token, let prod = productId, let requestId = request?.requestId{
            let message = "didRequestPurchase -- productId: \(String(describing: prod)), token: \(String(describing: token)), requestId: \(String(describing: requestId)) "
            
            showAlert = true
            alertMessage = message
        }
        request?.completed()
    }
    
    func placement(_ placement: TJPlacement, didRequestReward request: TJActionRequest?, itemId: String?, quantity: Int32) {
        
        if let token = request?.token, let item = itemId, let requestId = request?.requestId {
            let message = "didRequestReward -- itemId: \(String(describing: item)), quantity: \(quantity), token: \(String(describing: token)), requestId: \(String(describing: requestId))"
            
            showAlert = true
            alertMessage = message
        }
        request?.completed()
    }
    
    func placement(_ placement: TJPlacement, didRequestCurrency request: TJActionRequest?, currency: String?, amount: Int32) {
        
        if let token = request?.token, let curr = currency, let requestId = request?.requestId {
            let message = "didRequestCurrency -- currency: \(String(describing: curr)), amount: \(amount), token: \(String(describing: token)), requestId: \(String(describing: requestId))"
            
            showAlert = true
            alertMessage = message
        }
        request?.completed()
    }
    
    func placement(_ placement: TJPlacement, didRequestNavigation request: TJActionRequest?, location: String?) {
        
        if let token = request?.token, let loc = location, let requestId = request?.requestId{
            let message = "didRequestNavigation -- location: \(String(describing: loc)), token: \(String(describing: token)), requestId: \(String(describing: requestId))"
            
            showAlert = true
            alertMessage = message
        }
        request?.completed()
    }
    
    // MARK: Tapjoy Video methods
    func videoDidStart(_ placement: TJPlacement) {
        logger.log("Video did start for: \(placement.placementName)")
    }
    
    func videoDidComplete(_ placement: TJPlacement) {
        logger.log("Video has completed for: \(placement.placementName)")
    }
    
    func videoDidFail(_ placement: TJPlacement, error errorMsg: String?) {
        logger.log("Video did fail for: \(placement.placementName) with error: \(errorMsg ?? "")")
    }
}
