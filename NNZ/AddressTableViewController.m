//
//  AddressTableViewController.m
//  NNZ
//
//  Created by 林 英市 on 2014/12/31.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "AddressTableViewController.h"

@interface AddressTableViewController ()

@end

@implementation AddressTableViewController
{
    NSArray *mailAddressesList;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"メールアドレスリスト";
    
    self.tableView.rowHeight = 66;
}

- (void)viewWillAppear:(BOOL)animated
{
    mailAddressesList = [[NSUserDefaults standardUserDefaults] objectForKey:@"mailAddressesList"];
    [self.tableView reloadData];
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
    return @"以下に表示されている相手には、iMessageおよびFaceTimeを利用して位置情報から直接コンタクトを取ることができます。";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mailAddressesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = mailAddressesList[indexPath.row][@"employee_number"];
    cell.detailTextLabel.text = mailAddressesList[indexPath.row][@"mail_address"];
    
    return cell;
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
*/

@end
