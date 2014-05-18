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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Loading http://localhost:8880
	self.webView.delegate = self;
	NSURL *url = [NSURL URLWithString: @"http://localhost:8880"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    [request setHTTPMethod: @"GET"];
	webView.scalesPageToFit = YES;
    //[request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    [webView loadRequest: request];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSMutableURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
	NSString* newStr = [[NSString alloc] initWithData:request.HTTPBody
								     encoding:NSUTF8StringEncoding];
	NSLog(@"%@",newStr);
	
	NSURL *URL = [request URL];
	
	//	NSLog(@"%@", [URL path]);
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

@end
