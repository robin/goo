//
//  GemInfoView.h
//  goo
//
//  Created by Robin Lu on 8/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GemInfoView : NSObject {
	IBOutlet NSArrayController* controller;
	
	NSArray *gemInfoKeys;
}

@end
