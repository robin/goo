//
//  GemInfoView.m
//  goo
//
//  Created by Robin Lu on 8/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GemInfoView.h"


@implementation GemInfoView
- (id)init
{
	gemInfoKeys = [NSArray arrayWithObjects:@"name", @"version", @"authors", @"homepage", nil];
	[gemInfoKeys retain];
	return self;
}

- (void)dealloc
{
	[gemInfoKeys release];
	[super dealloc];
}

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return [gemInfoKeys count];
}

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
			row:(int)rowIndex
{
	if ( [[aTableColumn identifier] isEqualToString:@"key"] )
		return [gemInfoKeys objectAtIndex:rowIndex];
	else
	{
		NSArray *infos = [controller arrangedObjects];
		if ([controller selectionIndex] == NSNotFound)
			return nil;
		NSDictionary *selected = [infos objectAtIndex:[controller selectionIndex]];
		return [selected objectForKey:[gemInfoKeys objectAtIndex:rowIndex]];
	}
}
@end
