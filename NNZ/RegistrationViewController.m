//
//  RegistrationViewController.m
//  NNZ
//
//  Created by 林 英市 on 2014/11/18.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "RegistrationViewController.h"

#import "WelcomeViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController
{
    NSString *employee_number;
    NSString *license;
    
    UIButton *registerButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"確認";
    self.view.backgroundColor = [UIColor whiteColor];
    
    employee_number = [[NSUserDefaults standardUserDefaults] objectForKey:@"_employee_number"];
    license = [[NSUserDefaults standardUserDefaults] objectForKey:@"_license"];;
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, self.view.frame.size.width, 88);
    label.center = CGPointMake(self.view.center.x, self.view.frame.size.height / 4.0f);
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    //label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    label.text = @"以下の内容で登録します";
    [self.view addSubview:label];
    
    UILabel *idLabel = [[UILabel alloc] init];
    idLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 176);
    idLabel.center = self.view.center;
    idLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    //idLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
    idLabel.font = [UIFont systemFontOfSize:20];
    idLabel.textAlignment = NSTextAlignmentCenter;
    idLabel.numberOfLines = 0;
    idLabel.textColor = [UIColor blackColor];
    idLabel.text = [NSString stringWithFormat:@"社員番号 : %@\nライセンス : %@\nUUID : %@\nDevice Token : %@", employee_number, license, [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"], [[NSUserDefaults standardUserDefaults] objectForKey:@"dev_token"]];
    [self.view addSubview:idLabel];
    
    registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitle:@"登録" forState:UIControlStateNormal];
    registerButton.frame = CGRectMake(0, 0, self.view.frame.size.width, 88);
    registerButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height / 4.0f * 3.0f);
    registerButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    //registerButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [registerButton addTarget:self action:@selector(registerID) forControlEvents:UIControlEventTouchDown];
    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:registerButton];
}

- (void)registerID
{
    NSMutableURLRequest *request;
    NSString *urlString = @"http://location.serverrush.com/husky/registration.php";
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                  timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    
    NSString *parameters = [NSString stringWithFormat:@"employee_number=%@&license=%@&uuid=%@&dev_token=%@", employee_number, license, [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"], [[NSUserDefaults standardUserDefaults] objectForKey:@"dev_token"]];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

// Errorになると呼び出される
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通信エラー"
                                                    message:error.description
                                                   delegate:self cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

// レスポンスを受け取ると呼び出される
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

// データを受け取る度に呼び出される
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
}

// データを全て受け取ると呼び出される
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[NSUserDefaults standardUserDefaults] setObject:employee_number forKey:@"employee_number"];
    [[NSUserDefaults standardUserDefaults] setObject:license forKey:@"license"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    WelcomeViewController *welcomeViewController = [[WelcomeViewController alloc] init];
    [self.navigationController pushViewController:welcomeViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
