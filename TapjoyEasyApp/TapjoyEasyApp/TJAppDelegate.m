// Copyright (C) 2014 - 2018 by Tapjoy Inc.
//
// This file is part of the Tapjoy SDK.
//
// By using the Tapjoy SDK in your software, you agree to the terms of the Tapjoy SDK License Agreement.
//
// The Tapjoy SDK is bound by the Tapjoy SDK License Agreement and can be found here: https://www.tapjoy.com/sdk/license

#import "TJAppDelegate.h"
#import <UserNotifications/UserNotifications.h>
@import Tapjoy;
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@implementation TJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Tapjoy Connect Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tjcConnectSuccess:)
                                                 name:TJC_CONNECT_SUCCESS
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tjcConnectFail:)
                                                 name:TJC_CONNECT_FAILED
                                               object:nil];
	
    // Registering for remote notifications
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        // iOS 10+ Notifications
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound
                                                                            completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                                                                if (granted) {
                                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                                        [application registerForRemoteNotifications];
                                                                                    });
                                                                                }
                                                                            }];
    }
	
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Show ATT prompt and connect
    [self fetchTrackingAuthorization];
    
	// Add an observer for when a user has successfully earned currency.
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(showEarnedCurrencyAlert:)
												 name:TJC_CURRENCY_EARNED_NOTIFICATION
											   object:nil];
	
	// Best Practice: We recommend calling getCurrencyBalance as often as possible so the user’s balance is always up-to-date.
	[Tapjoy getCurrencyBalance];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Remove this to prevent the possibility of multiple redundant notifications.
	[[NSNotificationCenter defaultCenter] removeObserver:self name:TJC_CURRENCY_EARNED_NOTIFICATION object:nil];
}

- (void)fetchTrackingAuthorization {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *keyArray = [[defaults arrayForKey: @"arrayOfSdkKeys"] mutableCopy];
    bool autoConnect = [defaults boolForKey:@"autoConnectStatus"];
    
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            
            switch (status) {
                case ATTrackingManagerAuthorizationStatusDenied:
                    NSLog(@"App tracking permission is denied");
                    break;
                    
                case ATTrackingManagerAuthorizationStatusAuthorized:
                    NSLog(@"App tracking permission is authorized");
                    break;
                    
                case ATTrackingManagerAuthorizationStatusRestricted:
                    NSLog(@"App tracking permission is restricted");
                    break;
                    
                case ATTrackingManagerAuthorizationStatusNotDetermined:
                    NSLog(@"App tracking permission is not determined");
                    break;
            }
        }];
    } else {
        // Fallback on earlier versions
        NSLog(@"App tracking permission request is not required in iOS 13 and below");
    }
    if (keyArray == nil || autoConnect) {
        [self connectToTapjoy];
    }
}

-(void)connectToTapjoy
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *keyArray = [[defaults arrayForKey: @"arrayOfSdkKeys"] mutableCopy];
    
    
    //First launch with no key set in cache
    if (keyArray == nil && ![Tapjoy isConnected]) {
        // NOTE: This is the only step required if you're an advertiser.
        // NOTE: This must be replaced by your App ID. It is retrieved from the Tapjoy website, in your account.
        [Tapjoy connect:@"E7CuaoUWRAWdz_5OUmSGsgEBXHdOwPa8de7p4aseeYP01mecluf-GfNgtXlF"
                options:@{ TJC_OPTION_ENABLE_LOGGING : @(YES) }
         // If you are not using Tapjoy Managed currency, you would set your own user ID here.
         // TJC_OPTION_USER_ID : @"A_UNIQUE_USER_ID"
         ];
    }
    else if (![Tapjoy isConnected] ) {
        // NOTE: This is the only step required if you're an advertiser.
        // NOTE: This must be replaced by your App ID. It is retrieved from the Tapjoy website, in your account.
        [Tapjoy connect:[defaults objectForKey:@"sdkDefaultKey"]
                options:@{ TJC_OPTION_ENABLE_LOGGING : @(YES) }
         // If you are not using Tapjoy Managed currency, you would set your own user ID here.
         // TJC_OPTION_USER_ID : @"A_UNIQUE_USER_ID"
         ];
    }
}

-(void)tjcConnectSuccess:(NSNotification*)notifyObj
{
	NSLog(@"Tapjoy connect Succeeded");
}


- (void)tjcConnectFail:(NSNotification*)notifyObj
{
    NSError *error = notifyObj.userInfo[TJC_CONNECT_USER_INFO_ERROR];
    NSError *underlyingError = error.userInfo[NSUnderlyingErrorKey];
	NSLog(@"Tapjoy connect failed: %li %@%@",
          error.code,
          error.localizedDescription,
          underlyingError != nil ? [NSString stringWithFormat:@" - %li %@", underlyingError.code, underlyingError.localizedDescription] : @"" );
}

- (void)showEarnedCurrencyAlert:(NSNotification*)notifyObj
{
	NSNumber *currencyEarned = notifyObj.object;
	int earnedNum = [currencyEarned intValue];
	
	NSLog(@"Currency earned: %d", earnedNum);
	
	// Pops up a UIAlert notifying the user that they have successfully earned some currency.
	// This is the default alert, so you may place a custom alert here if you choose to do so.
	[Tapjoy showDefaultEarnedCurrencyAlert];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken: %@", deviceToken);
    // Deprecated since 13.2.0
    [Tapjoy setDeviceToken: deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", error);
}


@end
