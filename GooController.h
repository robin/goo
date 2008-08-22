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
}

- (IBAction)openInFinder:(id)sender;
- (IBAction)openInEditor:(id)sender;

@end
