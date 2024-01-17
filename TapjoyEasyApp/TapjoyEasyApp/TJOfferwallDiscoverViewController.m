//
//  TJOfferwallDiscoverViewController.m
//  TapjoyEasyApp
//
//  Created by Dominic Roberts on 20/06/2022.
//  Copyright © 2022 Tapjoy. All rights reserved.
//

#import "TJOfferwallDiscoverViewController.h"
#import <Tapjoy/Tapjoy.h>
#import <Tapjoy/TapjoyPluginAPI.h>

@interface TJOfferwallDiscoverViewController ()
@property (weak, nonatomic) IBOutlet TJOfferwallDiscoverView *offerwallDiscoverView;
@property (weak, nonatomic) IBOutlet UISwitch *pluginSwitch;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UITextField *placementTextfield;
@property (weak, nonatomic) IBOutlet UITextField *widthTextfield;
@property (weak, nonatomic) IBOutlet UITextField *heightTextfield;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerwallDiscoverViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerwallDiscoverViewWidthConstraint;
@property (nonatomic, strong) TapjoyPluginAPI* pluginAPI;

@end

@implementation TJOfferwallDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self placementTextfield] setText:@"offerwall_discover"];
    [[self offerwallDiscoverView] setDelegate:self];
    [self setPluginAPI:[[TapjoyPluginAPI alloc] init]];
        
    [[self widthTextfield] setKeyboardType:UIKeyboardTypeNumberPad];
    [[self heightTextfield] setKeyboardType:UIKeyboardTypeNumberPad];
    
    [self updateLayoutWithViewSize:self.view.frame.size];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self updateLayoutWithViewSize:size];
}

- (void)updateLayoutWithViewSize:(CGSize)size {
    [[self offerwallDiscoverViewWidthConstraint] setConstant:size.width];
    [[self widthTextfield] setText:[NSString stringWithFormat:@"%ld", (long)floorf([[self offerwallDiscoverViewWidthConstraint] constant])]];
    [[self heightTextfield] setText:[NSString stringWithFormat:@"%ld", (long)floorf([[self offerwallDiscoverViewHeightConstraint] constant])]];
}

#pragma mark UIButton Handlers
- (IBAction)onClickRequest:(id)sender {
    [[self statusLbl] setText:@"Click Request"];
    if ([[self pluginSwitch] isOn]) {
        CGFloat height = [[[self heightTextfield] text] floatValue];
        [[self pluginAPI] requestOfferwallDiscover:[[self placementTextfield] text] height:height delegate:self];
    } else {
        [[self offerwallDiscoverView] request:[[self placementTextfield] text]];
    }
    
}

- (IBAction)onClickClear:(id)sender {
    [[self statusLbl] setText:@"Click Clear"];
    
    if ([[self pluginSwitch] isOn]) {
        [[self pluginAPI] destroyOfferwallDiscover];
    } else {
        [[self offerwallDiscoverView] clear];
    }
}
- (IBAction)onClickResize:(id)sender {
    CGFloat width = [[[self widthTextfield] text] floatValue];
    CGFloat height = [[[self heightTextfield] text] floatValue];
    
    [[self offerwallDiscoverViewWidthConstraint] setConstant:width];
    [[self offerwallDiscoverViewHeightConstraint] setConstant:height];
    
    [[self widthTextfield] endEditing:YES];
    [[self heightTextfield] endEditing:YES];
}

#pragma mark TJDiscoverViewDelegate methods
- (void)requestDidSucceedForView:(TJOfferwallDiscoverView *)view {
    [[self statusLbl] setText:@"RequestDidSucceed"];
    
    if ([[self pluginSwitch] isOn]) {
        [[self pluginAPI] showOfferwallDiscover:[[[[UIApplication sharedApplication] keyWindow] rootViewController] view]];
    }
}

- (void)requestDidFailForView:(TJOfferwallDiscoverView *)view error:(NSError *)error {
    [[self statusLbl] setText:[NSString stringWithFormat:@"RequestDidFail - %ld %@", [error code], [error localizedDescription]]];
}

- (void)contentIsReadyForView:(TJOfferwallDiscoverView *)view {
    [[self statusLbl] setText:@"contentIsReady"];
}

- (void)contentErrorForView:(TJOfferwallDiscoverView *)view error:(NSError *)error {
    [[self statusLbl] setText:[NSString stringWithFormat:@"contentError - %ld %@", [error code], [error localizedDescription]]];
}

@end
