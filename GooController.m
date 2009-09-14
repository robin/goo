//
//  GooController.m
//  goo
//
//  Created by Robin Lu on 8/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GooController.h"
#import "GemSpecs.h"
#import <PSMTabBarControl/PSMTabBarControl.h>
#import <WebKit/WebKit.h>

@interface GooController (Private)

- (NSTabViewItem*)createViewInTab;

@end

@implementation GooController
static NSString *zoomFactorIdentifier = @"zoom factor";

- (void)setHistoryBar
{
    [historyItemView setEnabled:[webView canGoBack] forSegment:0];
    [historyItemView setEnabled:[webView canGoForward] forSegment:1];
}

- (void)setupTabBar
{
	[tabBar setTabView:tabView];
	[tabBar setPartnerView:tabView];
	[tabBar setStyleNamed:@"Unified"];
	[tabBar setDelegate:self];
	[tabBar setShowAddTabButton:YES];
	[tabBar setSizeCellsToFit:YES];
	[[tabBar addTabButton] setTarget:self];
	[[tabBar addTabButton] setAction:@selector(addNewTab:)];
    [self addNewTab:self];
}

- (void)awakeFromNib
{
	float zoomFactor = [[NSUserDefaults standardUserDefaults] floatForKey:zoomFactorIdentifier];
    [self setupTabBar];
    [self setHistoryBar];
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

#pragma mark browser
- (IBAction)history:(id)sender
{
    NSSegmentedCell * segCell = sender;
	switch ([segCell selectedSegment]) {
		case 0:
            [webView goBack];
			break;
		case 1:
			[webView goForward];
			break;
		default:
			break;
	}    
    [self setHistoryBar];
}

- (IBAction)search:(id)sender
{
    NSString *searchString = [searchField stringValue];
    [webView searchFor:searchString direction:YES caseSensitive:NO wrap:NO];
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

#pragma mark webview frame delegate
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    [self setHistoryBar];
    
    NSTabViewItem *tabItem = [tabView selectedTabViewItem];
    [tabItem setLabel:[webView mainFrameTitle]];
}

#pragma mark actions
- (IBAction)reload:(id)sender
{
    [gemSpecs release];
    gemSpecs = [[GemSpecs alloc] init];
    [gemArrayController setContent:gemSpecs.gemSpecIndex];
    [gemListView reloadData];
}

#pragma mark tab view
- (NSTabViewItem*)createViewInTab
{
	// init the webview
	WebView *newView = [[WebView alloc] init];
	[newView setPolicyDelegate:self];
	[newView setFrameLoadDelegate:self];
	[newView setUIDelegate:self];
	[newView setResourceLoadDelegate:self];
	if([[NSUserDefaults standardUserDefaults] floatForKey:zoomFactorIdentifier]!=0)
	{
		[newView setTextSizeMultiplier:[[NSUserDefaults standardUserDefaults] floatForKey:zoomFactorIdentifier]];
	}
	
	// create new tab item
	NSTabViewItem *newItem = [[[NSTabViewItem alloc] init] autorelease];
	[newItem setView:newView];
    [newItem setLabel:@"(Untitled)"];
	[newItem setIdentifier:newView];
	
	// add to tab view
    [tabView addTabViewItem:newItem];
	
	[newView release];
	return newItem;
}

- (IBAction)addNewTab:(id)sender
{
	NSTabViewItem *item = [self createViewInTab];
	webView = [item identifier];
	[tabView selectTabViewItem:item];    
}

- (IBAction)closeTab:(id)sender
{
    if([tabView numberOfTabViewItems] > 1)
	{
		NSTabViewItem * item = [tabView selectedTabViewItem];
		[tabView removeTabViewItem:item];
	}
	else
		[window close];    
}

- (void)tabView:(NSTabView *)tabView didCloseTabViewItem:(NSTabViewItem *)tabViewItem
{
}

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
	webView = [tabViewItem identifier];
    [self setHistoryBar];
}

- (IBAction)selectNextTabViewItem:(id)sender
{
	[tabView selectNextTabViewItem:sender];
}

- (IBAction)selectPreviousTabViewItem:(id)sender
{
	[tabView selectPreviousTabViewItem:sender];
}

#pragma mark web view
- (IBAction)makeTextLarger:(id)sender
{
    [webView makeTextLarger:sender];
}

- (IBAction)makeTextSmaller:(id)sender
{
    [webView makeTextSmaller:sender];
}

- (IBAction)goFoward:(id)sender
{
    [webView goForward:sender];
}

- (IBAction)goBack:(id)sender
{
    [webView goBack:sender];
}

@end
