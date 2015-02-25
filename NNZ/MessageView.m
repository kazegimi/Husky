//
//  MessageView.m
//  NNZ
//
//  Created by 林 英市 on 2014/11/19.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "MessageView.h"

@implementation MessageView
{
    UITextField *messageTextField;
    UIButton *sendButton;
}

@synthesize threadID;
@synthesize messageTableViewController;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        messageTableViewController = [[MessageTableViewController alloc] init];
        messageTableViewController.tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 44);
        messageTableViewController.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self addSubview:messageTableViewController.tableView];
        
        messageTextField = [[UITextField alloc] init];
        messageTextField.backgroundColor = [UIColor clearColor];
        messageTextField.frame = CGRectMake(15, self.frame.size.height - 44, self.frame.size.width - 74, 44);
        messageTextField.borderStyle = UITextBorderStyleNone;
        messageTextField.placeholder = @"メッセージを送信";
        messageTextField.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        messageTextField.delegate = self;
        [messageTextField addTarget:self
                             action:@selector(textFieldDidChange:)
                   forControlEvents:UIControlEventEditingChanged];
        [self addSubview:messageTextField];
        
        sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
        sendButton.frame = CGRectMake(self.frame.size.width - 59, self.frame.size.height - 44, 44, 44);
        [sendButton setTitle:@"送信" forState:UIControlStateNormal];
        sendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [sendButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchDown];
        sendButton.enabled = NO;
        
        [self addSubview:sendButton];
    }
    
    return self;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""])
    {
        sendButton.enabled = NO;
    }else
    {
        sendButton.enabled = YES;
    }
}

- (void)send
{
    sendButton.enabled = NO;
    
    NSMutableURLRequest *request;
    NSString *urlString = @"http://location.serverrush.com/husky/upload_communications.php";
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                  timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    
    NSString *sender = [[NSUserDefaults standardUserDefaults] objectForKey:@"employee_number"];
    NSString *receiver = @"";
    if (threadID == 8) receiver = [[NSUserDefaults standardUserDefaults] objectForKey:@"flight"];
    NSString *message = messageTextField.text;
    float lat = [[NSUserDefaults standardUserDefaults] floatForKey:@"lat"];
    float lon = [[NSUserDefaults standardUserDefaults] floatForKey:@"lon"];
    
    NSString *parameters = [NSString stringWithFormat:@"thread_id=%ld&sender=%@&receiver=%@&message=%@&lat=%f&lon=%f", (long)threadID, sender, receiver, message, lat, lon];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    NSDictionary *communication = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInteger:0], @"id",
                                   [NSNumber numberWithInteger:threadID], @"thread_id",
                                   sender, @"sender",
                                   receiver, @"receiver",
                                   message, @"message",
                                   [NSNumber numberWithFloat:lat], @"lat",
                                   [NSNumber numberWithFloat:lon], @"lon",
                                   [NSNumber numberWithInteger:0], @"acknowledgment",
                                   @"", @"timestamp", nil];
    [messageTableViewController addMessage:communication];
    
     messageTextField.text = @"";
}

// Errorになると呼び出される
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"メッセージ送信エラー"
                                                    message:error.description
                                                   delegate:self cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
    
    sendButton.enabled = YES;
}

// レスポンスを受け取ると呼び出される
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

// データを受け取る度に呼び出される
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
}

// データを全て受け取ると呼び出される
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSNotification *notification = [NSNotification notificationWithName:@"pushNotification" object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    // Push Notification
    NSMutableURLRequest *request;
    NSString *urlString = @"http://location.serverrush.com/husky/communications_push.php";
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                  timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    
    NSString *receiver = @"";
    if (threadID == 8) receiver = [[NSUserDefaults standardUserDefaults] objectForKey:@"flight"];
    NSString *dev_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"dev_token"];
    
    NSString *parameters = [NSString stringWithFormat:@"receiver=%@&dev_token=%@", receiver, dev_token];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection connectionWithRequest:request delegate:nil];
}

@end
