//
//  WelcomeViewController.m
//  NNZ
//
//  Created by 林 英市 on 2014/11/20.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController
{
    NSTimer *timer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"登録完了";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, self.view.frame.size.width, 88);
    label.center = self.view.center;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    //label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    label.text = @"Huskyへようこそ";
    [self.view addSubview:label];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0f
                                             target:self
                                           selector:@selector(welcome)
                                           userInfo:nil
                                            repeats:NO];
}

- (void)welcome
{
    if ([timer isValid]) [timer invalidate];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
