//
//  DistanceFilterTableViewController.m
//  NNZ
//
//  Created by 林 英市 on 2014/12/16.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "DistanceFilterTableViewController.h"

@interface DistanceFilterTableViewController ()

@end

@implementation DistanceFilterTableViewController
{
    NSArray *distancesArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"位置情報送信間隔選択";
    
    self.tableView.rowHeight = 66;
    
    distancesArray = [NSArray arrayWithObjects:@"-1", @"10", @"50", @"100", @"500", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"位置情報を自動的に送信する距離間隔を設定します。設定した距離を移動するごとに、新しい位置情報を送信します。距離が短ければ短いほど、より多くのバッテリーを消費します。";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return distancesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    NSString *distanceString;
    if ([distancesArray[indexPath.row] integerValue] == -1)
    {
        distanceString = @"指定なし";
    }else
    {
        distanceString = [NSString stringWithFormat:@"%@m", distancesArray[indexPath.row]];
    }
    
    cell.textLabel.text = distanceString;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] setInteger:[distancesArray[indexPath.row] integerValue] forKey:@"distance_filter"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end