//
//  CommunicationViewController.m
//  NNZ
//
//  Created by 林 英市 on 2014/11/10.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "CommunicationViewController.h"

#import "MessageView.h"

#import "XMLParser.h"

@interface CommunicationViewController ()

@end

@implementation CommunicationViewController
{
    ThreadTableViewController *threadTableViewController;
    
    UIViewController *messageViewController;
    NSMutableArray *messageViewsArray;
    
    UITextField *messageTextField;
    UIButton *sendButton;
    
    NSMutableData *mutableData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float goldenRatio = 1.618f;
    float denominator = 1.0f + goldenRatio;
    
    self.view.frame = CGRectMake(0, 0, self.preferredContentSize.width, self.preferredContentSize.height);
    
    threadTableViewController = [[ThreadTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    threadTableViewController.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width / denominator, self.view.frame.size.height);
    threadTableViewController.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    threadTableViewController.delegate = self;
    [self.view addSubview:threadTableViewController.tableView];
    
    messageViewController = [[UIViewController alloc] init];
    messageViewController.view.frame = CGRectMake(self.view.frame.size.width / denominator, 0, self.view.frame.size.width / denominator * goldenRatio, self.view.frame.size.height);
    messageViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:messageViewController.view];
    
    messageViewsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 9; i++)
    {
        MessageView *messageView = [[MessageView alloc] initWithFrame:CGRectMake(0, 0, messageViewController.view.frame.size.width, messageViewController.view.frame.size.height)];
        messageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        messageView.threadID = i;
        
        [messageViewsArray addObject:messageView];
    }
    
    [self addMessages:[[NSUserDefaults standardUserDefaults] objectForKey:@"communications"] withMarking:NO];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(downloadCommunications) name:@"pushNotification" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [self downloadCommunications];
}

- (void)downloadCommunications
{
    NSMutableURLRequest *request;
    NSString *urlString = @"http://location.serverrush.com/husky/download_communications.php";
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                  timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
    NSString *flight = [[NSUserDefaults standardUserDefaults] objectForKey:@"flight"];
    
    NSString *parameters = [NSString stringWithFormat:@"uuid=%@&flight=%@", uuid, flight];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

// Errorになると呼び出される
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通信エラー"
                                                    message:error.description
                                                   delegate:self cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
    
    if (threadTableViewController.refreshControl.isRefreshing) [threadTableViewController.refreshControl endRefreshing];
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
    if (threadTableViewController.refreshControl.isRefreshing) [threadTableViewController.refreshControl endRefreshing];
    
    NSDictionary *dictionary = [XMLParser dictionaryForXMLData:mutableData error:nil];
    
    NSArray *communications;
    if ([dictionary[@"communications"][@"communication"] isKindOfClass:[NSDictionary class]])
    {
        communications = [NSArray arrayWithObjects:dictionary[@"communications"][@"communication"], nil];
    }else
    {
        communications = dictionary[@"communications"][@"communication"];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:communications forKey:@"communications"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self addMessages:communications withMarking:NO];
    
    /*
    NSMutableArray *addedCommunications = [[NSMutableArray alloc] init];
    for (NSDictionary *newCommunication in newCommunications)
    {
        [addedCommunications addObject:newCommunication];
        for (NSDictionary *oldCommunication in oldCommunications)
        {
            if ([newCommunication[@"id"] isEqualToString:oldCommunication[@"id"]])
            {
                [addedCommunications removeLastObject];
                break;
            }
        }
    }
    
    [self addMessages:communications withMarking:YES];
    */
}

- (void)addMessages:(NSArray *)communications withMarking:(BOOL)marking
{
    /*
    for (NSDictionary *communication in communications)
    {
        NSInteger threadID = [communication[@"thread_id"] integerValue];
        
        MessageView *messageView = messageViewsArray[threadID];
        [messageView.messageTableViewController addMessage:communication];
        
        if (marking) [threadTableViewController markThreadAtID:threadID];
    }
    */
    
    for (MessageView *messageView in messageViewsArray)
    {
        [messageView.messageTableViewController.messagesArray removeAllObjects];
    }
    
    for (NSDictionary *communication in communications)
    {
        NSInteger threadID = [communication[@"thread_id"] integerValue];
        MessageView *messageView = messageViewsArray[threadID];
        
        if (threadID == 8)
        {
            if ([communication[@"receiver"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"flight"]])
            {
                [messageView.messageTableViewController.messagesArray addObject:communication];
            }
        }else
        {
            [messageView.messageTableViewController.messagesArray addObject:communication];
        }
    }
    
    for (MessageView *messageView in messageViewsArray)
    {
        [messageView.messageTableViewController.tableView reloadData];
        if (messageView.messageTableViewController.messagesArray.count)
        {
            [messageView.messageTableViewController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageView.messageTableViewController.messagesArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
}

- (void)didSelectThreadAtID:(NSInteger)threadID
{
    MessageView *messageView = messageViewsArray[threadID];
    messageViewController.view = messageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
