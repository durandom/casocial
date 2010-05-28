//
//  Messages.h
//  Casocial
//
//  Created by Marcel Hild on 06.05.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@interface MessageParser : NSObject {
	
    NSString *currentElement;
	NSMutableString *currentMessageId;
	NSMutableString *currentPostId;
	NSMutableString *currentBody;
    NSMutableString *currentSerial;
	NSMutableString *currentCreatedAt;
	NSMutableString *currentUserId;
	NSMutableString *currentInReplyToUserId;
}

@end
