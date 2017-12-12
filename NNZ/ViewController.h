//
//  ViewController.h
//  NNZ
//
//  Created by 林 英市 on 2014/11/05.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "Downloader.h"
#import "Uploader.h"
#import "Deleter.h"

@interface ViewController : UIViewController <MKMapViewDelegate, UIWebViewDelegate, CLLocationManagerDelegate, UIPopoverControllerDelegate, DownloaderDelegate, UploaderDelegate, DeleterDelegate>

@property (nonatomic, retain) NSTimer *timer;

@end

