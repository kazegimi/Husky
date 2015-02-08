//
//  Deleter.h
//  NNZ
//
//  Created by 林 英市 on 2014/12/15.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeleterDelegate

@optional

- (void)didCompleteConnection;

@end

@interface Deleter : NSObject

@property (strong, nonatomic) id<DeleterDelegate> delegate;
- (void)deleteMarker;

@end
