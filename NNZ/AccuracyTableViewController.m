//
//  AccuracyTableViewController.m
//  NNZ
//
//  Created by 林 英市 on 2014/11/10.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "AccuracyTableViewController.h"

@interface AccuracyTableViewController ()

@end

@implementation AccuracyTableViewController
{
    NSArray *accuraciesArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"GPS精度選択";
    
    self.tableView.rowHeight = 66;
    
    accuraciesArray = [NSArray arrayWithObjects:@"-1", @"10", @"100", @"1000", @"3000", nil];
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
    return @"使用するGPSの精度を設定します。精度が高ければ高いほど、より多くのバッテリーを消費します。";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return accuraciesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    NSString *accuracyString;
    if ([accuraciesArray[indexPath.row] integerValue] == -1)
    {
        accuracyString = @"最高";
    }else
    {
        accuracyString = [NSString stringWithFormat:@"%@m", accuraciesArray[indexPath.row]];
    }
    
    cell.textLabel.text = accuracyString;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] setInteger:[accuraciesArray[indexPath.row] integerValue] forKey:@"accuracy"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
