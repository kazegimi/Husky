//
//  MessageView.h
//  NNZ
//
//  Created by 林 英市 on 2014/11/19.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MessageTableViewController.h"

@interface MessageView : UIView <UITextFieldDelegate>

@property (nonatomic) NSInteger threadID;
@property (nonatomic) MessageTableViewController *messageTableViewController;

@end
