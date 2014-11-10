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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"自動更新間隔選択";
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
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
            cell.textLabel.text = @"1分";
            break;
        case 1:
            cell.textLabel.text = @"5分";
            break;
        case 2:
            cell.textLabel.text = @"10分";
            break;
        case 3:
            cell.textLabel.text = @"15分";
            break;
        case 4:
            cell.textLabel.text = @"20分";
            break;
        case 5:
            cell.textLabel.text = @"30分";
            break;
        case 6:
            cell.textLabel.text = @"60分";
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger interval;
    
    switch (indexPath.row)
    {
        case 0:
            interval = 60 * 1;
            break;
        case 1:
            interval = 60 * 5;
            break;
        case 2:
            interval = 60 * 10;
            break;
        case 3:
            interval = 60 * 15;
            break;
        case 4:
            interval = 60 * 20;
            break;
        case 5:
            interval = 60 * 30;
            break;
        case 6:
            interval = 60 * 60;
            break;
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:interval forKey:@"interval"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
