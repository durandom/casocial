//
//  Message.h
//  Casocial
//
//  Created by Marcel Hild on 22.06.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Post;

@interface Message :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSNumber * inReplyToUserId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * messageId;
@property (nonatomic, retain) NSNumber * serial;
@property (nonatomic, retain) Post * post;

@end



