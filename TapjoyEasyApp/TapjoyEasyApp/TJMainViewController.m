// Copyright (C) 2014 - 2018 by Tapjoy Inc.
//
// This file is part of the Tapjoy SDK.
//
// By using the Tapjoy SDK in your software, you agree to the terms of the Tapjoy SDK License Agreement.
//
// The Tapjoy SDK is bound by the Tapjoy SDK License Agreement and can be found here: https://www.tapjoy.com/sdk/license

#import "TJMainViewController.h"
#import "TJAppDelegate.h"
#import <Tapjoy/Tapjoy.h>

NSString *TJTitleForEntryPoint(TJEntryPoint entryPoint) {
    switch (entryPoint) {
        case TJEntryPointOther:
            return @"Other";
        case TJEntryPointMainMenu:
            return @"Main Menu";
        case TJEntryPointHud:
            return @"Head-up Display";
        case TJEntryPointExit:
            return @"Exit";
        case TJEntryPointFail:
            return @"Level Failed";
        case TJEntryPointComplete:
            return @"Level Complete";
        case TJEntryPointInbox:
            return @"Inbox";
        case TJEntryPointInitialisation:
            return @"Initialisation";
        case TJEntryPointStore:
            return @"Store";
        case TJEntryPointUnknown:
        default:
            return @"Select";
    }
}

@interface TJMainViewController () <TJPlacementDelegate, TJPlacementVideoDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *sdkVersionLabel;

@property (weak, nonatomic) IBOutlet UITextField *placementField;
@property (weak, nonatomic) IBOutlet UISwitch *debugSwitch;

// Button references
@property (weak, nonatomic) IBOutlet UIButton *connectToTapjoyButton;
@property (weak, nonatomic) IBOutlet UIButton *showOfferwallButton;
@property (weak, nonatomic) IBOutlet UIButton *getDirectPlayVideoAdButton;
@property (weak, nonatomic) IBOutlet UIButton *getCurrencyBalanceButton;
@property (weak, nonatomic) IBOutlet UIButton *spendCurrencyButton;
@property (weak, nonatomic) IBOutlet UIButton *awardCurrencyButton;
@property (weak, nonatomic) IBOutlet UIButton *requestContentButton;
@property (weak, nonatomic) IBOutlet UIButton *showContentButton;
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;
@property (weak, nonatomic) IBOutlet UIButton *purchaseWithCampaignButton;
@property (weak, nonatomic) IBOutlet UIButton *buttonEntryPoint;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCurrencyId;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCurrencyBalance;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCurrencyRequiredAmount;


@property (strong, nonatomic) TJPlacement *testPlacement;
@property (strong, nonatomic) TJPlacement *directPlayPlacement;
@property (strong, nonatomic) TJPlacement *offerwallPlacement;
@property (nonatomic, strong) TJDirectPlayPlacementDelegate *dpDelegate;
@property (nonatomic, strong) TJOfferwallPlacementDelegate *offerwallDelegate;
@property (nonatomic, assign) TJEntryPoint selectedEntryPoint;
@end

@implementation TJMainViewController

static NSString * const PlacementNameKey = @"placementName";

- (void)viewDidLoad
{
  [super viewDidLoad];
	
	[_sdkVersionLabel setText:[NSString stringWithFormat:@"SDK version: %@", [Tapjoy getVersion]]];
	[_scrollView setContentSize:CGSizeMake(_scrollView.contentSize.width, _sdkVersionLabel.frame.origin.y + _sdkVersionLabel.frame.size.height)];

    _placementField.text = [[NSUserDefaults standardUserDefaults] stringForKey:PlacementNameKey];

	
    //Observe Tapjoy Connect Success Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tjcConnectSuccess:)
                                                 name:TJC_CONNECT_SUCCESS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tjcConnectFail:)
                                                 name:TJC_CONNECT_FAILED
                                               object:nil];
    
    _offerwallDelegate = [[TJOfferwallPlacementDelegate alloc] init];
    _offerwallDelegate.tjViewController = self;
    self.selectedEntryPoint = TJEntryPointUnknown;
    [self enableButton:_showContentButton enable:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    _directPlayPlacement.delegate = nil;
    _directPlayPlacement.videoDelegate = nil;
}

- (void)enableButton:(UIButton*)button enable:(BOOL)enable
{
	[button setUserInteractionEnabled:enable];
	[button setAlpha:enable ? 1.0 : 0.5];
}

// Callback when TJC_Connect_Success notify
- (void) tjcConnectSuccess: (NSNotification*) notifyObj
{
    NSLog(@"Tapjoy Connect Success @Main ViewControlelr");
    // load Direct play
    _dpDelegate = [[TJDirectPlayPlacementDelegate alloc] init];
    _dpDelegate.tjViewController = self;
    
    _directPlayPlacement = [TJPlacement placementWithName:@"video_unit" delegate:_dpDelegate];
    
    // Set video delegate
    _directPlayPlacement.videoDelegate = self;
    [_directPlayPlacement requestContent];
    
    _connectToTapjoyButton.hidden = YES;
    
    _statusLabel.text = @"Tapjoy Connect succeeded";
    
    // Remove observer after it's notified once
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name: TJC_CONNECT_SUCCESS
                                                  object:nil];
}

- (void) tjcConnectFail: (NSNotification*) notifyObj {
    NSMutableString *errorMessage = @"Tapjoy Connect Failed".mutableCopy;
    NSError *error = notifyObj.userInfo[TJC_CONNECT_USER_INFO_ERROR];
    if (error != nil) {
        [errorMessage appendFormat:@"\nError: %ld - %@", error.code, error.localizedDescription];
        NSError *underlyingError = error.userInfo[NSUnderlyingErrorKey];
        if (underlyingError != nil) {
            [errorMessage appendFormat:@"\nUnderlying Error: %ld - %@", underlyingError.code, underlyingError.localizedDescription];
        }
    }
    NSLog(@"%@", errorMessage);
    _statusLabel.text = errorMessage;
}

#pragma mark - Tapjoy Related Methods

- (IBAction)connectToTapjoyAction:(id)sender {
    [(TJAppDelegate *) UIApplication.sharedApplication.delegate connectToTapjoy];
}

- (IBAction)showOfferwallAction:(id)sender {
	[self enableButton:_showOfferwallButton enable:NO];

    _offerwallPlacement = [TJPlacement placementWithName:@"offerwall_unit" delegate:_offerwallDelegate];
    _offerwallPlacement.entryPoint = self.selectedEntryPoint;
    _offerwallPlacement.presentationViewController = self.tabBarController;
    // Set video delegate
    _offerwallPlacement.videoDelegate = self;

    // Currency
    NSString *currencyId = self.textFieldCurrencyId.text;
    NSInteger currencyBalance = [self.textFieldCurrencyBalance.text integerValue];
    
    if (currencyId.length > 0) {
        // Currency balance
        if (self.textFieldCurrencyBalance.text.length > 0) {
            NSInteger currencyBalance = [self.textFieldCurrencyBalance.text integerValue];
            [self.offerwallPlacement setBalance:currencyBalance forCurrencyId:currencyId withCompletion:^(NSError *error) {
                if (error != nil) {
                    NSLog(@"Failed to set currency balance:\n\t%@\n\t%li\n\t%@", currencyId, currencyBalance, error.localizedDescription);
                }
            }];
        }

        // Currency demand
        if (self.textFieldCurrencyRequiredAmount.text.length > 0) {
            NSInteger requiredAmount = [self.textFieldCurrencyRequiredAmount.text integerValue];
            [self.offerwallPlacement setRequiredAmount:requiredAmount forCurrencyId:currencyId withCompletion:^(NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"Failed to set currency required amount:\n\t%@\n\t%li\n\t%@", currencyId, requiredAmount, error.localizedDescription);
                }
            }];
        }
    }

    [_offerwallPlacement requestContent];
}

- (IBAction)getDirectPlayVideoAdAction:(id)sender
{
	[self enableButton:_getDirectPlayVideoAdButton enable:NO];
	
	// Check if content is available and if it is ready to show
	if(_directPlayPlacement.isContentAvailable)
	{
		if(_directPlayPlacement.isContentReady)
		{
			[_directPlayPlacement showContentWithViewController:self.tabBarController];
		}
		else
		{
			[self enableButton:_getDirectPlayVideoAdButton enable:YES];
			[_statusLabel setText:@"Direct play video not ready to show"];
		}
	}
	else
	{
		[self enableButton:_getDirectPlayVideoAdButton enable:YES];
		[_statusLabel setText:@"No direct play video to show"];
	}
}

- (IBAction)getCurrencyBalanceAction:(id)sender
{
	[self enableButton:_getCurrencyBalanceButton enable:NO];
	[Tapjoy getCurrencyBalanceWithCompletion:^(NSDictionary *parameters, NSError *error) {
		if (error)
            [self.statusLabel setText:[NSString stringWithFormat:@"getCurrencyBalance error: %@", error.localizedDescription]];
		else
		{
            [self.statusLabel setText:[NSString stringWithFormat:@"getCurrencyBalance returned %@: %d", parameters[@"currencyName"], [parameters[@"amount"] intValue]]];
		}
        [self enableButton:self.getCurrencyBalanceButton enable:YES];
	}];
}

- (IBAction)spendCurrencyAction:(id)sender
{
	[self enableButton:_spendCurrencyButton enable:NO];
	[Tapjoy spendCurrency:10 completion:^(NSDictionary *parameters, NSError *error) {
        if (error)
            [self.statusLabel setText:[NSString stringWithFormat:@"spendCurrency error: %@", error.localizedDescription]];
         else
            [self.statusLabel setText:[NSString stringWithFormat:@"spendCurrency returned %@: %d", parameters[@"currencyName"], [parameters[@"amount"] intValue]]];
        [self enableButton:self.spendCurrencyButton enable:YES];
	}];
}

- (IBAction)awardCurrencyAction:(id)sender
{
	[self enableButton:_awardCurrencyButton enable:NO];
	[Tapjoy awardCurrency:10 completion:^(NSDictionary *parameters, NSError *error) {
		if (error)
            [self.statusLabel setText:[NSString stringWithFormat:@"awardCurrency error: %@", error.localizedDescription]];
		else
		{
            [self.statusLabel setText:[NSString stringWithFormat:@"awardCurrency returned %@: %d", parameters[@"currencyName"], [parameters[@"amount"] intValue]]];
		}

        [self enableButton:self.awardCurrencyButton enable:YES];
	}];	
}
	
- (IBAction)placementNameDidChange:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:_placementField.text forKey:PlacementNameKey];
}

- (IBAction)requestContentAction:(id)sender
{
	NSString *placementName = _placementField.text;
	
	if(placementName != nil && placementName.length > 0) {
		[self enableButton:_requestContentButton enable:NO];
        
		_testPlacement = [TJPlacement placementWithName:placementName delegate:self];
        _testPlacement.entryPoint = self.selectedEntryPoint;
        // Set video delegate
        _testPlacement.videoDelegate = self;

        // Currency
        NSString *currencyId = self.textFieldCurrencyId.text;
        if (currencyId.length > 0) {
            // Currency balance
            if (self.textFieldCurrencyBalance.text.length > 0) {
                NSInteger currencyBalance = [self.textFieldCurrencyBalance.text integerValue];
                [self.testPlacement setBalance:[self.textFieldCurrencyBalance.text integerValue] forCurrencyId:currencyId withCompletion:^(NSError *error) {
                    if (error != nil) {
                        NSLog(@"Failed to set currency balance:\n\t%@\n\t%li\n\t%@", currencyId, currencyBalance, error.localizedDescription);
                    }
                }];
            }
            
            // Currency demand
            if (self.textFieldCurrencyRequiredAmount.text.length > 0) {
                NSInteger requiredAmount = [self.textFieldCurrencyRequiredAmount.text integerValue];
                [self.testPlacement setRequiredAmount:requiredAmount forCurrencyId:currencyId withCompletion:^(NSError * _Nullable error) {
                    if (error != nil) {
                        NSLog(@"Failed to set currency required amount:\n\t%@\n\t%li\n\t%@", currencyId, requiredAmount, error.localizedDescription);
                    }
                }];
            }
        }
		
		[_testPlacement requestContent];
		[_placementField resignFirstResponder];
		[_statusLabel setText:[NSString stringWithFormat:@"Requesting content for placement %@...", placementName]];
	}
	else {
		[_statusLabel setText:@"Invalid placement!"];
		NSLog(@"Invalid Placement!");
	}

}

- (IBAction)showContentAction:(id)sender
{
	if(_testPlacement.isContentAvailable) {
		[_testPlacement showContentWithViewController:self.tabBarController];
		[self enableButton:_showContentButton enable:NO];
	}
}

- (IBAction)dismissContentAction:(id)sender
{
    [TJPlacement dismissContent];
}
- (IBAction)sendPurchaseEventAction:(id)sender
{
	if (sender == _purchaseButton) {
		[Tapjoy trackPurchase:@"product1" currencyCode:@"USD" price:0.99 campaignId:nil transactionId:nil];
	} else if (sender == _purchaseWithCampaignButton) {
		[Tapjoy trackPurchase:@"product2" currencyCode:@"USD" price:1.99 campaignId:@"TestCampaignID" transactionId:nil];
	}
}

- (IBAction)toggleDebugEnabled:(id)sender
{
	[Tapjoy setDebugEnabled:_debugSwitch.isOn];
}

- (IBAction)launchSupportWebPage:(id)sender
{
    NSString *supportURLString = [Tapjoy getSupportURL];
    NSURL *supportURL = [NSURL URLWithString:supportURLString];
    if (supportURL) {
        [self openURL:supportURL];
    } else {
        NSLog(@"Tapjoy must connect before support page will load");
    }
}

- (void)openURL:(NSURL *)url
{
    UIApplication *application = [UIApplication sharedApplication];
    // iOS10+ uses new method to openURL
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:url options:@{} completionHandler:nil];
    }
}

- (IBAction)entryPointSelectTapped:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Entry Point" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    for (TJEntryPoint i = TJEntryPointUnknown; i <= TJEntryPointStore; i ++) {
        [alert addAction:[UIAlertAction actionWithTitle:i == TJEntryPointUnknown ? @"None" : TJTitleForEntryPoint(i) style:i == TJEntryPointUnknown ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.selectedEntryPoint = i;
        }]];
    }

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    alert.popoverPresentationController.sourceView = self.buttonEntryPoint;
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setSelectedEntryPoint:(TJEntryPoint)selectedEntryPoint {
    _selectedEntryPoint = selectedEntryPoint;
    [self.buttonEntryPoint setTitle:TJTitleForEntryPoint(selectedEntryPoint) forState:UIControlStateNormal];
}

#pragma mark Tapjoy Video

- (void)videoDidStart:(TJPlacement *)placement {
    NSLog(@"Video did start for: %@", placement.placementName);
}

- (void)videoDidComplete:(TJPlacement*)placement {
    NSLog(@"Video has completed for: %@", placement.placementName);
}

- (void)videoDidFail:(TJPlacement*)placement error:(NSString*)errorMsg {
    NSLog(@"Video did fail for: %@ with error: %@", placement.placementName, errorMsg);
}

#pragma mark TJPlacementDelegate methods

- (void)requestDidSucceed:(TJPlacement*)placement
{
	[_statusLabel setText:[NSString stringWithFormat:@"Tapjoy request content complete, isContentAvailable:%d", placement.isContentAvailable]];
	
	// Make sure we received content from the event call
	if(placement.isContentAvailable) {
		[self enableButton:_showContentButton enable:YES];
	}
	
	[self enableButton:_getDirectPlayVideoAdButton enable:YES];
	[self enableButton:_requestContentButton enable:YES];
}

- (void)contentIsReady:(TJPlacement*)placement
{
	[_statusLabel setText:[NSString stringWithFormat:@"Tapjoy placement content is ready to display"]];
    [self enableButton:_showContentButton enable:YES];
}

- (void)requestDidFail:(TJPlacement*)placement error:(NSError *)error
{
	[_statusLabel setText:[NSString stringWithFormat:@"Tapjoy request content failed with error: %@", [error localizedDescription]]];
	[self enableButton:_getDirectPlayVideoAdButton enable:YES];
	[self enableButton:_requestContentButton enable:YES];
}

- (void)contentDidAppear:(TJPlacement*)placement
{
	NSLog(@"Content did appear for %@ placement", [placement placementName]);
}

- (void)contentDidDisappear:(TJPlacement*)placement
{
	NSLog(@"Content did disappear for %@ placement", [placement placementName]);
}

- (void)didClick:(TJPlacement*)placement
{
    NSLog(@"didClick for %@ placement", [placement placementName]);
}

- (void)placement:(TJPlacement*)placement didRequestPurchase:(TJActionRequest*)request productId:(NSString*)productId
{
	NSString *message = [NSString stringWithFormat: @"didRequestPurchase -- productId: %@, token: %@, requestId: %@", productId, request.token, request.requestId];

    UIAlertController *alertview = [UIAlertController alertControllerWithTitle:@"Got Action Callback" message: message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *okAlert) {}];
    [alertview addAction:okButton];
    [self presentViewController:alertview animated:YES completion:nil];
    
	// Your app must call either completed or cancelled to complete the lifecycle of the request
	[request completed];
}


- (void)placement:(TJPlacement*)placement didRequestReward:(TJActionRequest*)request itemId:(NSString*)itemId quantity:(int)quantity
{
	NSString *message = [NSString stringWithFormat: @"didRequestReward -- itemId: %@, quantity: %d, token: %@, requestId: %@", itemId, quantity, request.token, request.requestId];
    UIAlertController *alertview = [UIAlertController alertControllerWithTitle:@"Got Action Callback" message: message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *okAlert) {}];
    [alertview addAction:okButton];
    [self presentViewController:alertview animated:YES completion:nil];
	
	// Your app must call either completed or cancelled to complete the lifecycle of the request
	[request completed];
}


- (void)placement:(TJPlacement*)placement didRequestCurrency:(TJActionRequest*)request currency:(NSString*)currency amount:(int)amount
{
	NSString *message = [NSString stringWithFormat: @"didRequestCurrency -- currency: %@, amount: %d, token: %@, requestId: %@", currency, amount, request.token, request.requestId];
    UIAlertController *alertview = [UIAlertController alertControllerWithTitle:@"Got Action Callback" message: message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *okAlert) {}];
    [alertview addAction:okButton];
    [self presentViewController:alertview animated:YES completion:nil];
	
	// Your app must call either completed or cancelled to complete the lifecycle of the request
	[request completed];
}


- (void)placement:(TJPlacement*)placement didRequestNavigation:(TJActionRequest*)request location:(NSString *)location
{
	NSString *message = [NSString stringWithFormat: @"didRequestNavigation -- location: %@, token: %@, requestId: %@", location, request.token, request.requestId];
    UIAlertController *alertview = [UIAlertController alertControllerWithTitle:@"Got Action Callback" message: message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *okAlert) {}];
    [alertview addAction:okButton];
    [self presentViewController:alertview animated:YES completion:nil];
    
	// Your app must call either completed or cancelled to complete the lifecycle of the request
	[request completed];
}

#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end


@interface TJDirectPlayPlacementDelegate ()

@end

@implementation TJDirectPlayPlacementDelegate
-(id)init
{
	self = [super init];
    
    if (self)
	{}
	
	return self;
}

- (void)requestDidSucceed:(TJPlacement*)placement
{
	NSLog(@"Tapjoy request did succeed, contentIsAvailable:%d", placement.isContentAvailable);
}

- (void)contentIsReady:(TJPlacement*)placement
{
	NSLog(@"Tapjoy placement content is ready to display");
}

- (void)requestDidFail:(TJPlacement*)placement error:(NSError *)error
{
	NSLog(@"Tapjoy request failed with error: %@", [error localizedDescription]);
}

- (void)contentDidAppear:(TJPlacement*)placement
{
	NSLog(@"Content did appear for %@ placement", [placement placementName]);
}

- (void)contentDidDisappear:(TJPlacement*)placement
{
	[_tjViewController enableButton:_tjViewController.getDirectPlayVideoAdButton enable:YES];
	
	// Request next placement after the previous one is dismissed
	_tjViewController.directPlayPlacement = [TJPlacement placementWithName:@"video_unit" delegate:self];
	[_tjViewController.directPlayPlacement requestContent];
	
	// Best Practice: We recommend calling getCurrencyBalance as often as possible so the user’s balance is always up-to-date.
	[Tapjoy getCurrencyBalance];

	NSLog(@"Content did disappear for %@ placement.", [placement placementName]);
}

- (void)didClick:(TJPlacement*)placement
{
    NSLog(@"didClick for %@ placement", [placement placementName]);
}
@end

@interface TJOfferwallPlacementDelegate ()

@end

@implementation TJOfferwallPlacementDelegate
-(id)init
{
  self = [super init];
  
  if (self)
  {}
  
  return self;
}

- (void)requestDidSucceed:(TJPlacement*)placement
{
  [_tjViewController enableButton:_tjViewController.showOfferwallButton enable:YES];
  NSLog(@"Tapjoy request did succeed, contentIsAvailable:%d", placement.isContentAvailable);
  
  if (!placement.isContentAvailable) {
    [_tjViewController.statusLabel setText:@"No Offerwall content available"];
  }
}

- (void)contentIsReady:(TJPlacement*)placement
{
  NSLog(@"Tapjoy placement content is ready to display");
  [_tjViewController.statusLabel setText:@"Offerwall request success"];
  [placement showContentWithViewController:placement.presentationViewController];
}

- (void)requestDidFail:(TJPlacement*)placement error:(NSError *)error
{
  NSLog(@"Tapjoy request failed with error: %@", [error localizedDescription]);
  
  [_tjViewController enableButton:_tjViewController.showOfferwallButton enable:YES];
  [_tjViewController.statusLabel setText:@"Offerwall failure"];
  UIAlertController *alertview = [UIAlertController alertControllerWithTitle:@"Error" message: @"An error occured while loading the Offerwall" preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *okAlert) {}];
  [alertview addAction:okButton];
  [_tjViewController presentViewController:alertview animated:YES completion:nil];
}

- (void)contentDidAppear:(TJPlacement*)placement
{
  NSLog(@"Content did appear for %@ placement", [placement placementName]);
}

- (void)contentDidDisappear:(TJPlacement*)placement
{
  NSLog(@"Content did disappear for %@ placement", [placement placementName]);
}

- (void)didClick:(TJPlacement*)placement
{
    NSLog(@"didClick for %@ placement", [placement placementName]);
}
@end
