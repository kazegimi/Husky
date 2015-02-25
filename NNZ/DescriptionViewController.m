//
//  DescriptionViewController.m
//  NNZ
//
//  Created by 林 英市 on 2015/01/13.
//  Copyright (c) 2015年 skyElements. All rights reserved.
//

#import "DescriptionViewController.h"

@interface DescriptionViewController ()

@end

@implementation DescriptionViewController
{
    UITextView *textView;
}

@synthesize version_number;
@synthesize description;

- (void)viewWillAppear:(BOOL)animated
{
    self.title = version_number;
    textView.text = description;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
    textView.backgroundColor = [UIColor whiteColor];
    textView.editable = NO;
    textView.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:textView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
