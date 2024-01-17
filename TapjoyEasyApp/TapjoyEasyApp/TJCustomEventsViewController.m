// Copyright (C) 2014 - 2018 by Tapjoy Inc.
//
// This file is part of the Tapjoy SDK.
//
// By using the Tapjoy SDK in your software, you agree to the terms of the Tapjoy SDK License Agreement.
//
// The Tapjoy SDK is bound by the Tapjoy SDK License Agreement and can be found here: https://www.tapjoy.com/sdk/license

#import "TJCustomEventsViewController.h"
#import <Tapjoy/Tapjoy.h>

@interface TJCustomEventsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *eventButton;
@property (weak, nonatomic) IBOutlet UIButton *p1EventButton;
@property (weak, nonatomic) IBOutlet UIButton *vEventButton;
@property (weak, nonatomic) IBOutlet UIButton *p1p2EventButton;
@property (weak, nonatomic) IBOutlet UIButton *p1vEventButton;
@property (weak, nonatomic) IBOutlet UIButton *p1p2vEventButton;
@property (weak, nonatomic) IBOutlet UIButton *p1p2v1v2EventButton;
@property (weak, nonatomic) IBOutlet UIButton *allEventButton;

@end

@implementation TJCustomEventsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendEvent:(id)sender
{
	if (sender == _eventButton) {
		[Tapjoy trackEvent:@"SDKTestEvent" category:@"test" parameter1:nil parameter2:nil];
		[_statusLabel setText:@"trackEvent with category: test"];
	} else if (sender == _p1EventButton) {
		[Tapjoy trackEvent:@"SDKTestEvent" category:@"test" parameter1:@"testP1" parameter2:nil];
		[_statusLabel setText:@"trackEvent with category: test, p1:testP1"];
	} else if (sender == _vEventButton) {
		[Tapjoy trackEvent:@"SDKTestEvent" category:@"test" parameter1:nil parameter2:nil value:78];
		[_statusLabel setText:@"trackEvent with category: test, v:78"];
	} else if (sender == _p1p2EventButton) {
		[Tapjoy trackEvent:@"SDKTestEvent" category:@"test" parameter1:@"testP1" parameter2:@"testP2"];
		[_statusLabel setText:@"trackEvent with category: test, p1:testP1, p2:testP2"];
	} else if (sender == _p1vEventButton) {
		[Tapjoy trackEvent:@"SDKTestEvent" category:@"test" parameter1:@"testP1" parameter2:nil value:234];
		[_statusLabel setText:@"trackEvent with category: test, p1:testP1, v:234"];
	} else if (sender == _p1p2vEventButton) {
		[Tapjoy trackEvent:@"SDKTestEvent" category:@"test" parameter1:@"testP1" parameter2:@"testP2" value:56789];
		[_statusLabel setText:@"trackEvent with category: test, p1:testP1, p2:testP2, v:56789"];
	} else if (sender == _p1p2v1v2EventButton) {
		[Tapjoy trackEvent:@"SDKTestEvent" category:@"test" parameter1:@"testP1" parameter2:@"testP2" value1name:@"v1" value1:1 value2name:@"v2" value2:99];
		[_statusLabel setText:@"trackEvent with category: test, p1:testP1, p2:testP2, v1name:v1, v1:1, v2name:v2, v2:99"];
	} else if (sender == _allEventButton) {
		[Tapjoy trackEvent:@"SDKTestEvent" category:@"test" parameter1:@"testP1" parameter2:@"testP2" value1name:@"v1" value1:5 value2name:@"v2" value2:19 value3name:@"v3" value3:985];
		[_statusLabel setText:@"trackEvent with category: test, p1:testP1, p2:testP2, v1name:v1, v1:5, v2name:v2, v2:19, v3name:v3, v3:985"];
	}
}
@end
