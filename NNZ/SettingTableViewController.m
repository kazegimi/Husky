//
//  SettingTableViewController.m
//  NNZ
//
//  Created by 林 英市 on 2014/11/10.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "SettingTableViewController.h"

#import "LicenseTableViewController.h"
#import "FlightTableViewController.h"
#import "IntervalTableViewController.h"
#import "AccuracyTableViewController.h"

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController
{
    UISwitch *privacySwitch;
    
    LicenseTableViewController *licenseTableViewController;
    FlightTableViewController *flightTableViewController;
    IntervalTableViewController *intervalTableViewController;
    AccuracyTableViewController *accuracyTableViewController;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"設定";
    
    self.tableView.rowHeight = 66;
    
    privacySwitch = [[UISwitch alloc] init];
    privacySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"privacySwitch"];
    privacySwitch.frame = CGRectMake(0, 0, 100, 44);
    [privacySwitch addTarget:self action:@selector(privacySwitch) forControlEvents:UIControlEventValueChanged];
    
    licenseTableViewController = [[LicenseTableViewController alloc] init];
    flightTableViewController = [[FlightTableViewController alloc] init];
    intervalTableViewController = [[IntervalTableViewController alloc] init];
    accuracyTableViewController = [[AccuracyTableViewController alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSString *)tableView: (UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"";
            break;
            
        case 1:
            return @"";
            break;
            
        case 2:
            return @"";
            break;
            
        case 3:
            return @"";
            break;
            
        case 4:
            return @"最終更新";
            break;
            
        case 5:
            return @"UUID";
            break;
            
        default:
            return @"";
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"プライバシースイッチをオンにすると、位置情報の送信を開始します。";
            break;
            
        case 1:
            return @"";
            break;
            
        case 2:
            return @"";
            break;
            
        case 3:
            return @"";
            break;
            
        case 4:
            return @"";
            break;
            
        case 5:
            return @"タップすると、クリップポードにコピーします。";
            break;
            
        default:
            return @"";
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
            break;
            
        case 1:
            return 2;
            break;
            
        case 2:
            return 3;
            break;
            
        case 3:
            return 2;
            break;
            
        case 4:
            return 2;
            break;
            
        case 5:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    switch (indexPath.section)
    {
        case 0:
            switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"プライバシースイッチ";
                cell.accessoryView = privacySwitch;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
                
            default:
                break;
        }
            break;
            
        case 1:
            switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"社員番号";
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"employee_number"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
                
            case 1:
                cell.textLabel.text = @"ライセンス";
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"license"];
                break;
                
            default:
                break;
        }
            break;
            
        case 2:
            switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"便名";
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"flight"];
                break;
                
            case 1:
                cell.textLabel.text = @"ショーアップ空港";
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"showup_airport"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
                
            case 2:
                cell.textLabel.text = @"ショーアップ時刻";
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"showup_time"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
                
            default:
                break;
        }
            break;
            
        case 3:
            switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"自動更新間隔";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld分", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"interval"] / 60];
                break;
                
            case 1:
                cell.textLabel.text = @"GPS精度";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] integerForKey:@"accuracy"] == -1 ? @"最高" : [NSString stringWithFormat:@"%ldm", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"accuracy"]]];
                break;
                
            default:
                break;
        }
            break;
            
        case 4:
            switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"位置";
                if ([[NSUserDefaults standardUserDefaults] floatForKey:@"lat"] == 0.0f && [[NSUserDefaults standardUserDefaults] floatForKey:@"lon"] == 0.0f)
                {
                    cell.detailTextLabel.text = @"なし";
                }else
                {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%f, %f", [[NSUserDefaults standardUserDefaults] floatForKey:@"lat"], [[NSUserDefaults standardUserDefaults] floatForKey:@"lon"]];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
                
            case 1:
                cell.textLabel.text = @"時刻";
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"timestamp"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
                
            default:
                break;
        }
            break;
            
        case 5:
            switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
                break;
                
            default:
                break;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            break;
            
        case 1:
            switch (indexPath.row)
        {
            case 0:
                break;
                
            case 1:
                [self.navigationController pushViewController:licenseTableViewController animated:YES];
                break;
                
            default:
                break;
        }
            break;
            
        case 2:
            switch (indexPath.row)
        {
            case 0:
                [self.navigationController pushViewController:flightTableViewController animated:YES];
                break;
                
            case 1:
                break;
                
            case 2:
                break;
                
            default:
                break;
        }
            break;
            
        case 3:
            switch (indexPath.row)
        {
            case 0:
                [self.navigationController pushViewController:intervalTableViewController animated:YES];
                break;
                
            case 1:
                [self.navigationController pushViewController:accuracyTableViewController animated:YES];
                break;
                
            default:
                break;
        }
            break;
            
        case 4:
            switch (indexPath.row)
        {
            case 0:
                break;
                
            case 1:
                break;
                
            default:
                break;
        }
            break;
            
        case 5:
            switch (indexPath.row)
        {
            case 0:
                // ペーストボードへの貼り付け
                [[UIPasteboard generalPasteboard] setValue:[tableView cellForRowAtIndexPath:indexPath].textLabel.text forPasteboardType:@"public.text"];
                
                [self showAlert:@"コピー完了" message:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
                break;
                
            default:
                break;
        }
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:title
                          message:message
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}

- (void)privacySwitch
{
    [[NSUserDefaults standardUserDefaults] setBool:privacySwitch.on forKey:@"privacySwitch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
