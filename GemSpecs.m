//
//  GemSpecs.m
//  goo
//
//  Created by Robin Lu on 8/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GemSpecs.h"

@interface GemSpecs (Private)
- (void)sort;

@end

@implementation GemSpecs
@synthesize gemSpecIndex;

- (id)init
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"gem_helper" ofType:@"rb"];
	NSTask *task = [[[NSTask alloc] init] autorelease];
    [task setLaunchPath:@"/bin/bash"];
    NSArray *arguments = [NSArray arrayWithObjects:@"-l", @"-c", path, nil];
    [task setArguments:arguments];
	NSPipe *outPipe = [[NSPipe alloc] init];
	[task setStandardOutput:outPipe];
	[outPipe release];
	[task launch];
	
	NSData *data = [[outPipe fileHandleForReading] readDataToEndOfFile];
	NSPropertyListFormat format;
	NSString *error;
	gemSpecIndex = [NSPropertyListSerialization propertyListFromData:data
							mutabilityOption:NSPropertyListImmutable
							format:&format
							errorDescription:&error];
	if (!gemSpecIndex)
		NSLog(@"%@", error);
	[self sort];
	return self;
}

- (void)sort
{
	NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"version" ascending:NO];
	NSMutableArray * sda = [[NSMutableArray alloc] init];
	[sda addObject:sd];
	[sda addObject:sd2];
	gemSpecIndex = [gemSpecIndex sortedArrayUsingDescriptors:sda];
	[sda release];
	[sd release];
	[sd2 release];
}
@end
