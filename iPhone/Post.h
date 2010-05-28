//
//  Post.h
//  Casocial
//
//  Created by Marcel Hild on 19.06.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Message;

@interface Post :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * category;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) id location;
@property (nonatomic, retain) NSNumber * accuracy;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * postId;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * serial;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSSet* messages;

@end


@interface Post (CoreDataGeneratedAccessors)
- (void)addMessagesObject:(Message *)value;
- (void)removeMessagesObject:(Message *)value;
- (void)addMessages:(NSSet *)value;
- (void)removeMessages:(NSSet *)value;

@end

