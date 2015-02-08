//
//  ThreadTableViewController.h
//  NNZ
//
//  Created by 林 英市 on 2014/11/19.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ThreadTableViewControllerDelegate

@optional

- (void)downloadCommunications;
- (void)didSelectThreadAtID:(NSInteger)threadID;

@end

@interface ThreadTableViewController : UITableViewController
@property (strong, nonatomic) id<ThreadTableViewControllerDelegate> delegate;
@property (nonatomic) UIRefreshControl *refreshControl;

- (void)markThreadAtID:(NSInteger)threadID;

@end
