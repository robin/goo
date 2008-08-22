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
static NSString *zoomFactorIdentifier = @"zoom factor";

- (void)awakeFromNib
{
	float zoomFactor = [[NSUserDefaults standardUserDefaults] floatForKey:zoomFactorIdentifier];
	if(0!=zoomFactor)
	{
		[webView setTextSizeMultiplier:zoomFactor];
	}
}

#pragma mark table view delegate
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

#pragma mark window view delegate
- (void)windowWillClose:(NSNotification *)notification
{
	float zoomFactor = [webView textSizeMultiplier];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setFloat:zoomFactor forKey:zoomFactorIdentifier];
	[userDefaults synchronize];
}

#pragma mark table view menu
- (IBAction)openInFinder:(id)sender
{
	NSDictionary *selected = [[gemArrayController selectedObjects] objectAtIndex:0];
	NSString *path = [selected objectForKey:@"path"];
	[[NSWorkspace sharedWorkspace] openFile:path];
}

- (IBAction)openInEditor:(id)sender
{
	NSDictionary *selected = [[gemArrayController selectedObjects] objectAtIndex:0];
	NSString *path = [selected objectForKey:@"path"];
	[[NSWorkspace sharedWorkspace] openFile:path withApplication:@"TextMate"];
}

- (IBAction)openInHomepage:(id)sender
{
	NSDictionary *selected = [[gemArrayController selectedObjects] objectAtIndex:0];
	NSString *path = [selected objectForKey:@"homepage"];
	NSURL *url = [NSURL URLWithString:path];
	[[NSWorkspace sharedWorkspace] openURL:url];
}

#pragma mark Links
- (IBAction)donate:(id)sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=iamawalrus%40gmail%2ecom&item_name=Goo&amount=4%2e99&no_shipping=0&no_note=1&tax=0&currency_code=USD&lc=US&bn=PP%2dDonationsBF&charset=UTF%2d8"]];
}

- (IBAction)homepage:(id)sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.robinlu.com/blog/goo"]];
}

@end
