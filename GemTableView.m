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

	NSDictionary *selected = [[controller arrangedObjects] objectAtIndex:i];

	NSMenu *cMenu = [self menu];
	NSMenuItem *item = [cMenu itemWithTag:3];
	BOOL enabled = [[selected objectForKey:@"homepage"] length] > 7;
	[item setEnabled:enabled];
	
	[super rightMouseDown:theEvent];
}

@end
