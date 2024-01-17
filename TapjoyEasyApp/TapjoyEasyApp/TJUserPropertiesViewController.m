// Copyright (C) 2014 - 2018 by Tapjoy Inc.
//
// This file is part of the Tapjoy SDK.
//
// By using the Tapjoy SDK in your software, you agree to the terms of the Tapjoy SDK License Agreement.
//
// The Tapjoy SDK is bound by the Tapjoy SDK License Agreement and can be found here: https://www.tapjoy.com/sdk/license

#import "TJUserPropertiesViewController.h"
#import <Tapjoy/Tapjoy.h>

@interface TJUserPropertiesViewController ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UITextField *userIdField;
@property (weak, nonatomic) IBOutlet UITextField *levelField;
@property (weak, nonatomic) IBOutlet UITextField *friendField;
@property (weak, nonatomic) IBOutlet UITextField *cohort1Field;
@property (weak, nonatomic) IBOutlet UITextField *cohort2Field;
@property (weak, nonatomic) IBOutlet UITextField *cohort3Field;
@property (weak, nonatomic) IBOutlet UITextField *cohort4Field;
@property (weak, nonatomic) IBOutlet UITextField *cohort5Field;
@property (weak, nonatomic) IBOutlet UITextField *userTagsField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *userSegmentControl;

@property (weak, nonatomic) IBOutlet UIButton *setButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UIButton *clearUserTagButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *belowConsentAgeControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *subjectToGDPRControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *userConsentControl;
@property (weak, nonatomic) IBOutlet UITextField *usPrivacyField;
@property (weak, nonatomic) IBOutlet UIButton *setUSPrivacyButton;
@property (weak, nonatomic) IBOutlet UITextField *maxLevelField;


@end

@implementation TJUserPropertiesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.usPrivacyField.delegate = self;
    NSInteger userSegment = [Tapjoy getUserSegment];
    if (userSegment == -1) {
        _userSegmentControl.selectedSegmentIndex = 3;
    } else if (userSegment >= 0 && userSegment <= 2) {
        _userSegmentControl.selectedSegmentIndex = userSegment;
    }
    
    self.maxLevelField.delegate = self;
    self.maxLevelField.text = [[Tapjoy getMaxLevel] stringValue];
    [self setPrivacyValuesOnLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark UserProperties Methods

- (IBAction)setProperties:(id)sender
{
	[Tapjoy setUserLevel:[_levelField.text intValue]];
    [Tapjoy setMaxLevel:[_maxLevelField.text intValue]];
	[Tapjoy setUserFriendCount:[_friendField.text intValue]];
	[Tapjoy setUserCohortVariable:1 value:_cohort1Field.text];
	[Tapjoy setUserCohortVariable:2 value:_cohort2Field.text];
	[Tapjoy setUserCohortVariable:3 value:_cohort3Field.text];
	[Tapjoy setUserCohortVariable:4 value:_cohort4Field.text];
	[Tapjoy setUserCohortVariable:5 value:_cohort5Field.text];
    [Tapjoy setUserSegment:(_userSegmentControl.selectedSegmentIndex == 3) ? TJSegmentUnknown : (int)_userSegmentControl.selectedSegmentIndex];
    
    //TODO: smarter setting--only set if value changed, type check for ints, etc
    [Tapjoy setUserIDWithCompletion:_userIdField.text completion:^(BOOL success, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Set User ID Failed:\n  %@\n\n  Underlying error: %@", error.localizedDescription, [error.userInfo[NSUnderlyingErrorKey] localizedDescription]);
        }
    }];
}

- (IBAction)clearProperties:(id)sender
{
	// TODO: Tapjoy setUserID cannot be nil
	// [Tapjoy setUserID:nil];
	
	[Tapjoy setUserLevel:-1];
    [Tapjoy setMaxLevel:-1];
	[Tapjoy setUserFriendCount:-1];
	[Tapjoy setUserCohortVariable:1 value:nil];
	[Tapjoy setUserCohortVariable:2 value:nil];
	[Tapjoy setUserCohortVariable:3 value:nil];
	[Tapjoy setUserCohortVariable:4 value:nil];
	[Tapjoy setUserCohortVariable:5 value:nil];
    [Tapjoy setUserSegment:TJSegmentUnknown];
    
	
	_userIdField.text = nil;
	_levelField.text = nil;
    _maxLevelField.text = nil;
	_friendField.text = nil;
	_cohort1Field.text = nil;
	_cohort2Field.text = nil;
	_cohort3Field.text = nil;
	_cohort4Field.text = nil;
	_cohort5Field.text = nil;
    _userSegmentControl.selectedSegmentIndex = 3;
}

- (IBAction)addUserTag:(id)sender {
    [Tapjoy addUserTag:_userTagsField.text];
    _userTagsField.text = nil;
}

- (IBAction)removeUserTag:(id)sender {
    [Tapjoy removeUserTag:_userTagsField.text];
    _userTagsField.text = nil;
}

- (IBAction)clearUserTag:(id)sender {
    [Tapjoy setUserTags:nil];
    _userTagsField.text = nil;
}

#pragma mark UserPrivacy Methods

- (void)setPrivacyValuesOnLoad {
    TJPrivacyPolicy *privacyPolicy = [Tapjoy getPrivacyPolicy];
    
    self.belowConsentAgeControl.selectedSegmentIndex = [self status:privacyPolicy.belowConsentAgeStatus toSegment:self.belowConsentAgeControl];
    
    self.subjectToGDPRControl.selectedSegmentIndex = [self status:privacyPolicy.subjectToGDPRStatus toSegment:self.subjectToGDPRControl];
    
    self.userConsentControl.selectedSegmentIndex = [self status:privacyPolicy.userConsentStatus toSegment:self.userConsentControl];
    
    self.usPrivacyField.text = privacyPolicy.USPrivacy;

}

- (NSInteger)status:(TJStatus)status toSegment:(UISegmentedControl *)segment {
    switch (status) {
        case TJStatusTrue:
            return 0;
        case TJStatusFalse:
            return 1;
        default:
            return 2;
    }
}

- (TJStatus)segment:(UISegmentedControl *)segment toStatus:(NSString *)status {
    switch (segment.selectedSegmentIndex) {
        case 0:
            self.statusLabel.text = [NSString stringWithFormat:@"Set %@ to True", status];
            return TJStatusTrue;
        case 1:
            self.statusLabel.text = [NSString stringWithFormat:@"Set %@ to False", status];
            return TJStatusFalse;
        default:
            self.statusLabel.text = [NSString stringWithFormat:@"Set %@ to Not Set", status];
            return TJStatusUnknown;
    }
}

- (IBAction)setBelowConsentAge:(id)sender {
    TJStatus belowConsentAgeStatus = [self segment:self.belowConsentAgeControl toStatus:@"Below Consent Age Status"];
    [[TJPrivacyPolicy sharedInstance] setBelowConsentAgeStatus:belowConsentAgeStatus];
}
- (IBAction)setSubjectToGDPR:(id)sender {
    TJStatus subjectToGDPRStatus = [self segment:self.subjectToGDPRControl toStatus:@"Subject to GDPR Status"];
    [[TJPrivacyPolicy sharedInstance] setSubjectToGDPRStatus:subjectToGDPRStatus];
}
- (IBAction)setUserConsent:(id)sender {
    TJStatus userConsentStatus = [self segment:self.userConsentControl toStatus:@"User Consent Status"];
    [[TJPrivacyPolicy sharedInstance] setUserConsentStatus:userConsentStatus];
}

- (IBAction)setUSPrivacy:(id)sender {
    NSString *usPrivacyValue = self.usPrivacyField.text;
    [[TJPrivacyPolicy sharedInstance] setUSPrivacy:usPrivacyValue];
    self.statusLabel.text = [NSString stringWithFormat:@"Set US Privacy to %@", usPrivacyValue];
}

#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
