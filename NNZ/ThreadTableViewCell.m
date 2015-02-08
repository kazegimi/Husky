//
//  ThreadTableViewCell.m
//  NNZ
//
//  Created by 林 英市 on 2014/11/19.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "ThreadTableViewCell.h"

@implementation ThreadTableViewCell

@synthesize threadID;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
