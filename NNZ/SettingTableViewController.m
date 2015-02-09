//
//  SettingTableViewController.m
//  NNZ
//
//  Created by 林 英市 on 2014/11/10.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "SettingTableViewController.h"
#import "SettingTableViewCell.h"

#import "FlightTableViewController.h"
#import "CategoryTableViewController.h"
#import "IntervalTableViewController.h"
#import "DistanceFilterTableViewController.h"
#import "AccuracyTableViewController.h"
#import "AddressTableViewController.h"
#import "VersionTableViewController.h"

#import "XMLParser.h"

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController
{
    UISwitch *privacySwitch;
    
    FlightTableViewController *flightTableViewController;
    CategoryTableViewController *categoryTableViewController;
    IntervalTableViewController *intervalTableViewController;
    DistanceFilterTableViewController *distanceFilterTableViewController;
    AccuracyTableViewController *accuracyTableViewController;
    AddressTableViewController *addressTableViewController;
    VersionTableViewController *versionTableViewController;
    
    NSMutableData *mutableData;
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
    privacySwitch.frame = CGRectMake(0, 0, 100, 44);
    [privacySwitch addTarget:self action:@selector(privacySwitch) forControlEvents:UIControlEventValueChanged];
    
    flightTableViewController = [[FlightTableViewController alloc] init];
    categoryTableViewController = [[CategoryTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    intervalTableViewController = [[IntervalTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    distanceFilterTableViewController = [[DistanceFilterTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    accuracyTableViewController = [[AccuracyTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    addressTableViewController = [[AddressTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    versionTableViewController = [[VersionTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(startCommutation) name:@"startCommutation" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

- (NSString *)tableView: (UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"";
            break;
            
        case 1:
            return @"通勤設定";
            break;
            
        case 2:
            return @"現在の通勤状況";
            break;
        /*
        case 3:
            return @"バッテリー消費に関わる項目";
            break;
        */
            
        case 3:
            return @"Husky Updater用URL";
            break;
            
        case 4:
            return @"メールアドレスリスト";
            break;
            
        case 5:
            return @"ID";
            break;
            
        case 6:
            return @"バージョン";
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
            return @"プライバシースイッチをオンにすると、位置情報の送信ならびにプッシュ通知の受信を開始します。";
            break;
            
        case 1:
            return @"";
            break;
            
        case 2:
            return @"";
            break;
        /*
        case 3:
            return @"";
            break;
        */
            
        case 3:
            return @"";
            break;
            
        case 4:
            return @"メールアドレスリストをダウンロードするには、VPN接続が必要です。";
            break;
            
        case 5:
            return @"IDを変更するには、アプリケーションを一度削除し、改めてPallet Controlからダウンロード&インストールし直してください。";
            break;
            
        case 6:
            return @"";
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
            return 3;
            break;
            
        case 2:
            return 1;
            break;
        /*
        case 3:
            return 3;
            break;
        */
            
        case 3:
            return 1;
            break;
            
        case 4:
            return 2;
            break;
            
        case 5:
            return 2;
            break;
            
        case 6:
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
    
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    // cellの初期化
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.centerLabel.text = @"";
    cell.centerLabel.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.rowHeight);
    cell.imageView.image = nil;
    
    switch (indexPath.section)
    {
        case 0:
            switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"プライバシースイッチ";
                cell.accessoryView = privacySwitch;
                privacySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"privacySwitch"];
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
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"commutation"])
                {
                    cell.centerLabel.text = @"通勤を完了する";
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }else
                {
                    cell.centerLabel.text = @"通勤を開始する";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                break;
            
            case 1:
                cell.textLabel.text = @"便名";
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"flight"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
                
            case 2:
                cell.textLabel.text = @"ショーアップ空港";
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"showup_airport"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            /*
            case 3:
                cell.textLabel.text = @"ショーアップ時刻";
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"showup_time"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            */
            default:
                break;
        }
            break;
            
        case 2:
            switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"通勤カテゴリー";
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"category"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            /*
            case 1:
                cell.textLabel.text = @"予想到着時刻";
                break;
            */
                
            default:
                break;
        }
            break;
        /*
        case 3:
            switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"自動更新間隔";
                if ([[NSUserDefaults standardUserDefaults] integerForKey:@"interval"] == -1)
                {
                    cell.detailTextLabel.text = @"自動更新なし";
                }else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"interval"] / 60 == 0)
                {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld秒", (long)([[NSUserDefaults standardUserDefaults] integerForKey:@"interval"] % 60)];
                }else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"interval"] / 60 != 0)
                {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld分", (long)([[NSUserDefaults standardUserDefaults] integerForKey:@"interval"] / 60)];
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
                
            case 1:
                cell.textLabel.text = @"位置情報送信間隔";
                if ([[NSUserDefaults standardUserDefaults] integerForKey:@"distance_filter"] == -1)
                {
                    cell.detailTextLabel.text = @"指定なし";
                }else
                {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ldm", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"distance_filter"]];
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
                
            case 2:
                cell.textLabel.text = @"GPS精度";
                if ([[NSUserDefaults standardUserDefaults] integerForKey:@"accuracy"] == -1)
                {
                    cell.detailTextLabel.text = @"最高";
                }else
                {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ldm", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"accuracy"]];
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
                
            default:
                break;
        }
            break;
        */
        case 3:
            switch (indexPath.row)
        {
            case 0:
                cell.textLabel.textColor = [UIColor blueColor];
                cell.textLabel.text = [NSString stringWithFormat:@"http://location.serverrush.com/husky/updater.php?uuid=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]];
                break;
                
            default:
                break;
        }
            break;
            
        case 4:
            switch (indexPath.row)
        {
            case 0:
                cell.centerLabel.text = @"ダウンロード";
                break;
                
            case 1:
                cell.textLabel.text = @"保存されているアドレス";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld件", (long)[NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"mailAddressesList"]].count];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
                
            default:
                break;
        }
            break;
            
        case 5:
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
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
                
            default:
                break;
        }
            break;
            
        case 6:
            switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"Husky";
                cell.detailTextLabel.text = @"Version 1.0.1";
                cell.imageView.image = [UIImage imageNamed:@"husky.png"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                //cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"commutation"])
                {
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"commutation"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"未選択" forKey:@"flight"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"未選択" forKey:@"showup_airport"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"未選択" forKey:@"showup_time"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"G(GOOD)" forKey:@"category"];
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"showup_airport_lat"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"showup_airport_lon"];
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"distance"];
                    
                    [[NSUserDefaults standardUserDefaults] synchronize];
                     
                    [self.tableView reloadData];
                    
                    if (privacySwitch.on)
                    {
                        privacySwitch.on = NO;
                        
                        [self privacySwitch];
                    }
                }else
                {
                    [self.navigationController pushViewController:flightTableViewController animated:YES];
                }
                break;
                
            case 1:
                break;
                
            case 2:
                break;
                
            default:
                break;
        }
            break;
            
        case 2:
            switch (indexPath.row)
        {
            case 0:
                [self.navigationController pushViewController:categoryTableViewController animated:YES];
                break;
                
            default:
                break;
        }
            break;
        /*
        case 3:
            switch (indexPath.row)
        {
            case 0:
                [self.navigationController pushViewController:intervalTableViewController animated:YES];
                break;
                
            case 1:
                [self.navigationController pushViewController:distanceFilterTableViewController animated:YES];
                break;
                
            case 2:
                [self.navigationController pushViewController:accuracyTableViewController animated:YES];
                break;
                
            default:
                break;
        }
            break;
        */
        case 3:
            switch (indexPath.row)
        {
            case 0:
                [self mail:[NSString stringWithFormat:@"http://location.serverrush.com/husky/updater_index.php?employee_number=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"employee_number"]]];
                break;
                
            default:
                break;
        }
            break;
            
        case 4:
            switch (indexPath.row)
        {
            case 0:
                [self downloadMailAddressesList];
                break;
                
            case 1:
                [self.navigationController pushViewController:addressTableViewController animated:YES];
                break;
                
            default:
                break;
        }
            break;
            
        case 5:
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
            
        case 6:
            switch (indexPath.row)
        {
            case 0:
                [self.navigationController pushViewController:versionTableViewController animated:YES];
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

- (void)startCommutation
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"commutation"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    privacySwitch.on = YES;
    
    [self privacySwitch];
}

- (void)privacySwitch
{
    [[NSUserDefaults standardUserDefaults] setBool:privacySwitch.on forKey:@"privacySwitch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSNotification *notification = [NSNotification notificationWithName:@"privacySwitch" object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)downloadMailAddressesList
{
    NSURL *url = [NSURL URLWithString:@"http://www.eflight.jalnet:8090/Husky/mail_addresses_list.xml"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:60.0];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

// Errorになると呼び出される
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通信エラー"
                                                    message:@"VPN接続をご確認ください。"
                                                   delegate:self cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
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
    NSDictionary *dictionary = [XMLParser dictionaryForXMLData:mutableData error:nil];
    
    if (dictionary)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ダウンロード完了"
                                                        message:@"メールアドレスリストのダウンロードが完了しました。"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        
        NSArray *mailAddressesList = dictionary[@"datas"][@"data"];
        
        [[NSUserDefaults standardUserDefaults] setObject:mailAddressesList forKey:@"mailAddressesList"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.tableView reloadData];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ダウンロード失敗"
                                                        message:@"メールアドレスリストのダウンロードに失敗しました。VPN接続をご確認ください。"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

- (void)mail:(NSString *)url
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
        mailPicker.mailComposeDelegate = self;
        [mailPicker setSubject:NSLocalizedString(@"Husky Updater URL", @"")];
        
        NSString *messageBody = [NSString stringWithFormat:@"本メールを、Husky Updaterを利用したいデバイスに送信し、そのデバイスから以下のURLにアクセスしてください。\n\n%@", url];
        
        [mailPicker setMessageBody:messageBody isHTML:NO];
        
        if ([mailClass canSendMail])
        {
            [self presentViewController:mailPicker animated:TRUE completion:nil];
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
            // キャンセル
        case MFMailComposeResultCancelled:
            break;
            // 保存
        case MFMailComposeResultSaved:
            break;
            // 送信
        case MFMailComposeResultSent:
        {
            /*
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"メール送信完了"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            */
            break;
        }
            // 送信失敗
        case MFMailComposeResultFailed:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"メール送信失敗"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            break;
        }
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
