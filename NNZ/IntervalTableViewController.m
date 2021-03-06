//
//  IntervalTableViewController.m
//  NNZ
//
//  Created by 林 英市 on 2014/11/10.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "IntervalTableViewController.h"

@interface IntervalTableViewController ()

@end

@implementation IntervalTableViewController
{
    NSArray *intervalsArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"自動更新間隔選択";
    
    self.tableView.rowHeight = 66;
    
    intervalsArray = [NSArray arrayWithObjects:@"-1", @"10", @"15", @"30", @"60", @"300", @"600", @"900", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"マップ上の位置情報を最新の状態に自動更新する時間間隔を設定します。時間が短ければ短いほど、より多くのバッテリーを消費します。";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return intervalsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    NSString *intervalString;
    if ([intervalsArray[indexPath.row] integerValue] == -1)
    {
        intervalString = @"自動更新なし";
    }else if ([intervalsArray[indexPath.row] integerValue] / 60 == 0)
    {
        intervalString = [NSString stringWithFormat:@"%ld秒", (long)([intervalsArray[indexPath.row] integerValue] % 60)];
    }else if ([intervalsArray[indexPath.row] integerValue] / 60 != 0)
    {
        intervalString = [NSString stringWithFormat:@"%ld分", (long)([intervalsArray[indexPath.row] integerValue] / 60)];
    }
    
    cell.textLabel.text = intervalString;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] setInteger:[intervalsArray[indexPath.row] integerValue] forKey:@"interval"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
