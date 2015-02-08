//
//  SettingTableViewCell.m
//  NNZ
//
//  Created by 林 英市 on 2014/11/29.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

@synthesize centerLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        centerLabel = [[UILabel alloc] init];
        centerLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:centerLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
