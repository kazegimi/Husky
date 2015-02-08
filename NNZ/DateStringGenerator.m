//
//  DateStringGenerator.m
//  NNZ
//
//  Created by 林 英市 on 2014/12/15.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "DateStringGenerator.h"

@implementation DateStringGenerator

+ (NSAttributedString *)generateDateStringFromDateString:(NSString *)dateString
{
    if (!dateString || [dateString isEqualToString:@""]) return nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Tokyo"]];
    
    NSString *todayString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDate *todayDate = [dateFormatter dateFromString:todayString];
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@", [dateString substringToIndex:10]]];
    
    NSComparisonResult result = [todayDate compare:date];
    
    NSAttributedString *todayOrYesterday;
    switch (result)
    {
        case NSOrderedSame:
            // 同一時刻
            todayOrYesterday = [[NSAttributedString alloc] initWithString:@"今日 "
                                                               attributes:@{ NSForegroundColorAttributeName : [UIColor blueColor] }];
            break;
        case NSOrderedAscending:
            // nowよりotherDateのほうが未来
            todayOrYesterday = [[NSAttributedString alloc] initWithString:@"明日 "
                                                               attributes:@{ NSForegroundColorAttributeName : [UIColor redColor] }];
            break;
        case NSOrderedDescending:
            // nowよりotherDateのほうが過去
            todayOrYesterday = [[NSAttributedString alloc] initWithString:@"昨日 "
                                                               attributes:@{ NSForegroundColorAttributeName : [UIColor redColor] }];
            break;
    }
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] init];
    [mutableAttributedString appendAttributedString:todayOrYesterday];
    
    NSAttributedString *timeString = [[NSAttributedString alloc] initWithString:[dateString substringFromIndex:11]
                                                                     attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
    [mutableAttributedString appendAttributedString:timeString];
    
    return mutableAttributedString;
}

@end
