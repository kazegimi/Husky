//
//  VersionViewController.m
//  NNZ
//
//  Created by 林 英市 on 2014/11/10.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "VersionViewController.h"

@interface VersionViewController ()

@end

@implementation VersionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *versionLabel1 = [[UILabel alloc] init];
    versionLabel1.frame = CGRectMake(10, 0, 355, 75);
    versionLabel1.text = @"位置情報アプリケーション";
    versionLabel1.font = [UIFont boldSystemFontOfSize:18];
    versionLabel1.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:versionLabel1];
    
    UILabel *versionLabel2 = [[UILabel alloc] init];
    versionLabel2.frame = CGRectMake(10, 0, 355, 75);
    NSString *version = [NSString stringWithFormat:@"Version %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"appVersion"]];
    versionLabel2.text = version;
    versionLabel2.font = [UIFont systemFontOfSize:15];
    versionLabel2.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:versionLabel2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

@end
