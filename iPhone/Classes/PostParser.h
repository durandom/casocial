//
//  Feed.h
//
//  Created by Marcel on 3/8/09.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface PostParser : NSObject {
    NSString *currentElement;
    NSMutableString *currentTitle;
    NSMutableString *currentBody;
	NSMutableString *currentLatitude;
	NSMutableString *currentLongitude;
	NSMutableString *currentSerial;
	NSMutableString *currentCreatedAt;
	NSMutableString *currentId;
	NSMutableString *currentUserId;
	NSMutableString *currentCategory;
}

@end
