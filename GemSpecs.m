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
	NSTask *task = [[NSTask alloc] init];
	NSLog(path);
	[task setLaunchPath:path];
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
		NSLog(error);
	NSLog(@"spec list: %@", gemSpecIndex);
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
