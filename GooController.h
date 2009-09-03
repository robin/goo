//
//  GooController.h
//  goo
//
//  Created by Robin Lu on 8/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class GemSpecs;
@class WebView;

@interface GooController : NSObject {
	IBOutlet GemSpecs*	gemSpecs;
	IBOutlet WebView*	webView;
	IBOutlet NSTableView* gemInfoView;
	IBOutlet NSArrayController* gemArrayController;
	IBOutlet NSSegmentedControl *historyItemView;
    IBOutlet NSSearchField  *searchField;
}

- (IBAction)openInFinder:(id)sender;
- (IBAction)openInEditor:(id)sender;
- (IBAction)openInHomepage:(id)sender;

- (IBAction)donate:(id)sender;
- (IBAction)homepage:(id)sender;
- (IBAction)history:(id)sender;
- (IBAction)search:(id)sender;
@end
