//
//  VersionTableViewController.m
//  NNZ
//
//  Created by 林 英市 on 2015/01/13.
//  Copyright (c) 2015年 skyElements. All rights reserved.
//

#import "VersionTableViewController.h"
#import "DescriptionViewController.h"

#import "XMLParser.h"

@interface VersionTableViewController ()

@end

@implementation VersionTableViewController
{
    NSArray *versionsArray;
    NSMutableData *mutableData;
    
    DescriptionViewController *descriptionViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Husky更新履歴";
    self.tableView.rowHeight = 66;
    
    descriptionViewController = [[DescriptionViewController alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    versionsArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"versionsArray"];
    [self.tableView reloadData];
    
    NSURL *url = [NSURL URLWithString:@"http://location.serverrush.com/husky/versions.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    [NSURLConnection connectionWithRequest:request delegate:self];
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
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return versionsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Version %@", versionsArray[indexPath.row][@"version_number"]];
    cell.detailTextLabel.text = versionsArray[indexPath.row][@"date"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    descriptionViewController.version_number = [NSString stringWithFormat:@"Version %@", versionsArray[indexPath.row][@"version_number"]];
    
    NSString *description = versionsArray[indexPath.row][@"description"];
    
    descriptionViewController.description = description;
    [self.navigationController pushViewController:descriptionViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
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
    
    if ([dictionary[@"versions"][@"version"] isKindOfClass:[NSDictionary class]])
    {
        versionsArray = [NSArray arrayWithObjects:dictionary[@"versions"][@"version"], nil];
    }else
    {
        versionsArray = dictionary[@"versions"][@"version"];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:versionsArray forKey:@"versionsArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView reloadData];
}

/*
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
 [self.navigationController popViewControllerAnimated:YES];
 }
 */

@end
