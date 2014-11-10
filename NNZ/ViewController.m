//
//  ViewController.m
//  NNZ
//
//  Created by 林 英市 on 2014/11/05.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "ViewController.h"

#import "VersionViewController.h"
#import "SettingTableViewController.h"
#import "CommunicationViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    UIDevice *device;
    NSString *uuid;
    
    UIWebView *mapWebView;
    
    CLLocationManager *locationManager;
    
    BOOL lefty;
    UIView *functionView;
    
    UIButton *versionButton;
    VersionViewController *versionViewController;
    UIPopoverController *versionPopoverController;
    
    UIButton *filterButton;
    UIViewController *filterViewController;
    UITextField *filterTextField;
    UIPopoverController *filterPopoverController;
    
    UIButton *idButton;
    SettingTableViewController *settingTableViewController;
    UIPopoverController *idPopoverController;
    
    UIButton *communicationButton;
    CommunicationViewController *communicationViewController;
    UIPopoverController *communicationPopoverController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    device = [UIDevice currentDevice];
    uuid = [[device identifierForVendor] UUIDString];
    [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"uuid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    device.batteryMonitoringEnabled = YES;
    
    mapWebView = [[UIWebView alloc] init];
    mapWebView.delegate = self;
    mapWebView.frame = self.view.frame;
    mapWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapWebView.scalesPageToFit = YES;
    [self.view addSubview:mapWebView];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    lefty = [[NSUserDefaults standardUserDefaults] boolForKey:@"lefty"];
    
    functionView = [[UIView alloc] init];
    if (lefty)
    {
        functionView.frame = CGRectMake(0, 0, 75, 375);
        functionView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    }else
    {
        functionView.frame = CGRectMake(self.view.bounds.size.width - 75, 0, 75, 375);
        functionView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    }
    functionView.center = CGPointMake(functionView.center.x, self.view.bounds.size.height / 2);
    functionView.backgroundColor = [UIColor whiteColor];
    functionView.alpha = 0.5f;
    [self.view addSubview:functionView];
    
    versionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [versionButton setImage:[UIImage imageNamed:@"jal_logo.png"] forState:UIControlStateNormal];
    versionButton.frame = CGRectMake(0, 0, 75, 75);
    [versionButton addTarget:self action:@selector(openVersionView) forControlEvents:UIControlEventTouchDown];
    [versionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [functionView addSubview:versionButton];
    
    versionViewController = [[VersionViewController alloc] init];
    versionViewController.preferredContentSize = CGSizeMake(375, 75);
    versionPopoverController = [[UIPopoverController alloc] initWithContentViewController:versionViewController];
    versionPopoverController.delegate = self;
    
    filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [filterButton setTitle:@"Filter" forState:UIControlStateNormal];
    filterButton.frame = CGRectMake(0, 75, 75, 75);
    [filterButton addTarget:self action:@selector(openFilterView) forControlEvents:UIControlEventTouchDown];
    [filterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [functionView addSubview:filterButton];
    
    filterViewController = [[UIViewController alloc] init];
    filterViewController.preferredContentSize = CGSizeMake(375, 75);
    filterTextField = [[UITextField alloc] init];
    filterTextField.frame = CGRectMake(10, 0, 355, 75);
    filterTextField.placeholder = @"検索";
    filterTextField.clearButtonMode = UITextFieldViewModeAlways;
    [filterTextField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [filterViewController.view addSubview:filterTextField];
    filterPopoverController = [[UIPopoverController alloc] initWithContentViewController:filterViewController];
    filterPopoverController.delegate = self;
    
    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [updateButton setTitle:@"Update" forState:UIControlStateNormal];
    updateButton.frame = CGRectMake(0, 150, 75, 75);
    [updateButton addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchDown];
    [updateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [functionView addSubview:updateButton];
    
    idButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [idButton setTitle:@"Setting" forState:UIControlStateNormal];
    idButton.frame = CGRectMake(0, 225, 75, 75);
    [idButton addTarget:self action:@selector(openIDView) forControlEvents:UIControlEventTouchDown];
    [idButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [functionView addSubview:idButton];
    
    settingTableViewController = [[SettingTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    settingTableViewController.preferredContentSize = CGSizeMake(settingTableViewController.preferredContentSize.width, self.view.frame.size.height);
    UINavigationController *idNavigationController = [[UINavigationController alloc] initWithRootViewController:settingTableViewController];
    idNavigationController.preferredContentSize = settingTableViewController.preferredContentSize;
    idPopoverController = [[UIPopoverController alloc] initWithContentViewController:idNavigationController];
    idPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(22, 10, 22, 10);
    idPopoverController.delegate = self;
    
    communicationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [communicationButton setTitle:@"COM" forState:UIControlStateNormal];
    communicationButton.frame = CGRectMake(0, 300, 75, 75);
    [communicationButton addTarget:self action:@selector(openCommunicationView) forControlEvents:UIControlEventTouchDown];
    [communicationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [functionView addSubview:communicationButton];
    
    communicationViewController = [[CommunicationViewController alloc] init];
    communicationViewController.preferredContentSize = CGSizeMake(670, self.view.frame.size.height);
    communicationPopoverController = [[UIPopoverController alloc] initWithContentViewController:communicationViewController];
    communicationPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(22, 10, 22, 10);
    communicationPopoverController.delegate = self;
    
    // 初期値設定
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"employee_number"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"employee_number"] isEqualToString:@""])
    {
        [self employee_number];
    }else
    {
        [self connect];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"license"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"未選択" forKey:@"license"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"flight"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"未選択" forKey:@"flight"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"showup_airport"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"未選択" forKey:@"showup_airport"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"showup_time"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"未選択" forKey:@"showup_time"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] integerForKey:@"interval"])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:300 forKey:@"interval"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] integerForKey:@"accuracy"])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:10 forKey:@"accuracy"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] floatForKey:@"lat"])
    {
        [[NSUserDefaults standardUserDefaults] setFloat:0 forKey:@"lat"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] floatForKey:@"lon"])
    {
        [[NSUserDefaults standardUserDefaults] setFloat:0 forKey:@"lon"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"timestamp"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"なし" forKey:@"timestamp"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)connect
{
    // URL指定
    NSURL *url = [NSURL URLWithString:@"http://skyelements.jp/app/iADS/NNZ.php"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    // POST指定
    request.HTTPMethod = @"POST";
    // BODYに登録、設定
    NSString *body = @"password=5852b9c9f7d4d05b7e979b2cb54250eb9cae99d0";
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    // リクエスト送信
    [mapWebView loadRequest:request];
}

- (void)openVersionView
{
    [versionPopoverController presentPopoverFromRect:versionButton.bounds
                                              inView:versionButton
                            permittedArrowDirections:UIPopoverArrowDirectionAny
                                            animated:YES];
}

- (void)openIDView
{
    [idPopoverController presentPopoverFromRect:idButton.bounds
                                        inView:idButton
                       permittedArrowDirections:UIPopoverArrowDirectionAny
                                       animated:YES];
}

- (void)update
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"privacySwitch"])
    {
        // 端末でロケーションサービスが利用できる場合
        if([CLLocationManager locationServicesEnabled])
        {
            // イベントを受け取るインスタンス
            //locationManager.delegate = self;
            // イベントを発生させる最小の距離（デフォルトは距離指定なし）
            //locationManager.distanceFilter = kCLDistanceFilterNone;
            // 精度 (デフォルトはBest)
            if ([[NSUserDefaults standardUserDefaults] integerForKey:@"accuracy"])
            {
                locationManager.desiredAccuracy = [[NSUserDefaults standardUserDefaults] integerForKey:@"accuracy"];
            }else
            {
                locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                [[NSUserDefaults standardUserDefaults] setInteger:kCLLocationAccuracyBest forKey:@"accuracy"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            // 測位開始
            [locationManager startUpdatingLocation];
        }else
        {
            // 端末でロケーションサービスが利用できない場合
        }
    }else
    {
        [mapWebView stringByEvaluatingJavaScriptFromString:@"update();"];
    }
}

- (void)openFilterView
{
    [filterPopoverController presentPopoverFromRect:filterButton.bounds
                                             inView:filterButton
                           permittedArrowDirections:UIPopoverArrowDirectionAny
                                           animated:YES];
}

- (void)textFieldDidChange
{
    NSString *filter = [NSString stringWithFormat:@"filter('%@');", filterTextField.text];
    [mapWebView stringByEvaluatingJavaScriptFromString:filter];
}

- (void)openCommunicationView
{
    [communicationPopoverController presentPopoverFromRect:communicationButton.bounds
                                                    inView:communicationButton
                                  permittedArrowDirections:UIPopoverArrowDirectionAny
                                                  animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation
{
    [locationManager stopUpdatingLocation];
    
    [[NSUserDefaults standardUserDefaults] setFloat:newLocation.coordinate.latitude forKey:@"lat"];
    [[NSUserDefaults standardUserDefaults] setFloat:newLocation.coordinate.longitude forKey:@"lon"];
    
    NSDate *timestamp = locationManager.location.timestamp;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Tokyo"]];
    NSString *string = [formatter stringFromDate:timestamp];
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"timestamp"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableURLRequest *request;
    NSString *urlString = @"http://skyelements.jp/app/iADS/update_markers.php";
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                  timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    
    NSString *employee_number = [[NSUserDefaults standardUserDefaults] objectForKey:@"employee_number"];
    NSString *license = [[NSUserDefaults standardUserDefaults] objectForKey:@"license"];
    NSString *flight = [[NSUserDefaults standardUserDefaults] objectForKey:@"flight"];
    NSString *showup_airport = [[NSUserDefaults standardUserDefaults] objectForKey:@"showup_airport"];
    NSString *showup_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"showup_time"];
    NSInteger accuracy = locationManager.desiredAccuracy;
    double speed = locationManager.location.speed;
    float battery = device.batteryLevel;
    
    NSString *parameters = [NSString stringWithFormat:@"uuid=%@&employee_number=%@&lat=%f&lng=%f&showup_airport=%@&showup_time=%@&flight=%@&license=%@&accuracy=%ld&speed=%f&battery=%f&timestamp=%@", uuid, employee_number, newLocation.coordinate.latitude, newLocation.coordinate.longitude, showup_airport, showup_time, flight, license, (long)accuracy, speed, battery, string];
     
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"privacySwitch"])
    {
        [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // 位置情報の取得に失敗した場合の処理
}

// Errorになると呼び出される
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通信エラー"
                                                    message:nil
                                                   delegate:self cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

// レスポンスを受け取ると呼び出される
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //mutableData = [[NSMutableData alloc] init];
}

// データを受け取る度に呼び出される
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //[mutableData appendData:data];
}

// データを全て受け取ると呼び出される
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [mapWebView stringByEvaluatingJavaScriptFromString:@"update();"];
}

- (void)employee_number
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"社員番号を入力してください\n(半角数字8桁)"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"OK", nil];
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[[alertView textFieldAtIndex:0] text] forKey:@"employee_number"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self connect];
    }else
    {
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
