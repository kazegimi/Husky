//
//  MessageTableViewCell.h
//  NNZ
//
//  Created by 林 英市 on 2014/11/15.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

@property (nonatomic) float width;
@property (nonatomic) NSString *employee_number;

- (void)setMessage:(NSDictionary *)message;

@end
