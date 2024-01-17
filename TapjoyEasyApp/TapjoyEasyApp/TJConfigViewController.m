//
//  TJConfigViewController.m
//  TapjoyEasyApp
//
//  Created by Luke Bowman on 20/12/2022.
//  Copyright © 2022 Tapjoy. All rights reserved.
//
#import "TJConfigViewController.h"
#import <Tapjoy/Tapjoy.h>

@interface TJConfigViewController ()

@property (weak, nonatomic) IBOutlet UITextField *keyTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *dropdownPicker;
@property (weak, nonatomic) IBOutlet UISwitch *autoConnectSwitch;
@property (weak, nonatomic) IBOutlet UILabel *statusMessage;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *dropdownButton;

@end

@implementation TJConfigViewController

NSMutableArray *keyArray;
NSUserDefaults *defaults;
bool autoConnect;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Load stored keys if none set the default key
    defaults = [NSUserDefaults standardUserDefaults];
    keyArray = [[defaults arrayForKey: @"arrayOfSdkKeys"] mutableCopy];
    autoConnect = [defaults boolForKey:@"autoConnectStatus"];
    
    if (keyArray == nil) {
        keyArray = [[NSMutableArray alloc] init];
        
        [keyArray addObject:@"E7CuaoUWRAWdz_5OUmSGsgEBXHdOwPa8de7p4aseeYP01mecluf-GfNgtXlF"];
        [defaults setObject:keyArray forKey:@"arrayOfSdkKeys"];
        [defaults setObject:keyArray[0] forKey:@"sdkDefaultKey"];
        
        self.keyTextField.text = keyArray[0];
        [defaults setBool:YES forKey:@"autoConnectStatus"];
        [defaults synchronize];
    } else {
        self.keyTextField.text = [defaults objectForKey:@"sdkDefaultKey"];
        [self centreSelectPickerWheelOnKey];
        [self.autoConnectSwitch setOn:autoConnect];
    }
    
    UIImage *buttonImage = [UIImage imageNamed:@"Dropdown.png"];
    [self.dropdownButton setImage:buttonImage forState:UIControlStateNormal];
    [self.dropdownButton setTitle:@"" forState:UIControlStateNormal];
    self.dropdownPicker.hidden = true;
    
}

- (IBAction)addKeyToArray:(id)sender {
    if (self.keyTextField.text.length > 49) {
        
        if(![keyArray containsObject:self.keyTextField.text]) {
            [keyArray addObject:self.keyTextField.text];
        }
        [self centreSelectPickerWheelOnKey];
        [defaults setObject:self.keyTextField.text forKey:@"sdkDefaultKey"];
        [defaults setObject:keyArray forKey:@"arrayOfSdkKeys"];
        [defaults synchronize];
    } else {
        self.statusMessage.text = @"Please enter a valid key length";
    }
    [[self view] endEditing:true];
}

- (IBAction)clearTextField:(id)sender {
    self.keyTextField.text = @"";
}

- (IBAction)autoConnectToTapjoy:(id)sender {
    [defaults setBool:_autoConnectSwitch.isOn forKey:@"autoConnectStatus"];
    [defaults synchronize];
    [self autoConnectDisabledMessage];
}

- (IBAction)openPickerView:(id)sender {
    self.dropdownPicker.hidden = !self.dropdownPicker.hidden;
    self.dropdownButton.transform = CGAffineTransformRotate(self.dropdownButton.transform, M_PI);
    if(self.dropdownPicker.hidden){
        [[self view] endEditing:true];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [keyArray count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    [[self view] endEditing:true];
    return keyArray[row];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *strTitle = keyArray[row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:strTitle attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    return attString;
}

- (void)centreSelectPickerWheelOnKey {
    //Reload new array, select row programatically then reload to display
    NSUInteger index = [keyArray indexOfObject:self.keyTextField.text];
    [self.dropdownPicker reloadAllComponents];
    [self.dropdownPicker selectRow:index inComponent:0 animated:NO];
    [self.dropdownPicker reloadAllComponents];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.keyTextField.text = keyArray[row];
    [defaults setObject:keyArray[row] forKey:@"sdkDefaultKey"];
    [defaults synchronize];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self autoConnectDisabledMessage];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)autoConnectDisabledMessage {
    self.statusMessage.text = @"To Connect with new key please restart app.";
}

@end


