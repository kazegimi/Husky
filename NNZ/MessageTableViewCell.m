//
//  MessageTableViewCell.m
//  NNZ
//
//  Created by 林 英市 on 2014/11/15.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "MessageTableViewCell.h"

#import "DateStringGenerator.h"

@implementation MessageTableViewCell
{
    UILabel *senderLabel;
    UIView *messageView;
    UILabel *messageLabel;
    UILabel *timestampLabel;
}

@synthesize width;
@synthesize employee_number;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        senderLabel = [[UILabel alloc] init];
        senderLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:senderLabel];
        
        messageView = [[UIView alloc] init];
        //messageView.layer.cornerRadius = 5;
        //messageView.layer.masksToBounds = YES;
        [self addSubview:messageView];
        
        messageLabel = [[UILabel alloc] init];
        messageLabel.textColor = [UIColor darkGrayColor];
        messageLabel.font = [UIFont systemFontOfSize:20];
        messageLabel.minimumScaleFactor = 20;
        messageLabel.numberOfLines = 0;
        [messageView addSubview:messageLabel];
        
        timestampLabel = [[UILabel alloc] init];
        timestampLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:timestampLabel];
    }
    return self;
}

- (void)setMessage:(NSDictionary *)message
{
    float goldenRatio = 1.618;
    float denominator = 1.0f + goldenRatio;
    width = 670 / (1 + goldenRatio) * goldenRatio;
    
    NSAttributedString *attributedString = [DateStringGenerator generateDateStringFromDateString:message[@"timestamp"]];
    
    if (!attributedString) attributedString = [[NSAttributedString alloc] initWithString:@"送信中..."
                                                                              attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }];
    
    if ([message[@"sender"] isEqualToString:employee_number])
    {
        senderLabel.frame = CGRectMake(width / denominator, 5, width / denominator * goldenRatio - 20, 22);
        senderLabel.text = @"";
        senderLabel.textAlignment = NSTextAlignmentRight;
        
        messageLabel.frame = CGRectMake(5, 5, width / denominator * goldenRatio - 25, 0);
        messageLabel.text = message[@"message"];
        [messageLabel sizeToFit];
        messageLabel.frame = CGRectMake(5, 5, width / denominator * goldenRatio - 25, messageLabel.frame.size.height);
        
        messageView.frame = CGRectMake(width / denominator, 27, width / denominator * goldenRatio - 15, messageLabel.frame.size.height + 10);
        messageView.backgroundColor = [UIColor colorWithRed:0.941 green:0.973 blue:1.0 alpha:1.0];
        
        timestampLabel.frame = CGRectMake(15, 27 + messageView.frame.size.height - 22, width / denominator - 20, 22);
        timestampLabel.attributedText = attributedString;
        timestampLabel.textAlignment = NSTextAlignmentRight;
    }else
    {
        senderLabel.frame = CGRectMake(20, 5, width / denominator * goldenRatio - 20, 22);
        senderLabel.text = message[@"sender"];
        senderLabel.textAlignment = NSTextAlignmentLeft;
        
        messageLabel.frame = CGRectMake(5, 5, width / denominator * goldenRatio - 25, 0);
        messageLabel.text = message[@"message"];
        [messageLabel sizeToFit];
        messageLabel.frame = CGRectMake(5, 5, width / denominator * goldenRatio - 25, messageLabel.frame.size.height);
        
        messageView.frame = CGRectMake(15, 27, width / denominator * goldenRatio - 15, messageLabel.frame.size.height + 10);
        messageView.backgroundColor = [UIColor whiteColor];
        
        timestampLabel.frame = CGRectMake(width / denominator * goldenRatio + 5, 27 + messageView.frame.size.height - 22, width / denominator - 20, 22);
        timestampLabel.attributedText = attributedString;
        timestampLabel.textAlignment = NSTextAlignmentLeft;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
