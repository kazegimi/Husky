//
//  FlightTableViewController.m
//  NNZ
//
//  Created by 林 英市 on 2014/11/10.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "FlightTableViewController.h"

#import "XMLParser.h"
#import "DateStringGenerator.h"

@interface FlightTableViewController ()

@end

@implementation FlightTableViewController
{
    NSArray *flights;
    NSMutableData *mutableData;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSURL *url = [NSURL URLWithString:@"http://location.serverrush.com/husky/flights.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"便名選択";
    
    self.tableView.rowHeight = 66;
    
    flights = [[NSUserDefaults standardUserDefaults] objectForKey:@"flights"];
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
    return flights.count + 2;
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
    cell.detailTextLabel.attributedText = nil;
    
    switch (indexPath.row)
    {
        case 0:
            
            cell.textLabel.text = @"便名なし(HND)";
            cell.detailTextLabel.text = @"";
            
            break;
            
        case 1:
            
            cell.textLabel.text = @"便名なし(NRT)";
            cell.detailTextLabel.text = @"";
            
            break;
            
        default:
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)", flights[indexPath.row - 2][@"flight_number"], flights[indexPath.row - 2][@"departure_airport"]];
            cell.detailTextLabel.text = @"";
            cell.detailTextLabel.attributedText = [DateStringGenerator generateDateStringFromDateString:flights[indexPath.row - 2][@"departure_time"]];
            
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"commutation"];
    
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    switch (indexPath.row)
    {
        case 0:
            
            [[NSUserDefaults standardUserDefaults] setObject:@"便名なし" forKey:@"flight"];
            [[NSUserDefaults standardUserDefaults] setObject:@"HND" forKey:@"showup_airport"];
            
            break;
            
        case 1:
            
            [[NSUserDefaults standardUserDefaults] setObject:@"便名なし" forKey:@"flight"];
            [[NSUserDefaults standardUserDefaults] setObject:@"NRT" forKey:@"showup_airport"];
            
            break;
            
        default:
            
            [[NSUserDefaults standardUserDefaults] setObject:flights[indexPath.row - 2][@"flight_number"] forKey:@"flight"];
            [[NSUserDefaults standardUserDefaults] setObject:flights[indexPath.row - 2][@"departure_airport"] forKey:@"showup_airport"];
            [[NSUserDefaults standardUserDefaults] setObject:flights[indexPath.row - 2][@"showup_time"] forKey:@"showup_time"];
            
            break;
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"showup_airport"] isEqualToString:@"HND"])
    {
        [[NSUserDefaults standardUserDefaults] setFloat:35.54705 forKey:@"showup_airport_lat"];
        [[NSUserDefaults standardUserDefaults] setFloat:139.78535 forKey:@"showup_airport_lon"];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"showup_airport"] isEqualToString:@"NRT"])
    {
        [[NSUserDefaults standardUserDefaults] setFloat:35.770432 forKey:@"showup_airport_lat"];
        [[NSUserDefaults standardUserDefaults] setFloat:140.390295 forKey:@"showup_airport_lon"];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"distance"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通勤を開始します"
                                                    message:@"ライセンス・パスポート・社員証は\nお持ちですか？\n気をつけて出社してください。"
                                                   delegate:self cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    
    NSNotification *notification = [NSNotification notificationWithName:@"startCommutation" object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [alert show];
}

// Errorになると呼び出される
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通信エラー"
                                                    message:error.description
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
    
    if ([dictionary[@"flights"][@"flight"] isKindOfClass:[NSDictionary class]])
    {
        flights = [NSArray arrayWithObjects:dictionary[@"flights"][@"flight"], nil];
    }else
    {
        flights = dictionary[@"flights"][@"flight"];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:flights forKey:@"flights"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView reloadData];
}

@end
