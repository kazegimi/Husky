//
//  LicenseTableViewController.m
//  NNZ
//
//  Created by 林 英市 on 2014/11/10.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "LicenseTableViewController.h"

@interface LicenseTableViewController ()

@end

@implementation LicenseTableViewController

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
    
    self.title = @"ライセンス選択";
    
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
    return 13;
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
            cell.textLabel.text = @"787機長";
            break;
        case 1:
            cell.textLabel.text = @"787副操縦士";
            break;
        case 2:
            cell.textLabel.text = @"777機長";
            break;
        case 3:
            cell.textLabel.text = @"777副操縦士";
            break;
        case 4:
            cell.textLabel.text = @"767機長";
            break;
        case 5:
            cell.textLabel.text = @"767副操縦士";
            break;
        case 6:
            cell.textLabel.text = @"737機長";
            break;
        case 7:
            cell.textLabel.text = @"737副操縦士";
            break;
        case 8:
            cell.textLabel.text = @"客室乗務員";
            break;
        case 9:
            cell.textLabel.text = @"整備";
            break;
        case 10:
            cell.textLabel.text = @"航務";
            break;
        case 11:
            cell.textLabel.text = @"KD/KI";
            break;
        case 12:
            cell.textLabel.text = @"その他";
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [[NSUserDefaults standardUserDefaults] setObject:cell.textLabel.text forKey:@"license"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
