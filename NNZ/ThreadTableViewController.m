//
//  ThreadTableViewController.m
//  NNZ
//
//  Created by 林 英市 on 2014/11/19.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "ThreadTableViewController.h"

#import "ThreadTableViewCell.h"

@interface ThreadTableViewController ()

@end

@implementation ThreadTableViewController
{
    NSIndexPath *seletedIndexPath;
    NSMutableArray *indexPathsArray;
}

@synthesize delegate;
@synthesize refreshControl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = 66.0f;
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    indexPathsArray = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
    
    if (seletedIndexPath)
    {
        [self.tableView selectRowAtIndexPath:seletedIndexPath
                                    animated:NO
                              scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)refresh
{
    [delegate downloadCommunications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSString *)tableView: (UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"";
            break;
            
        case 1:
            return @"管理者掲示板";
            break;
            
        case 2:
            return @"方面別掲示板";
            break;
            
        case 3:
            return @"道路・鉄道情報掲示板";
            break;
            
        case 4:
            return @"同便クルー掲示板";
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
            return 2;
            break;
            
        case 3:
            return 2;
            break;
            
        case 4:
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"flight"] isEqualToString:@"未選択"] ||
                [[[NSUserDefaults standardUserDefaults] objectForKey:@"flight"] isEqualToString:@"便名なし"])
            {
                return 0;
            }else
            {
                return 1;
            }
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    ThreadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[ThreadTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    [indexPathsArray addObject:indexPath];
    
    // cellの初期化
    cell.textLabel.text = @"";
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    switch (indexPath.section)
    {
        case 0:
            cell.textLabel.text = @"全員";
            cell.threadID = 0;
            break;
            
        case 1:
            switch (indexPath.row)
            {
                case 0:
                    cell.textLabel.text = @"HND運用";
                    cell.threadID = 1;
                    break;
                
                case 1:
                    cell.textLabel.text = @"HND乗員サポート部";
                    cell.threadID = 2;
                    break;
                
                case 2:
                    cell.textLabel.text = @"NRT乗員サポート部";
                    cell.threadID = 3;
                    break;
                
                default:
                    break;
            }
            break;
            
        case 2:
            switch (indexPath.row)
            {
                case 0:
                    cell.textLabel.text = @"羽田方面";
                    cell.threadID = 4;
                    break;
                
                case 1:
                    cell.textLabel.text = @"成田方面";
                    cell.threadID = 5;
                    break;
                
                default:
                    break;
            }
            break;
            
        case 3:
            switch (indexPath.row)
            {
                case 0:
                    cell.textLabel.text = @"高速道路";
                    cell.threadID = 6;
                    break;
                    
                case 1:
                    cell.textLabel.text = @"鉄道";
                    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yahoo.png"]];
                    cell.threadID = 7;
                    break;
                
                default:
                    break;
            }
            break;
            
        case 4:
            cell.textLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"flight"];
            cell.threadID = 8;
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    seletedIndexPath = indexPath;
    
    ThreadTableViewCell *cell = (ThreadTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [delegate didSelectThreadAtID:cell.threadID];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (void)markThreadAtID:(NSInteger)threadID
{
    if ([seletedIndexPath compare:indexPathsArray[threadID]] != NSOrderedSame)
    {
        ThreadTableViewCell *cell = (ThreadTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPathsArray[threadID]];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

@end
