//
//  Uploader.m
//  NNZ
//
//  Created by 林 英市 on 2014/12/15.
//  Copyright (c) 2014年 skyElements. All rights reserved.
//

#import "Uploader.h"

@implementation Uploader
{
    BOOL uploading;
    
    NSURLSession *session;
    NSMutableURLRequest *request;
}

@synthesize delegate;

- (id)init
{
    if (self = [super init])
    {
        uploading = NO;
        
        NSURL *url = [NSURL URLWithString:@"http://location.serverrush.com/husky/upload.php"];
        //NSString *identifier = [NSDate date].description;
        NSURLSessionConfiguration *configuration;
        configuration.timeoutIntervalForRequest = 5;
        configuration.timeoutIntervalForResource = 5;
        configuration.HTTPMaximumConnectionsPerHost = 1;
        configuration.allowsCellularAccess = YES;
        configuration.networkServiceType = NSURLNetworkServiceTypeBackground;
        configuration.discretionary = NO;
        session = [NSURLSession sessionWithConfiguration:configuration
                                                              delegate:self
                                                         delegateQueue:[NSOperationQueue mainQueue]];
        request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = @"PUT";
    }
    return self;
}

- (void)upload
{
    if (uploading == NO && [[NSUserDefaults standardUserDefaults] boolForKey:@"privacySwitch"])
    {
        uploading = YES;
        
        NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
        NSString *dev_token;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"dev_token"])
        {
            dev_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"dev_token"];
        }else
        {
            dev_token = @"";
        }
        NSString *employee_number = [[NSUserDefaults standardUserDefaults] objectForKey:@"employee_number"];
        float lat = [[NSUserDefaults standardUserDefaults] floatForKey:@"lat"];
        float lon = [[NSUserDefaults standardUserDefaults] floatForKey:@"lon"];
        NSString *showup_airport = [[NSUserDefaults standardUserDefaults] objectForKey:@"showup_airport"];
        float showup_airport_lat = [[NSUserDefaults standardUserDefaults] floatForKey:@"showup_airport_lat"];
        float showup_airport_lon = [[NSUserDefaults standardUserDefaults] floatForKey:@"showup_airport_lon"];
        NSString *showup_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"showup_time"];
        NSString *category = [[NSUserDefaults standardUserDefaults] objectForKey:@"category"];
        NSString *flight = [[NSUserDefaults standardUserDefaults] objectForKey:@"flight"];
        NSString *license = [[NSUserDefaults standardUserDefaults] objectForKey:@"license"];
        float accuracy = [[NSUserDefaults standardUserDefaults] floatForKey:@"accuracy"];
        float speed = [[NSUserDefaults standardUserDefaults] floatForKey:@"speed"];
        /*
        float speed = newLocation.speed * 3600.0f / 1000.0f;
        if (speed < 0) speed = 0.0f;
        */
        float battery = [UIDevice currentDevice].batteryLevel;
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    uuid, @"uuid",
                                    dev_token, @"dev_token",
                                    employee_number, @"employee_number",
                                    [NSNumber numberWithFloat:lat], @"lat",
                                    [NSNumber numberWithFloat:lon], @"lon",
                                    showup_airport, @"showup_airport",
                                    [NSNumber numberWithFloat:showup_airport_lat], @"showup_airport_lat",
                                    [NSNumber numberWithFloat:showup_airport_lon], @"showup_airport_lon",
                                    showup_time, @"showup_time",
                                    category, @"category",
                                    flight, @"flight",
                                    license, @"license",
                                    [NSNumber numberWithFloat:accuracy], @"accuracy",
                                    [NSNumber numberWithFloat:speed], @"speed",
                                    [NSNumber numberWithFloat:battery], @"battery",
                                    [NSNumber numberWithFloat:version], @"version", nil];
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *path = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"json.data"];
        [data writeToFile:path atomically:YES];
        
        path = [NSString stringWithFormat:@"file://%@", path];
        NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request fromFile:[NSURL URLWithString:path]];
        
        [task resume];
    }else
    {
        if (!uploading) [delegate didCompleteConnection];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error)
    {
        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"位置情報アップロードエラー"
                                                        message:error.description
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        */
    }
    
    NSLog(@"upload");
    
    [delegate didCompleteConnection];
    uploading = NO;
}

- (NSURL *)applicationDocumentsDirectory
{
    // The directory the application uses to store the Core Data store file. This code uses a directory named "jp.skyElements.NNZ" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end

