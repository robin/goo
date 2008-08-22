//
//  GooController.m
//  goo
//
//  Created by Robin Lu on 8/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GooController.h"
#import "GemSpecs.h"
#import <WebKit/WebKit.h>

@implementation GooController

- (void)awakeFromNib
{
	if([[NSUserDefaults standardUserDefaults] floatForKey:@"zoom factor"]!=0)
	{
		[webView setTextSizeMultiplier:[[NSUserDefaults standardUserDefaults] floatForKey:@"zoom factor"]];
	}
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	[gemInfoView reloadData];
	
	NSDictionary *selected = [[gemArrayController selectedObjects] objectAtIndex:0];
	NSString *path = [NSString stringWithFormat:@"%@/index.html", [selected objectForKey:@"doc_path"]];
	
	NSURL *url;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ( ![fileManager fileExistsAtPath:path isDirectory:NULL] ) {
		path = @"about:blank";
		url = [NSURL URLWithString:path];
	}
	else
		url = [NSURL fileURLWithPath:path];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[[webView mainFrame] loadRequest:request];
}

- (void)windowWillClose:(NSNotification *)notification
{
	float zoomFactor = [webView textSizeMultiplier];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setFloat:zoomFactor forKey:@"zoom factor"];
	[userDefaults synchronize];
}
@end
