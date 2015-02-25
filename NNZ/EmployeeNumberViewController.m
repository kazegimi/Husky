//
//  EmployeeNumberViewController.m
//  NNZ
//
//  Created by 林 英市 on 2014/11/17.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "EmployeeNumberViewController.h"

#import "LicenseViewController.h"

@interface EmployeeNumberViewController ()

@end

@implementation EmployeeNumberViewController
{
    UIView *textFieldView;
    UIButton *nextButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"社員番号入力";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, self.view.frame.size.width, 88);
    label.center = CGPointMake(self.view.center.x, self.view.frame.size.height / 4.0f);
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    //label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    label.text = @"社員番号を8桁で入力してください";
    [self.view addSubview:label];
    
    textFieldView = [[UIView alloc] init];
    textFieldView.frame = CGRectMake(0, 0, 470, 50);
    textFieldView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    textFieldView.center = CGPointMake(self.view.center.x, self.view.frame.size.height / 2.0f);
    textFieldView.tag = 8; // textFieldで設定しているtag = 0と競合してしまうため
    [self.view addSubview:textFieldView];
    
    for (int i = 0; i < 8; i++)
    {
        UITextField *textField = [[UITextField alloc] init];
        textField.frame = CGRectMake(60 * i, 0, 50, 50);
        //textField.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:25];
        textField.font = [UIFont systemFontOfSize:25];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = @"−";
        textField.tag = i;
        textField.delegate = self;
        [textField addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
        [textFieldView addSubview:textField];
        
        if (i == 0) [textField becomeFirstResponder];
    }
    
    nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [nextButton setTitle:@"次へ" forState:UIControlStateNormal];
    nextButton.frame = CGRectMake(0, 0, self.view.frame.size.width, 88);
    nextButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height / 4.0f * 3.0f);
    nextButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    //nextButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchDown];
    [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:nextButton];
    
    nextButton.enabled = NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"";
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
    
    if ([string rangeOfCharacterFromSet:set].location != NSNotFound)
    {
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length == 1)
    {
        if (textField.tag == 7)
        {
            NSMutableString *mutableString = [[NSMutableString alloc] init];
            for (int i = 0; i < 8; i++)
            {
                UITextField *t = (UITextField *)[textFieldView viewWithTag:i];
                [mutableString appendString:t.text];
            }
            
            if ([mutableString isEqualToString:@"99900000"] ||
                [mutableString isEqualToString:@"99900001"] ||
                [mutableString isEqualToString:@"99900002"] ||
                [mutableString isEqualToString:@"99900003"] ||
                [mutableString isEqualToString:@"99900004"] ||
                [mutableString isEqualToString:@"99900005"] ||
                [mutableString isEqualToString:@"99900006"] ||
                [mutableString isEqualToString:@"99900007"] ||
                [mutableString isEqualToString:@"99900008"] ||
                [mutableString isEqualToString:@"99900009"])
            {
                NSString *string = [NSString stringWithFormat:@"HND運用%@", [mutableString substringWithRange:NSMakeRange(7, 1)]];
                mutableString = [NSMutableString stringWithString:string];
            }else if ([mutableString isEqualToString:@"99900010"] ||
                      [mutableString isEqualToString:@"99900011"] ||
                      [mutableString isEqualToString:@"99900012"] ||
                      [mutableString isEqualToString:@"99900013"] ||
                      [mutableString isEqualToString:@"99900014"] ||
                      [mutableString isEqualToString:@"99900015"] ||
                      [mutableString isEqualToString:@"99900016"] ||
                      [mutableString isEqualToString:@"99900017"] ||
                      [mutableString isEqualToString:@"99900018"] ||
                      [mutableString isEqualToString:@"99900019"])
            {
                NSString *string = [NSString stringWithFormat:@"HND乗員サポート部%@", [mutableString substringWithRange:NSMakeRange(7, 1)]];
                mutableString = [NSMutableString stringWithString:string];
            }else if ([mutableString isEqualToString:@"99900020"] ||
                      [mutableString isEqualToString:@"99900021"] ||
                      [mutableString isEqualToString:@"99900022"] ||
                      [mutableString isEqualToString:@"99900023"] ||
                      [mutableString isEqualToString:@"99900024"] ||
                      [mutableString isEqualToString:@"99900025"] ||
                      [mutableString isEqualToString:@"99900026"] ||
                      [mutableString isEqualToString:@"99900027"] ||
                      [mutableString isEqualToString:@"99900028"] ||
                      [mutableString isEqualToString:@"99900029"])
            {
                NSString *string = [NSString stringWithFormat:@"NRT乗員サポート部%@", [mutableString substringWithRange:NSMakeRange(7, 1)]];
                mutableString = [NSMutableString stringWithString:string];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:mutableString forKey:@"_employee_number"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [textField resignFirstResponder];
        }else
        {
            [(UITextField *)[textFieldView viewWithTag:textField.tag + 1] becomeFirstResponder];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    nextButton.enabled = YES;
    
    for (int i = 0; i < 8; i++)
    {
        UITextField *t = (UITextField *)[textFieldView viewWithTag:i];
        if ([t.text isEqualToString:@""]) nextButton.enabled = NO;
    }
}

- (void)next
{
    LicenseViewController *licenseViewController = [[LicenseViewController alloc] init];
    [self.navigationController pushViewController:licenseViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
