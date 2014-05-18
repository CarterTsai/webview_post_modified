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
	// Loading https://localhost
	self.webView.delegate = self;
	NSURL *url = [NSURL URLWithString: @"https://localhost"];
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

@end
