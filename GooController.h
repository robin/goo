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
@class PSMTabBarControl;

@interface GooController : NSObject {
	IBOutlet GemSpecs*	gemSpecs;
	IBOutlet WebView*	webView;
	IBOutlet NSTableView* gemInfoView;
	IBOutlet NSArrayController* gemArrayController;
	IBOutlet NSSegmentedControl *historyItemView;
    IBOutlet NSSearchField  *searchField;
    IBOutlet NSTableView* gemListView;
    IBOutlet PSMTabBarControl* tabBar;
    IBOutlet NSTabView*        tabView;
    IBOutlet NSWindow*         window;
}

- (IBAction)openInFinder:(id)sender;
- (IBAction)openInEditor:(id)sender;
- (IBAction)openInHomepage:(id)sender;
- (IBAction)generateRDoc:(id)sender;
- (IBAction)uninstallGem:(id)sender;

- (IBAction)donate:(id)sender;
- (IBAction)homepage:(id)sender;
- (IBAction)history:(id)sender;
- (IBAction)search:(id)sender;
- (IBAction)reload:(id)sender;

// webview
- (IBAction)makeTextLarger:(id)sender;
- (IBAction)makeTextSmaller:(id)sender;
- (IBAction)goFoward:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)print:(id)sender;

// tab
- (IBAction)addNewTab:(id)sender;
- (IBAction)closeTab:(id)sender;
- (IBAction)selectNextTabViewItem:(id)sender;
- (IBAction)selectPreviousTabViewItem:(id)sender;
@end
