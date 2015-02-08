//
//  Uploader.h
//  NNZ
//
//  Created by 林 英市 on 2014/12/15.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UploaderDelegate

@optional

- (void)didCompleteConnection;

@end

@interface Uploader : NSObject <NSURLSessionTaskDelegate>

@property (strong, nonatomic) id<UploaderDelegate> delegate;
- (void)upload;

@end
