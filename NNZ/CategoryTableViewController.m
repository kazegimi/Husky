//
//  CategoryTableViewController.m
//  NNZ
//
//  Created by 林 英市 on 2014/11/11.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "CategoryTableViewController.h"

@interface CategoryTableViewController ()

@end

@implementation CategoryTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"通勤カテゴリー選択";
    
    self.tableView.rowHeight = 66;
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

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"G(GOOD) : 通勤障害等がまったく発生しておらず、ショーアップ時刻までに到着できると判断する場合。\n\nN(NORMAL) : 通勤障害等は発生しているが、ショーアップ時刻までに到着できると判断する場合。\n\nA(ALERT) : 通勤障害等のため、ショーアップ時刻までに到着できないと判断する場合。";
            break;
            
        default:
            return @"";
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"G(GOOD)";
            break;
        case 1:
            cell.textLabel.text = @"N(NORMAL)";
            break;
        case 2:
            cell.textLabel.text = @"A(ALERT)";
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [[NSUserDefaults standardUserDefaults] setObject:cell.textLabel.text forKey:@"category"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
