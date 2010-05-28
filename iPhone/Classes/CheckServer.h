//
//  CheckServer.h
//  Casocial
//
//  Created by Marcel Hild on 20.04.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ParserHTTPRequest.h"

@class Post;

@interface CheckServer : NSObject {
	NSURL *serverUrl;
}

@property (nonatomic, assign) 	NSURL *serverUrl;

- (BOOL)checkNetwork;
- (void)sendPostWithTitle:(NSString*)title withBody:(NSString*)body withCategory:(NSInteger)category;
- (void)sendMessage:(NSString*)message forPost:(Post*)post inReplyTo:(NSNumber*)inReplyTo;
- (void)sendFeedback:(NSString*)feedback;
- (void)fetchUserId;
- (void)fetchPosts;
- (void)fetchPostsWithin:(CLLocationDistance)distance;
- (void)fetchMessages;
- (void)fetchAllNewMessages;


- (void)configRequest:(id)request;
- (void)fireRequest:(id)request;

- (void)requestDone:(id)performedRequest;

- (NSURL*)createUrlWithString:(NSString*)url;



@end
