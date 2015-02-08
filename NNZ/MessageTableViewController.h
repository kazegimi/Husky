//
//  MessageTableViewController.h
//  NNZ
//
//  Created by 林 英市 on 2014/11/15.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewController : UITableViewController

@property (nonatomic) NSMutableArray *messagesArray;

- (void)addMessage:(NSDictionary *)message;

@end
