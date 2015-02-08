//
//  ListTableViewController.m
//  NNZ
//
//  Created by 林 英市 on 2014/12/05.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "ListTableViewController.h"

#import "ListTableViewCell.h"

#import "DateStringGenerator.h"

@interface ListTableViewController ()

@end

@implementation ListTableViewController
{
    UIRefreshControl *refreshControl;
    
    NSMutableData *mutableData;
}

@synthesize markers;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = 66;
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    markers = [[NSUserDefaults standardUserDefaults] objectForKey:@"markers"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refresh];
}

- (void)refresh
{
    NSURL *url = [NSURL URLWithString:@"http://location.serverrush.com/husky/markers.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return markers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[ListTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.label1.text = markers[indexPath.row][@"properties"][@"employee_number"];
    cell.label2.text = markers[indexPath.row][@"properties"][@"license"];
    cell.label3.text = markers[indexPath.row][@"properties"][@"flight"];
    cell.label4.text = markers[indexPath.row][@"properties"][@"address"];
    cell.label5.text = markers[indexPath.row][@"properties"][@"showup_airport"];
    cell.label6.text = markers[indexPath.row][@"properties"][@"distance"];
    cell.label7.attributedText = [DateStringGenerator generateDateStringFromDateString:markers[indexPath.row][@"properties"][@"timestamp"]];
    
    return cell;
}

// Errorになると呼び出される
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通信エラー"
                                                    message:error.description
                                                   delegate:self cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
    
    if (refreshControl.isRefreshing) [refreshControl endRefreshing];
}

// レスポンスを受け取ると呼び出される
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    mutableData = [[NSMutableData alloc] init];
}

// データを受け取る度に呼び出される
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mutableData appendData:data];
}

// データを全て受け取ると呼び出される
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (refreshControl.isRefreshing) [refreshControl endRefreshing];
    
    markers = [NSJSONSerialization JSONObjectWithData:mutableData options:NSJSONReadingAllowFragments error:nil];
    markers = [markers sortedArrayUsingComparator:^(id value1, id value2)
               {
                   NSString *stringValue1 = value1[@"properties"][@"employee_number"];
                   NSString *stringValue2 = value2[@"properties"][@"employee_number"];
                                           
                   return [stringValue1 compare:stringValue2];
               }];
    
    [[NSUserDefaults standardUserDefaults] setObject:markers forKey:@"markers"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *marker = markers[indexPath.row];
    
    NSNotification *notification = [NSNotification notificationWithName:@"panTo" object:self userInfo:marker];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
