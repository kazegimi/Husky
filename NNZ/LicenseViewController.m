//
//  LicenseViewController.m
//  NNZ
//
//  Created by 林 英市 on 2014/11/18.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "LicenseViewController.h"

#import "RegistrationViewController.h"

@interface LicenseViewController ()

@end

@implementation LicenseViewController
{
    UIButton *nextButton;
    
    NSArray *licensesArray;
    NSInteger selectedRow;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"ライセンス選択";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, self.view.frame.size.width, 88);
    label.center = CGPointMake(self.view.center.x, self.view.frame.size.height / 4.0f);
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    label.text = @"ライセンスを選択してください";
    [self.view addSubview:label];
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.center = self.view.center;
    pickerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self.view addSubview:pickerView];
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
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
    
    licensesArray = @[@"787機長", @"787副操縦士", @"777機長", @"777副操縦士", @"767機長", @"767副操縦士", @"737機長", @"737副操縦士", @"客室乗務員", @"整備", @"航務", @"KD/KI", @"管理者", @"その他"];
}

// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// 行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return licensesArray.count + 1;
}

// 表示内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0)
    {
        return @"未選択";
    }else
    {
        return licensesArray[row - 1];
    }
}

// 選択時処理
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == 0)
    {
        nextButton.enabled = NO;
    }else
    {
        nextButton.enabled = YES;
    }
    
    selectedRow = row;
}

- (void)next
{
    [[NSUserDefaults standardUserDefaults] setObject:licensesArray[selectedRow - 1] forKey:@"_license"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    RegistrationViewController *registrationViewController = [[RegistrationViewController alloc] init];
    [self.navigationController pushViewController:registrationViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
