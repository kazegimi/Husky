//
//  MessageTableViewController.m
//  NNZ
//
//  Created by 林 英市 on 2014/11/15.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "MessageTableViewController.h"

#import "MessageTableViewCell.h"

#import "XMLParser.h"

@interface MessageTableViewController ()

@end

@implementation MessageTableViewController
{
    float goldenRatio;
    
    UILabel *emptyLabel;
    
    NSMutableData *mutableData;
}

@synthesize messagesArray;

- (void)viewWillAppear:(BOOL)animated
{
    if (messagesArray.count)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messagesArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    goldenRatio = 1.618;
    
    emptyLabel = [[UILabel alloc] init];
    emptyLabel.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height);
    emptyLabel.center = self.tableView.center;
    emptyLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    emptyLabel.backgroundColor = [UIColor clearColor];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.textColor = [UIColor lightGrayColor];
    emptyLabel.text = @"";
    [self.tableView addSubview:emptyLabel];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    messagesArray = [[NSMutableArray alloc] init];
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
    if (messagesArray.count == 0)
    {
        emptyLabel.text = @"午前3時以降に投稿がありません";
    }else
    {
        emptyLabel.text = @"";
    }
    
    return messagesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *message = messagesArray[indexPath.row][@"message"];
    CGSize maxSize = CGSizeMake(self.tableView.frame.size.width / (1 + goldenRatio) * goldenRatio - 15 - 10, CGFLOAT_MAX);
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20]};
    
    CGSize size = [message boundingRectWithSize:maxSize
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attributes
                                        context:nil].size;
    
    return size.height + 22 + 10 + 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.width = self.tableView.frame.size.width;
    cell.employee_number = [[NSUserDefaults standardUserDefaults] objectForKey:@"employee_number"];
    [cell setMessage:messagesArray[indexPath.row]];
    
    return cell;
}

- (void)addMessage:(NSDictionary *)message
{
    [messagesArray addObject:message];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:messagesArray.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
