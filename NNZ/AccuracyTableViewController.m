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
    
    self.title = @"GPS精度選択";
    
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
    return 5;
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
            cell.textLabel.text = @"最高";
            break;
        case 1:
            cell.textLabel.text = @"10m";
            break;
        case 2:
            cell.textLabel.text = @"100m";
            break;
        case 3:
            cell.textLabel.text = @"1000m";
            break;
        case 4:
            cell.textLabel.text = @"3000m";
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger accuracy;
    
    switch (indexPath.row)
    {
        case 0:
            accuracy = -1;
            break;
        case 1:
            accuracy = 10;
            break;
        case 2:
            accuracy = 100;
            break;
        case 3:
            accuracy = 1000;
            break;
        case 4:
            accuracy = 3000;
            break;
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:accuracy forKey:@"accuracy"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
