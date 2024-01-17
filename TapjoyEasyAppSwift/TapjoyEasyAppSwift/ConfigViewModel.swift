//
//  ConfigViewModel.swift
//  TapjoyEasyAppSwift
//
//  Created by Luke Bowman on 04/01/2023.
//

import Foundation
import Tapjoy
import Combine

class ConfigViewModel: ObservableObject {
    
    
    @Published var statusMessage = "Status Message"
    @Published(key: "autoConnectStatus") var autoConnect = true
    @Published(key: "sdkDefaultKey") var keyTextField = "E7CuaoUWRAWdz_5OUmSGsgEBXHdOwPa8de7p4aseeYP01mecluf-GfNgtXlF"
    @Published var keyArray: [String]
    let defaults = UserDefaults.standard
    
    init() {
        self.keyArray = defaults.stringArray(forKey: "arrayOfSdkKeys") ?? ["E7CuaoUWRAWdz_5OUmSGsgEBXHdOwPa8de7p4aseeYP01mecluf-GfNgtXlF"]
    }
    
    func textFieldDidBeginEditing() {
        restartAppMeesage()
    }
    
    func clearButtonPressed() {
        keyTextField = ""
    }
    
    func addButtonPressed() {
        if (keyTextField.count > 50) {
            setAndSaveKey()
            defaults.set(keyArray, forKey: "arrayOfSdkKeys")
            defaults.set(keyTextField, forKey: "sdkDefaultKey")
        } else {
            statusMessage = "Please enter a valid key length"
        }
    }
    
    func setAndSaveKey() {
        if (!keyArray.contains(keyTextField)) {
            keyArray.append(keyTextField)
        }
    }
    
    func pickerDidSelect() {
        defaults.set(keyTextField, forKey: "sdkDefaultKey")
    }
    
    func autoConnectToTapjoy() {
        defaults.set(autoConnect, forKey:"autoConnectStatus")
    }
    
    func restartAppMeesage() {
        statusMessage = "To connect with new key please restart app."
    }
}

fileprivate var cancellables = [String : AnyCancellable] ()

public extension Published {
    init(wrappedValue defaultValue: Value, key: String) {
        let value = UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
        self.init(initialValue: value)
        cancellables[key] = projectedValue.sink { val in
            UserDefaults.standard.set(val, forKey: key)
        }
    }
}
