//
//  ListViewController.m
//  NNZ
//
//  Created by 林 英市 on 2014/12/16.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "ListViewController.h"

#import "ListTableViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController
{
    ListTableViewController *listTableViewController;
    
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
    UIButton *button4;
    UIButton *button5;
    UIButton *button6;
    UIButton *button7;
    
    BOOL ascending;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, self.preferredContentSize.width, self.preferredContentSize.height);
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] init];
    navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    [self.view addSubview:navigationBar];
    
    button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:@"社員番号" forState:UIControlStateNormal];
    button1.frame = CGRectMake(5, 0, 100, 44);
    [button1 addTarget:self action:@selector(button1) forControlEvents:UIControlEventTouchDown];
    [navigationBar addSubview:button1];
    
    button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"ライセンス" forState:UIControlStateNormal];
    button2.frame = CGRectMake(110, 0, 100, 44);
    [button2 addTarget:self action:@selector(button2) forControlEvents:UIControlEventTouchDown];
    [navigationBar addSubview:button2];
    
    button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button3 setTitle:@"Flight" forState:UIControlStateNormal];
    button3.frame = CGRectMake(215, 0, 75, 44);
    [button3 addTarget:self action:@selector(button3) forControlEvents:UIControlEventTouchDown];
    [navigationBar addSubview:button3];
    
    button4 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button4 setTitle:@"現在住所" forState:UIControlStateNormal];
    button4.frame = CGRectMake(295, 0, 105, 44);
    [button4 addTarget:self action:@selector(button4) forControlEvents:UIControlEventTouchDown];
    [navigationBar addSubview:button4];
    
    button5 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button5 setTitle:@"目的地" forState:UIControlStateNormal];
    button5.frame = CGRectMake(405, 0, 75, 44);
    [button5 addTarget:self action:@selector(button5) forControlEvents:UIControlEventTouchDown];
    [navigationBar addSubview:button5];
    
    button6 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button6 setTitle:@"残り距離" forState:UIControlStateNormal];
    button6.frame = CGRectMake(485, 0, 75, 44);
    [button6 addTarget:self action:@selector(button6) forControlEvents:UIControlEventTouchDown];
    [navigationBar addSubview:button6];
    
    button7 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button7 setTitle:@"最終更新" forState:UIControlStateNormal];
    button7.frame = CGRectMake(565, 0, 100, 44);
    [button7 addTarget:self action:@selector(button7) forControlEvents:UIControlEventTouchDown];
    [navigationBar addSubview:button7];
    
    ascending = YES;
    
    listTableViewController = [[ListTableViewController alloc] init];
    listTableViewController.tableView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
    listTableViewController.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:listTableViewController.tableView];
}

- (void)button1
{
    ascending = !ascending;
    
    listTableViewController.markers = [listTableViewController.markers sortedArrayUsingComparator:^(id value1, id value2)
                                       {
                                           NSString *stringValue1 = value1[@"properties"][@"employee_number"];
                                           NSString *stringValue2 = value2[@"properties"][@"employee_number"];

                                           return ascending? [stringValue1 compare:stringValue2] : -[stringValue1 compare:stringValue2];
                                       }];
    [listTableViewController.tableView reloadData];
}

- (void)button2
{
    ascending = !ascending;
    
    listTableViewController.markers = [listTableViewController.markers sortedArrayUsingComparator:^(id value1, id value2)
                                       {
                                           NSString *stringValue1 = value1[@"properties"][@"license"];
                                           NSString *stringValue2 = value2[@"properties"][@"license"];
                                           
                                           return ascending? [stringValue1 compare:stringValue2] : -[stringValue1 compare:stringValue2];
                                       }];
    [listTableViewController.tableView reloadData];
}

- (void)button3
{
    ascending = !ascending;
    
    listTableViewController.markers = [listTableViewController.markers sortedArrayUsingComparator:^(id value1, id value2)
                                       {
                                           NSString *stringValue1 = value1[@"properties"][@"flight"];
                                           NSString *stringValue2 = value2[@"properties"][@"flight"];
                                           
                                           return ascending? [stringValue1 compare:stringValue2] : -[stringValue1 compare:stringValue2];
                                       }];
    [listTableViewController.tableView reloadData];
}

- (void)button4
{
    ascending = !ascending;
    
    listTableViewController.markers = [listTableViewController.markers sortedArrayUsingComparator:^(id value1, id value2)
                                       {
                                           NSString *stringValue1 = value1[@"properties"][@"address"];
                                           NSString *stringValue2 = value2[@"properties"][@"address"];
                                           
                                           return ascending? [stringValue1 compare:stringValue2] : -[stringValue1 compare:stringValue2];
                                       }];
    [listTableViewController.tableView reloadData];
}

- (void)button5
{
    ascending = !ascending;
    
    listTableViewController.markers = [listTableViewController.markers sortedArrayUsingComparator:^(id value1, id value2)
                                       {
                                           NSString *stringValue1 = value1[@"properties"][@"showup_airport"];
                                           NSString *stringValue2 = value2[@"properties"][@"showup_airport"];
                                           
                                           return ascending? [stringValue1 compare:stringValue2] : -[stringValue1 compare:stringValue2];
                                       }];
    [listTableViewController.tableView reloadData];
}

- (void)button6
{
    ascending = !ascending;
    
    listTableViewController.markers = [listTableViewController.markers sortedArrayUsingComparator:^(id value1, id value2)
                                       {
                                           NSString *stringValue1 = value1[@"properties"][@"distance"];
                                           NSString *stringValue2 = value2[@"properties"][@"distance"];
                                           
                                           return ascending? [stringValue1 compare:stringValue2] : -[stringValue1 compare:stringValue2];
                                       }];
    [listTableViewController.tableView reloadData];
}

- (void)button7
{
    ascending = !ascending;
    
    listTableViewController.markers = [listTableViewController.markers sortedArrayUsingComparator:^(id value1, id value2)
                                       {
                                           NSString *stringValue1 = value1[@"properties"][@"timestamp"];
                                           NSString *stringValue2 = value2[@"properties"][@"timestamp"];
                                           
                                           return ascending? [stringValue1 compare:stringValue2] : -[stringValue1 compare:stringValue2];
                                       }];
    [listTableViewController.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
