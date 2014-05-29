//
//  TMOViewController.m
//  webview_post_modified
//
//  Created by Carter-Tsai on 2014/5/18.
//  Copyright (c) 2014年 Carter-Tsai. All rights reserved.
//

#import "TMOViewController.h"

@interface TMOViewController ()

@end

@implementation TMOViewController
@synthesize webView;
@synthesize authenticated;
@synthesize urlConnection;
@synthesize _request;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//
	currentMaxAccelX = 0;
    currentMaxAccelY = 0;
    currentMaxAccelZ = 0;
	
    currentMaxRotX = 0;
    currentMaxRotY = 0;
    currentMaxRotZ = 0;
	
	self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .2;
    self.motionManager.gyroUpdateInterval = .2;
	
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
						withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
							[self outputAccelertionData:accelerometerData.acceleration];
								if(error){
									NSLog(@"%@", error);
								}
						}];
	
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
						withHandler:^(CMGyroData *gyroData, NSError *error) {
							[self outputRotationData:gyroData.rotationRate];
						}];
	
	// Loading https://localhost on WebView
	self.webView.delegate = self;
	NSURL *url = [NSURL URLWithString: @"https://www.google.com"];
    _request = [[NSMutableURLRequest alloc]initWithURL: url];
    [_request setHTTPMethod: @"GET"];
	webView.scalesPageToFit = YES;
    //[request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    [webView loadRequest: _request];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSMutableURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
	if (!authenticated) {
		NSLog(@"NO~~~");
		authenticated = NO;
		urlConnection = [[NSURLConnection alloc] initWithRequest: _request delegate:self startImmediately:YES];
		[urlConnection start];
		return NO;
	}
	NSString* newStr = [[NSString alloc] initWithData:request.HTTPBody
								     encoding:NSUTF8StringEncoding];
	NSLog(@"%@",newStr);
	
	NSURL *URL = [request URL];
	
		NSLog(@"%@", [URL path]);
	if ([[URL path] isEqualToString:@"/signup"]) {
    	NSString *token =@"12312312312ssss";
		NSString *reqString = [NSString stringWithFormat:@"%@&token=%@",newStr,token];
		
		NSData *reqData = [NSData dataWithBytes: [reqString UTF8String]
										  length: [reqString length]];
		
		NSLog(@"my post %@",reqString );
		[request setHTTPBody:reqData];
	}
	return YES;
}

#pragma mark - NURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
{
    NSLog(@"WebController Got auth challange via NSURLConnection");
	
    if ([challenge previousFailureCount] == 0)
    {
        authenticated = YES;
		
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
		
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
		
    } else
    {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    NSLog(@"WebController received response via NSURLConnection");
	
    // remake a webview call now that authentication has passed ok.
    authenticated = YES;
    [webView loadRequest: _request];
	
    // Cancel the URL connection otherwise we double up (webview + url connection, same url = no good!)
    [urlConnection cancel];
}

// We use this method is to accept an untrusted site which unfortunately we need to do, as our PVM servers are self signed.
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
	if(fabs(acceleration.x) > fabs(currentMaxAccelX))
	{
		currentMaxAccelX = acceleration.x;
	}
	if(fabs(acceleration.y) > fabs(currentMaxAccelY))
	{
		currentMaxAccelY = acceleration.y;
	}
	if(fabs(acceleration.z) > fabs(currentMaxAccelZ))
	{
		currentMaxAccelZ = acceleration.z;
	}
	
	NSLog(@"%@", [NSString stringWithFormat:@" %.2f",currentMaxAccelX]);
	NSLog(@"%@", [NSString stringWithFormat:@" %.2f",currentMaxAccelY]);
	NSLog(@"%@", [NSString stringWithFormat:@" %.2f",currentMaxAccelZ]);
	
}
-(void)outputRotationData:(CMRotationRate)rotation
{
	
	if(fabs(rotation.x) > fabs(currentMaxRotX))
	{
		currentMaxRotX = rotation.x;
	}
	
	if(fabs(rotation.y) > fabs(currentMaxRotY))
	{
		currentMaxRotY = rotation.y;
	}
	
	if(fabs(rotation.z) > fabs(currentMaxRotZ))
	{
		currentMaxRotZ = rotation.z;
	}
	
	NSLog(@"%@", [NSString stringWithFormat:@" %.2f",currentMaxRotX]);
	NSLog(@"%@", [NSString stringWithFormat:@" %.2f",currentMaxRotY]);
	NSLog(@"%@", [NSString stringWithFormat:@" %.2f",currentMaxRotZ]);
	
}

@end
