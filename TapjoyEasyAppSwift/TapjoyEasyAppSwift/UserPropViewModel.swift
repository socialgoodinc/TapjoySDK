//
//  UserPropViewModel.swift
//  TapjoyEasyAppSwift
//
//  Created by Luke Bowman on 10/10/2022.
//

import Foundation
import Tapjoy

final class UserPropViewModel: ObservableObject {

    @Published var statusMessage: String = "Status Message"
    @Published var userId: String = ""
    @Published var level: String = ""
    @Published var friends: String = ""
    @Published var cohort1: String = ""
    @Published var cohort2: String = ""
    @Published var cohort3: String = ""
    @Published var cohort4: String = ""
    @Published var cohort5: String = ""
    @Published var userTag: String = ""
    @Published var userSegmentValue: Int = 3
    @Published var maxLevel: String = ""
    
    @Published var belowConsentAge = 2
    @Published var subjectToGDPR = 2
    @Published var userConsent = 2
    @Published var usPrivacy = ""
    
    init() {
        setPrivacyValuesOnLoad()
    }

    // MARK: User Property Methods
    
    func setProperties() {

        Tapjoy.setUserLevel(Int32(level) ?? 0)
        Tapjoy.setMaxLevel(Int32(maxLevel) ?? 0)
        Tapjoy.setUserFriendCount(Int32(friends) ?? 0)
        Tapjoy.setUserCohortVariable(1, value: cohort1)
        Tapjoy.setUserCohortVariable(2, value: cohort2)
        Tapjoy.setUserCohortVariable(3, value: cohort3)
        Tapjoy.setUserCohortVariable(4, value: cohort4)
        Tapjoy.setUserCohortVariable(5, value: cohort5)
        let segment = TJSegment(rawValue: userSegmentValue) ?? .unknown
        Tapjoy.setUserSegment(userSegmentValue == 3 ? .unknown : segment)
        Tapjoy.setUserIDWithCompletion(userId, completion: nil)
        
        setLocalProperties()

    }
    
    func clearProperties() {
        
        Tapjoy.setUserLevel(-1)
        Tapjoy.setMaxLevel(0)
        Tapjoy.setUserFriendCount(-1)
        Tapjoy.setUserCohortVariable(1, value: nil)
        Tapjoy.setUserCohortVariable(2, value: nil)
        Tapjoy.setUserCohortVariable(3, value: nil)
        Tapjoy.setUserCohortVariable(4, value: nil)
        Tapjoy.setUserCohortVariable(5, value: nil)
        Tapjoy.setUserSegment(TJSegment.unknown)

        clearLocalProperties()

    }
    
    func addUserTag() {
        Tapjoy.addUserTag(userTag)
        userTag = ""
    }
    
    func removeUserTag() {
        Tapjoy.removeUserTag(userTag)
        userTag = ""
    }
    
    func clearUserTag() {
        Tapjoy.setUserTags(nil)
        userTag = ""
    }
    
    // MARK: User Privacy Methods
    
    func setPrivacyValuesOnLoad() {
        let privacyPolicy = Tapjoy.getPrivacyPolicy()
        
        belowConsentAge = convertStatusToSegment(status: privacyPolicy.belowConsentAgeStatus)
        subjectToGDPR = convertStatusToSegment(status: privacyPolicy.subjectToGDPRStatus)
        userConsent = convertStatusToSegment(status: privacyPolicy.userConsentStatus)
        usPrivacy = privacyPolicy.usPrivacy ?? ""
    }
    
    func convertStatusToSegment(status: TJStatus) -> Int {
        switch (status) {
        case .true:
            return 0
        case .false:
            return 1
        default:
            return 2
        }
    }
    
    func convertSegmentToStatus(segment: Int) -> TJStatus {
        switch (segment) {
        case 0:
            return TJStatus.true
        case 1:
            return TJStatus.false
        default:
            return TJStatus.unknown
        }
    }
    
    func setBelowConsentAge(status: Int) {
        let belowConsentAgeStatus = convertSegmentToStatus(segment: status)
        TJPrivacyPolicy.sharedInstance().belowConsentAgeStatus = belowConsentAgeStatus
        statusMessage = "Set Below Consent Age Status to \(getStatusAsString(status: belowConsentAgeStatus))"
    }
    
    func setSubjectToGDPR(status: Int) {
        let subjectToGDPRStatus = convertSegmentToStatus(segment: status)
        TJPrivacyPolicy.sharedInstance().subjectToGDPRStatus = subjectToGDPRStatus
        statusMessage = "Set Subject to GDPR Status to \(getStatusAsString(status: subjectToGDPRStatus))"
    }
    
    func setUserConsent(status: Int) {
        let userConsentStatus = convertSegmentToStatus(segment: status)
        TJPrivacyPolicy.sharedInstance().userConsentStatus = userConsentStatus
        statusMessage = "Set User Consent Status to \(getStatusAsString(status: userConsentStatus))"
    }
    
    func setUSPrivacy(value: String) {
        TJPrivacyPolicy.sharedInstance().usPrivacy = value
        statusMessage = "Set US Privacy to \(value)"
    }
    
    
    func getStatusAsString(status: TJStatus) -> String {
        switch (status) {
        case .true:
            return "True"
        case .false:
            return "False"
        default:
            return "Unknown"
        }
    }

    // MARK: Local Methods
    
    /*
     * These methods are not required for implementation. They're simply to show on the EasyApp what has previously been set between sessions.
     */
     
    func setLocalProperties() {
        let defaults = UserDefaults.standard
        defaults.set(userId, forKey: "LOCAL_USERID")
        defaults.set(level, forKey: "LOCAL_LEVEL")
        defaults.set(maxLevel, forKey:"LOCAL_MAX_LEVEL")
        defaults.set(friends, forKey: "LOCAL_FRIENDS")
        defaults.set(cohort1, forKey: "LOCAL_COHORT_1")
        defaults.set(cohort2, forKey: "LOCAL_COHORT_2")
        defaults.set(cohort3, forKey: "LOCAL_COHORT_3")
        defaults.set(cohort4, forKey: "LOCAL_COHORT_4")
        defaults.set(cohort5, forKey: "LOCAL_COHORT_5")
        defaults.set(userSegmentValue, forKey: "LOCAL_USER_SEGMENT")
    }
    
    func getLocalProperties() {
        let defaults = UserDefaults.standard
        userId = "\(defaults.object(forKey: "LOCAL_USERID") ?? "")"
        level = "\(defaults.object(forKey: "LOCAL_LEVEL") ?? "")"
        maxLevel = "\(Tapjoy.getMaxLevel())"
        friends = "\(defaults.object(forKey: "LOCAL_FRIENDS") ?? "")"
        cohort1 = "\(defaults.object(forKey: "LOCAL_COHORT_1") ?? "")"
        cohort2 = "\(defaults.object(forKey: "LOCAL_COHORT_2") ?? "")"
        cohort3 = "\(defaults.object(forKey: "LOCAL_COHORT_3") ?? "")"
        cohort4 = "\(defaults.object(forKey: "LOCAL_COHORT_4") ?? "")"
        cohort5 = "\(defaults.object(forKey: "LOCAL_COHORT_5") ?? "")"
        userSegmentValue = defaults.object(forKey: "LOCAL_USER_SEGMENT") as? Int ?? 3
    }
    
    func clearLocalProperties() {
        userId = ""
        level = ""
        maxLevel = ""
        friends = ""
        cohort1 = ""
        cohort2 = ""
        cohort3 = ""
        cohort4 = ""
        cohort5 = ""
        userSegmentValue = 3
        setLocalProperties()
    }
    
}
