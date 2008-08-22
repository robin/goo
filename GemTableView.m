//
//  GemTableView.m
//  goo
//
//  Created by Robin Lu on 8/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GemTableView.h"


@implementation GemTableView
- (void)rightMouseDown:(NSEvent *)theEvent {       
	NSPoint p = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	
	int i = [self rowAtPoint:p];
	
	if (i < [self numberOfRows] && ![[self selectedRowIndexes] containsIndex:i]) {
		[self selectRowIndexes:[NSIndexSet indexSetWithIndex:i] byExtendingSelection:NO];
	}
	
	[super rightMouseDown:theEvent];
}

@end
