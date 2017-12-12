//
//  ViewController.m
//  NNZ
//
//  Created by 林 英市 on 2014/11/05.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "ViewController.h"

#import "SettingTableViewController.h"
#import "CommunicationViewController.h"
#import "ListViewController.h"

#import "EmployeeNumberViewController.h"

#import "CustomAnnotationView.h"

@interface ViewController ()

@end

@implementation ViewController
{
    UIDevice *device;
    NSString *uuid;
    
    MKMapView *mapView;
    //UIWebView *mapWebView;
    
    CLLocationManager *locationManager;
    Downloader *downloader;
    NSArray *datasArray;
    Uploader *uploader;
    Deleter *deleter;
    
    BOOL lefty;
    UIView *functionView;
    
    UIButton *versionButton;
    UIPopoverController *versionPopoverController;
    
    UIButton *filterButton;
    UIViewController *filterViewController;
    UITextField *filterTextField;
    UIPopoverController *filterPopoverController;
    
    UIButton *updateButton;
    UIActivityIndicatorView *activityIndicatorView;
    
    UIButton *settingButton;
    SettingTableViewController *settingTableViewController;
    UIPopoverController *settingPopoverController;
    
    UIButton *communicationButton;
    CommunicationViewController *communicationViewController;
    UIPopoverController *communicationPopoverController;
    
    UIButton *listButton;
    ListViewController *listViewController;
    UIPopoverController *listPopoverController;
    
    EmployeeNumberViewController *employeeNumberViewController;
    
    NSInteger count;
    
    BOOL withUpdate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    device = [UIDevice currentDevice];
    uuid = [[device identifierForVendor] UUIDString];
    [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"uuid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    device.batteryMonitoringEnabled = YES;
    
    mapView = [[MKMapView alloc] init];
    mapView.delegate = self;
    mapView.frame = self.view.frame;
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:mapView];
    
    /*
    mapWebView = [[UIWebView alloc] init];
    mapWebView.delegate = self;
    mapWebView.frame = self.view.frame;
    mapWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapWebView.scalesPageToFit = YES;
    [self.view addSubview:mapWebView];
     */
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = 50.0f;
    locationManager.desiredAccuracy = 50.0f;
    locationManager.delegate = self;
    
    downloader = [[Downloader alloc] init];
    downloader.delegate = self;

    uploader = [[Uploader alloc] init];
    uploader.delegate = self;
    
    deleter = [[Deleter alloc] init];
    deleter.delegate = self;
    
    withUpdate = NO;
    
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
    functionView.backgroundColor = [UIColor clearColor];
    functionView.alpha = 0.5f;
    [self.view addSubview:functionView];
    
    filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [filterButton setImage:[UIImage imageNamed:@"filter.png"] forState:UIControlStateNormal];
    filterButton.frame = CGRectMake(0, 0, 75, 75);
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
    
    settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    settingButton.frame = CGRectMake(0, 75, 75, 75);
    [settingButton addTarget:self action:@selector(openSettingView) forControlEvents:UIControlEventTouchDown];
    [settingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [functionView addSubview:settingButton];
    
    settingTableViewController = [[SettingTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    settingTableViewController.preferredContentSize = CGSizeMake(settingTableViewController.preferredContentSize.width, 1024);
    UINavigationController *settingNavigationController = [[UINavigationController alloc] initWithRootViewController:settingTableViewController];
    settingNavigationController.preferredContentSize = settingTableViewController.preferredContentSize;
    settingPopoverController = [[UIPopoverController alloc] initWithContentViewController:settingNavigationController];
    settingPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(22, 10, 22, 10);
    settingPopoverController.delegate = self;
    
    updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateButton setTitle:@"" forState:UIControlStateNormal];
    updateButton.frame = CGRectMake(0, 150, 75, 75);
    [updateButton addTarget:self action:@selector(uploadWithUpdate) forControlEvents:UIControlEventTouchDown];
    [updateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [functionView addSubview:updateButton];
    
    //ボタンの長押し設定部分
    UILongPressGestureRecognizer *updateButtonLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                             action:@selector(reConnect:)];
    [updateButton addGestureRecognizer:updateButtonLongPress];
    
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        // iOS バージョンが 8 以上で、requestAlwaysAuthorization メソッドが
        // 利用できる場合
        
        // 位置情報測位の許可を求めるメッセージを表示する
        [locationManager requestAlwaysAuthorization];
    }else
    {
        // iOS バージョンが 8 未満で、requestAlwaysAuthorization メソッドが
        // 利用できない場合
    }

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"privacySwitch"])
    {
        [updateButton setBackgroundImage:[UIImage imageNamed:@"update_blue.png"] forState:UIControlStateNormal];
        [locationManager startUpdatingLocation];
    }else
    {
        [updateButton setBackgroundImage:[UIImage imageNamed:@"update.png"] forState:UIControlStateNormal];
        [locationManager stopUpdatingLocation];
    }
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    activityIndicatorView.frame = CGRectMake(0, 0, 75, 75);
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [updateButton addSubview:activityIndicatorView];
    
    communicationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [communicationButton setImage:[UIImage imageNamed:@"com.png"] forState:UIControlStateNormal];
    communicationButton.frame = CGRectMake(0, 225, 75, 75);
    [communicationButton addTarget:self action:@selector(openCommunicationView) forControlEvents:UIControlEventTouchDown];
    [communicationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [functionView addSubview:communicationButton];
    
    //ボタンの長押し設定部分
    UILongPressGestureRecognizer *communicationButtonLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                             action:@selector(communicationsLayer:)];
    [communicationButton addGestureRecognizer:communicationButtonLongPress];
    
    communicationViewController = [[CommunicationViewController alloc] init];
    communicationViewController.preferredContentSize = CGSizeMake(670, 1024);
    communicationPopoverController = [[UIPopoverController alloc] initWithContentViewController:communicationViewController];
    communicationPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(22, 10, 22, 10);
    communicationPopoverController.delegate = self;
    
    listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [listButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
    listButton.frame = CGRectMake(0, 300, 75, 75);
    [listButton addTarget:self action:@selector(openListView) forControlEvents:UIControlEventTouchDown];
    [listButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [functionView addSubview:listButton];
    
    listViewController = [[ListViewController alloc] init];
    listViewController.preferredContentSize = CGSizeMake(670, 1024);
    listPopoverController = [[UIPopoverController alloc] initWithContentViewController:listViewController];
    listPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(22, 10, 22, 10);
    listPopoverController.delegate = self;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(privacySwitch) name:@"privacySwitch" object:nil];
    [notificationCenter addObserver:self selector:@selector(panTo:) name:@"panTo" object:nil];
    
    // 初期値設定
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
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"category"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"G(GOOD)" forKey:@"category"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] integerForKey:@"interval"])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:60 forKey:@"interval"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] floatForKey:@"lat"])
    {
        [[NSUserDefaults standardUserDefaults] setFloat:0 forKey:@"lat"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] floatForKey:@"lon"])
    {
        [[NSUserDefaults standardUserDefaults] setFloat:0 forKey:@"lon"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //[self connect];
    
    [self resetTimer];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways)
    {
        // 位置情報測位の許可状態が「常に許可」または「使用中のみ」の場合、
        // 測位を開始する（iOS バージョンが 8 以上の場合のみ該当する）
        // ※iOS8 以上の場合、位置情報測位が許可されていない状態で
        // startUpdatingLocation メソッドを呼び出しても、何も行われない。
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"privacySwitch"])
        {
            [updateButton setBackgroundImage:[UIImage imageNamed:@"update_blue.png"] forState:UIControlStateNormal];
            [locationManager startUpdatingLocation];
        }else
        {
            [updateButton setBackgroundImage:[UIImage imageNamed:@"update.png"] forState:UIControlStateNormal];
            [locationManager stopUpdatingLocation];
        }
    }
}
/*
- (void)connect
{
    // URL指定
    NSURL *url = [NSURL URLWithString:@"http://location.serverrush.com/husky/husky.php"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    // POST指定
    request.HTTPMethod = @"POST";
    // BODYに登録、設定
    NSString *body = @"password=5852b9c9f7d4d05b7e979b2cb54250eb9cae99d0";
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    // リクエスト送信
    [mapWebView loadRequest:request];
}
 */
/*
- (void)reConnect:(UILongPressGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:// 長押しを検知開始
        {
            [self connect];
            [self resetTimer];
        }
            break;
            
        case UIGestureRecognizerStateEnded:// 長押し終了時
        {
            
        }
            break;
            
        default:
            break;
            
    }
}
 */
- (void)communicationsLayer:(UILongPressGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            //[mapWebView stringByEvaluatingJavaScriptFromString:@"communucationsLayerOn();"];
        }
            break;
            
        case UIGestureRecognizerStateEnded: {
            
        }
            break;
        default:
            break;
        }
}

- (void)privacySwitch {
    [locationManager stopUpdatingLocation];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"privacySwitch"])
    {
        [updateButton setBackgroundImage:[UIImage imageNamed:@"update_blue.png"] forState:UIControlStateNormal];
        withUpdate = YES;
        
        /*
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"distance_filter"])
        {
            locationManager.distanceFilter = [[NSUserDefaults standardUserDefaults] integerForKey:@"distance_filter"];
        }else
        {
            locationManager.distanceFilter = kCLDistanceFilterNone;
            [[NSUserDefaults standardUserDefaults] setInteger:kCLDistanceFilterNone forKey:@"distance_filter"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"accuracy"])
        {
            locationManager.desiredAccuracy = [[NSUserDefaults standardUserDefaults] integerForKey:@"accuracy"];
        }else
        {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            [[NSUserDefaults standardUserDefaults] setInteger:kCLLocationAccuracyBest forKey:@"accuracy"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        */
        
        [locationManager startUpdatingLocation];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"startTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //NSDate *startTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"startTime"];
        //NSLog(@"%@", startTime);
    } else {
        [updateButton setBackgroundImage:[UIImage imageNamed:@"update.png"] forState:UIControlStateNormal];
        withUpdate = YES;
        [deleter deleteMarker];
    }
}

- (void)resetTimer {
    [activityIndicatorView stopAnimating];
    
    if ([self.timer isValid]) [self.timer invalidate];
    count = [[NSUserDefaults standardUserDefaults] integerForKey:@"interval"] + 1;
    if (count > 0) [self countDown];
}

- (void)countDown {
    count--;
    
    if (count == 0) {
        [self update];
        return;
    }
    
    [updateButton setTitle:[NSString stringWithFormat:@"%ld", (long)count] forState:UIControlStateNormal];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(countDown)
                                                userInfo:nil
                                                 repeats:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"employee_number"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"employee_number"] isEqualToString:@""]) {
        employeeNumberViewController = [[EmployeeNumberViewController alloc] init];
        employeeNumberViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        employeeNumberViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        UINavigationController *initializeNavigationController = [[UINavigationController alloc] initWithRootViewController:employeeNumberViewController];
        initializeNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:initializeNavigationController animated:YES completion:nil];
    }
}

- (void)openFilterView
{
    [filterPopoverController presentPopoverFromRect:filterButton.bounds
                                             inView:filterButton
                           permittedArrowDirections:UIPopoverArrowDirectionAny
                                           animated:YES];
}

// filter
- (void)textFieldDidChange
{
    NSString *filter = [NSString stringWithFormat:@"filter('%@');", filterTextField.text];
    //[mapWebView stringByEvaluatingJavaScriptFromString:filter];
    
    if (![filterTextField.text isEqualToString:@""])
    {
        [filterButton setImage:[UIImage imageNamed:@"filter_blue.png"] forState:UIControlStateNormal];
    }else
    {
        [filterButton setImage:[UIImage imageNamed:@"filter.png"] forState:UIControlStateNormal];
    }
}

// pan to marker
- (void)panTo:(NSNotification *)notification
{
    float lat = [notification.userInfo[@"geometry"][@"coordinates"][1] floatValue];
    float lon = [notification.userInfo[@"geometry"][@"coordinates"][0] floatValue];
    NSString *employee_number = notification.userInfo[@"properties"][@"employee_number"];
    
    NSString *panTo = [NSString stringWithFormat:@"panTo(%f, %f, '%@');", lat, lon, employee_number];
    //[mapWebView stringByEvaluatingJavaScriptFromString:panTo];
    
    [listPopoverController dismissPopoverAnimated:YES];
}

- (void)openSettingView
{
    [settingPopoverController presentPopoverFromRect:settingButton.bounds
                                        inView:settingButton
                       permittedArrowDirections:UIPopoverArrowDirectionAny
                                       animated:YES];
}

- (void)uploadWithUpdate
{
    if ([self.timer isValid]) [self.timer invalidate];
    
    [updateButton setTitle:@"" forState:UIControlStateNormal];
    [activityIndicatorView startAnimating];
    
    withUpdate = YES;
    
    [uploader upload];
}

- (void)openCommunicationView
{
    [communicationPopoverController presentPopoverFromRect:communicationButton.bounds
                                                    inView:communicationButton
                                  permittedArrowDirections:UIPopoverArrowDirectionAny
                                                  animated:YES];
}

- (void)openListView
{
    [listPopoverController presentPopoverFromRect:listButton.bounds
                                           inView:listButton
                         permittedArrowDirections:UIPopoverArrowDirectionAny
                                         animated:YES];
}

// 位置情報の取得に失敗した場合の処理
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"位置情報取得エラー"
                                                    message:error.description
                                                   delegate:self cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
    */
    
    withUpdate = NO;
}

// 位置情報の取得に成功した場合の処理
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"startTime"])
    {
        NSDate *startTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"startTime"];
        NSTimeInterval interval = 6 * 60 * 60;
        //NSTimeInterval interval = 10;
        NSDate *startTimePlus12Hours = [NSDate dateWithTimeInterval:interval sinceDate:startTime];
        
        //NSLog(@"%@", startTimePlus12Hours);
        
        NSComparisonResult result = [[NSDate date] compare:startTimePlus12Hours];
        switch(result)
        {
            case NSOrderedSame: // 一致したとき
                break;
                
            case NSOrderedAscending: // [NSDate date]が小さいとき
                break;
                
            case NSOrderedDescending: // [NSDate date]が大きいとき
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"startTime"];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"privacySwitch"];
                
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"commutation"])
                {
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"commutation"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"未選択" forKey:@"flight"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"未選択" forKey:@"showup_airport"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"未選択" forKey:@"showup_time"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"G(GOOD)" forKey:@"category"];
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"showup_airport_lat"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"showup_airport_lon"];
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"distance"];
                }
                
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self privacySwitch];
                return;
                break;
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setFloat:newLocation.coordinate.latitude forKey:@"lat"];
    [[NSUserDefaults standardUserDefaults] setFloat:newLocation.coordinate.longitude forKey:@"lon"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [uploader upload];
}

// Uploader, Deleterからconnection完了のdelegate
- (void)didCompleteConnection
{
    if (withUpdate) [self update];
    
    withUpdate = NO;
}

- (void)update {
    if ([self.timer isValid]) [self.timer invalidate];
    
    [updateButton setTitle:@"" forState:UIControlStateNormal];
    [downloader startDownloading];
    
    [self resetTimer];
}

- (void)didFinishDownloadingWithData:(NSData *)data {
     datasArray = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:nil];
    NSLog(@"%@", datasArray);
    
    NSMutableArray *annotationsArray = [NSMutableArray new];
    for (int i = 0; i < datasArray.count; i++) {
        NSDictionary *markerDictionary = datasArray[i];
        double lat = [markerDictionary[@"geometry"][@"coordinates"][1] doubleValue];
        double lon = [markerDictionary[@"geometry"][@"coordinates"][0] doubleValue];
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
        annotation.title = [NSString stringWithFormat:@"%d", i];// titleをtag代わりに利用
        [annotationsArray addObject:annotation];
    }
    [mapView removeAnnotations: mapView.annotations];
    [mapView addAnnotations:annotationsArray];
}

- (void)didFailDownloading {
    
}

// AppleMaps
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    [self update];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString * const identifier = @"Annotation";
    
    CustomAnnotationView *customAnnotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    customAnnotationView.centerOffset = CGPointMake(-customAnnotationView.annotationView.frame.size.width / 2, -customAnnotationView.annotationView.frame.size.height);
    
    NSDictionary *markerDictionary = datasArray[[annotation.title integerValue]];
    customAnnotationView.annotationView.nameLabel.text = [NSString stringWithFormat:@"%@", markerDictionary[@"properties"][@"employee_number"]];
    customAnnotationView.annotationView.flightLabel.text = [NSString stringWithFormat:@"%@", markerDictionary[@"properties"][@"flight"]];
    customAnnotationView.annotationView.licenseLabel.text = [NSString stringWithFormat:@"%@", markerDictionary[@"properties"][@"license"]];
    customAnnotationView.annotationView.destinationLabel.text = [NSString stringWithFormat:@"%@", markerDictionary[@"properties"][@"showup_airport"]];
    NSString *timeStamp = markerDictionary[@"properties"][@"timestamp"];
    customAnnotationView.annotationView.timeLabel.text = [NSString stringWithFormat:@"%@ JST", [timeStamp substringFromIndex:11]];
    
    return customAnnotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"Annotation!");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // UIWebViewのキャッシュを無効にする
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    // サイト内のMapboxへのリンクを無効にする
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSRange range = [[request.URL absoluteString] rangeOfString:@"www.mapbox.com"];
        if (range.location != NSNotFound)
        {
            return NO;
        }
    }
    
    if ([request.URL.scheme isEqualToString:@"sms"])
    {
        NSString *employee_number = [request.URL.resourceSpecifier stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSArray *mailAddressesList = [[NSUserDefaults standardUserDefaults] objectForKey:@"mailAddressesList"];
        for (NSDictionary *dictionary in mailAddressesList)
        {
            if ([dictionary[@"employee_number"] isEqualToString:employee_number])
            {
                NSString *string = [NSString stringWithFormat:@"sms:%@", dictionary[@"mail_address"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
                
                return NO;
            }
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SMS起動失敗"
                                                        message:[NSString stringWithFormat:@"%@さんのメールアドレスが不明のため、SMSを起動できませんでした。", employee_number]
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    
    if ([request.URL.scheme isEqualToString:@"facetime-audio"])
    {
        NSString *employee_number = [request.URL.resourceSpecifier stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSArray *mailAddressesList = [[NSUserDefaults standardUserDefaults] objectForKey:@"mailAddressesList"];
        for (NSDictionary *dictionary in mailAddressesList)
        {
            if ([dictionary[@"employee_number"] isEqualToString:employee_number])
            {
                NSString *string = [NSString stringWithFormat:@"facetime-audio:%@", dictionary[@"mail_address"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
                
                return NO;
            }
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FaceTime起動失敗"
                                                        message:[NSString stringWithFormat:@"%@さんのメールアドレスが不明のため、FaceTimeを起動できませんでした。", employee_number]
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    
    if ([request.URL.scheme isEqualToString:@"update-request"])
    {
        NSString *dev_token = [request.URL.resourceSpecifier stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if ([dev_token isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update Requestを送信できませんでした"
                                                            message:@"デバイストークンが不明です。"
                                                           delegate:self cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            
            return NO;
        }
        
        NSMutableURLRequest *request;
        NSString *urlString = @"http://location.serverrush.com/husky/update_request_push.php";
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                          cachePolicy:NSURLRequestUseProtocolCachePolicy
                                      timeoutInterval:60.0];
        [request setHTTPMethod:@"POST"];
        
        NSString *parameters = [NSString stringWithFormat:@"dev_token=%@", dev_token];
        [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        
        [NSURLConnection connectionWithRequest:request delegate:nil];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update Requestを送信しました"
                                                        message:@""
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
