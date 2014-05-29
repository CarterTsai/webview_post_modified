//
//  TMOViewController.h
//  webview_post_modified
//
//  Created by Carter-Tsai on 2014/5/18.
//  Copyright (c) 2014年 Carter-Tsai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

double currentMaxAccelX;
double currentMaxAccelY;
double currentMaxAccelZ;
double currentMaxRotX;
double currentMaxRotY;
double currentMaxRotZ;

@interface TMOViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property Boolean authenticated;
@property NSURLConnection *urlConnection;
@property NSMutableURLRequest *_request;
@property (strong, nonatomic) CMMotionManager *motionManager;

@end
