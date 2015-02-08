//
//  Deleter.m
//  NNZ
//
//  Created by 林 英市 on 2014/12/15.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "Deleter.h"

@implementation Deleter

@synthesize delegate;

- (void)deleteMarker
{
    NSMutableURLRequest *request;
    NSString *urlString = @"http://location.serverrush.com/husky/delete_marker.php";
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                  timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    
    NSString *parameters = [NSString stringWithFormat:@"employee_number=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"employee_number"]];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

// Errorになると呼び出される
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"削除エラー"
                                                    message:error.description
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"削除完了"
                                                    message:@"データベース上に保存されていたあなたの位置情報を削除しました。"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
    
    [delegate didCompleteConnection];
}

@end

