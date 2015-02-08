//
//  ListTableViewCell.m
//  NNZ
//
//  Created by 林 英市 on 2014/12/05.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "ListTableViewCell.h"

@implementation ListTableViewCell

@synthesize label1;
@synthesize label2;
@synthesize label3;
@synthesize label4;
@synthesize label5;
@synthesize label6;
@synthesize label7;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        label1 = [[UILabel alloc] init];
        label1.frame = CGRectMake(5, 5, 100, 56);
        label1.numberOfLines = 0;
        label1.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label1];
        
        label2 = [[UILabel alloc] init];
        label2.frame = CGRectMake(110, 5, 100, 56);
        label2.numberOfLines = 0;
        label2.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label2];
        
        label3 = [[UILabel alloc] init];
        label3.frame = CGRectMake(215, 5, 75, 56);
        label3.numberOfLines = 0;
        label3.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label3];
        
        label4 = [[UILabel alloc] init];
        label4.frame = CGRectMake(295, 0, 105, 66);
        label4.numberOfLines = 0;
        label4.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label4];
        
        label5 = [[UILabel alloc] init];
        label5.frame = CGRectMake(405, 5, 75, 56);
        label5.numberOfLines = 0;
        label5.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label5];
        
        label6 = [[UILabel alloc] init];
        label6.frame = CGRectMake(485, 5, 75, 56);
        label6.numberOfLines = 0;
        label6.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label6];
        
        label7 = [[UILabel alloc] init];
        label7.frame = CGRectMake(565, 5, 100, 56);
        label7.numberOfLines = 0;
        label7.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label7];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
