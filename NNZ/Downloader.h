//
//  Downloader.h
//  NNZ
//
//  Created by Eiichi Hayashi on 2017/12/12.
//  Copyright © 2017年 skyElements. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloaderDelegate

@optional

- (void)didFinishDownloadingWithData:(NSData *)data;
- (void)didFailDownloading;

@end

@interface Downloader : NSObject <NSURLSessionDelegate>

@property (strong, nonatomic) id<DownloaderDelegate> delegate;

- (void)startDownloading;

@end
