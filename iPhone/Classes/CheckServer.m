//
//  CheckServer.m
//  Casocial
//
//  Created by Marcel Hild on 20.04.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CheckServer.h"
#import "Reachability.h"
#import "CasocialAppDelegate.h"
#import "ParserHTTPRequest.h"
#import "ParserFormDataRequest.h"
#import "PostParser.h"
#import "MessageParser.h"
#import "UserParser.h"
#import "Post.h"
#import "Message.h"

@implementation CheckServer

@synthesize serverUrl;

#pragma mark -
#pragma mark LifeCycle

- (id)init 
{
	// create server url
	serverUrl = [[NSURL alloc] initWithString:URL_SERVER];
	
	CasocialAppDelegate *appDelegate = [CasocialAppDelegate sharedAppDelegate];
	// Check if the remote server is available
    Reachability *reachManager = [Reachability sharedReachability];
    [reachManager setHostName:SERVER_NAME];
    NetworkStatus remoteHostStatus = [reachManager remoteHostStatus];
    if (remoteHostStatus == NotReachable) {
		// alert will be displayed upon first request anyway
      //  [[NSNotificationCenter defaultCenter] removeObserver:self];
//        NSString *msg = @"Server is not reachable! Casocial requires Internet connectivity.";
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Problem" 
//                                                        message:msg 
//                                                       delegate:nil 
//                                              cancelButtonTitle:@"OK" 
//                                              otherButtonTitles:nil];
//        [alert show];
//        [alert release];
    }  else if (remoteHostStatus == ReachableViaWiFiNetwork)  {
        [appDelegate.downloadQueue setMaxConcurrentOperationCount:1];
    } else if (remoteHostStatus == ReachableViaCarrierDataNetwork)  {
        [appDelegate.downloadQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    }
	return self;
}

- (void)dealloc 
{
    [super dealloc];
}

#pragma mark -
#pragma mark Communication with server

- (BOOL)checkNetwork {
	// Check if the remote server is available
    Reachability *reachManager = [Reachability sharedReachability];
    [reachManager setHostName:SERVER_NAME];
    if ([reachManager remoteHostStatus] == NotReachable) {
		NSString *msg = @"Casocial requires Internet connectivity.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Problem" 
                                                        message:msg 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];		
		return FALSE;
	}
	return TRUE;		
}

- (void)sendPostWithTitle:(NSString*)title 
				 withBody:(NSString*)body
			 withCategory:(NSInteger)category
{
	NSURL *url = [self createUrlWithString:URL_POST_CREATE];
	ParserFormDataRequest *request = [[[ParserFormDataRequest alloc] initWithURL:url] autorelease];
	[url release];

	[request setPostValue:title forKey:@"post[title]"];
	[request setPostValue:body forKey:@"post[body]"];
	[request setPostValue:[NSString stringWithFormat:@"%f", [CasocialAppDelegate sharedAppDelegate].location.coordinate.longitude] forKey:@"post[longitude]"];
	[request setPostValue:[NSString stringWithFormat:@"%f", [CasocialAppDelegate sharedAppDelegate].location.coordinate.latitude] forKey:@"post[latitude]"];
	[request setPostValue:[NSString stringWithFormat:@"%f", [CasocialAppDelegate sharedAppDelegate].location.horizontalAccuracy] forKey:@"post[accuracy]"];
	[request setPostValue:[NSString stringWithFormat:@"%0.0f", [[NSDate date] timeIntervalSince1970 ]] forKey:@"post[serial]"];
	[request setPostValue:[NSString stringWithFormat:@"%i", category] forKey:@"post[category]"];

	// Setup Parser Delegate
	request.parser = [[PostParser alloc] init];	

	[self fireRequest:request];
}

- (void)sendMessage:(NSString *)message
			forPost:(Post *)post
		  inReplyTo:(NSNumber*)inReplyTo
	 
{
	NSURL *url = [self createUrlWithString:URL_MESSAGE_CREATE];
	ParserFormDataRequest *request = [[[ParserFormDataRequest alloc] initWithURL:url] autorelease];
	[url release];
	
	[request setPostValue:message forKey:@"message[body]"];
	[request setPostValue:[NSString stringWithFormat:@"%i", [post.postId integerValue]] forKey:@"message[post_id]"];
	[request setPostValue:[NSString stringWithFormat:@"%0.0f", [[NSDate date] timeIntervalSince1970 ]] forKey:@"message[serial]"];
	[request setPostValue:[NSString stringWithFormat:@"%i", [inReplyTo integerValue]] forKey:@"message[in_reply_to_user_id]"];
	
	// Setup Parser Delegate
	request.parser = [[MessageParser alloc] init];	

	[self fireRequest:request];	
}

- (void)sendFeedback:(NSString*)feedback {
	NSURL *url = [self createUrlWithString:URL_FEEDBACK];
	ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:url] autorelease];
	[url release];
	
	[request addRequestHeader:@"Accept" value:@"text/xml"];
	[request addRequestHeader:@"User-Agent" value:@"ParserHTTPRequest"];
	[request setUsername:[[UIDevice currentDevice] uniqueIdentifier]];
	[request setPassword:[[UIDevice currentDevice] uniqueIdentifier]];		
	[request setPostValue:feedback forKey:@"feedback[body]"];	
    NSOperationQueue *queue = [CasocialAppDelegate sharedAppDelegate].downloadQueue;
    [queue addOperation:request];
}

- (void)fetchPostsWithin:(CLLocationDistance)distance {
	// Prepare Post Request
	//NSURL *url = [[NSURL alloc] initWithString:postIds relativeToURL:[[NSURL alloc] initWithString:POSTS_FEED_URL]];
	//ParserHTTPRequest *request = [[[ParserHTTPRequest alloc] initWithURL:url] autorelease];
	NSURL *url = [self createUrlWithString:URL_POSTS];
	ParserFormDataRequest *request = [[[ParserFormDataRequest alloc] initWithURL:url] autorelease];
	[url release];
	
	// Get all local postIds
	NSManagedObjectContext *managedObjectContext = [[CasocialAppDelegate sharedAppDelegate] managedObjectContext];
	NSFetchRequest *fetchRequest = [[[CasocialAppDelegate sharedAppDelegate] managedObjectModel] fetchRequestTemplateForName:@"posts"];	
	//DLog(@"%@", [[[CasocialAppDelegate sharedAppDelegate] managedObjectModel] fetchRequestTemplatesByName]);	
	NSError *error;
	NSArray *array = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	for (Post *post in array) {
		// Append to post request
		// FIXME: asi-http-request should also handle posts[]=1, posts[]=2 format
		//[request setPostValue:@"" forKey:[NSString stringWithFormat:@"p[%i]", [post.postId integerValue]]];
		[request setPostValue:@"" forKey:[NSString stringWithFormat:@"p[%i]", [post.postId integerValue]]];
	}
	
	// Add Locations
	[request setPostValue:[NSString stringWithFormat:@"%f", [CasocialAppDelegate sharedAppDelegate].location.coordinate.longitude] forKey:@"lgn"];
	[request setPostValue:[NSString stringWithFormat:@"%f", [CasocialAppDelegate sharedAppDelegate].location.coordinate.latitude] forKey:@"lat"];
	
	// Add Distance
	if (distance > 0.0) {
		[request setPostValue:[NSString stringWithFormat:@"%f", distance] forKey:@"d"];
	}
	
	//NSMutableString *postIds = [[NSMutableString alloc] init];
	//[postIds setString:@"?"];
	/*
	 if (array != nil && [array count] > 0) {
	 NSEnumerator *enumerator = [array objectEnumerator];
	 Post* post;
	 while (post = [enumerator nextObject]) {
	 [postIds appendFormat:@"%i&", [post.postId integerValue]];
	 }
	 }	
	 [postIds release];
	 */
	
	// Setup Parser Delegate and fire
	request.parser = [[PostParser alloc] init];	
	[self fireRequest:request];	
}

- (void)fetchPosts {
	[self fetchPostsWithin:0.0];
}

- (void)fetchUserId {
	NSURL *url = [self createUrlWithString:URL_USER];
	ParserFormDataRequest *request = [[[ParserFormDataRequest alloc] initWithURL:url] autorelease];
	[url release];
	
	// Setup Parser Delegate
	request.parser = [[UserParser alloc] init];	
	
	[self configRequest:request];
	[request start];
	NSError *error = [request error];
	if (!error) {
		[self requestDone:request];
	}
}

- (void)fetchAllNewMessages {
	// Setup Request and URL
	NSURL *url = [self createUrlWithString:URL_MESSAGES];
	ParserFormDataRequest *request = [[[ParserFormDataRequest alloc] initWithURL:url] autorelease];
	[url release];

	// Fetch the newest local message
	NSManagedObjectContext *managedObjectContext = [[CasocialAppDelegate sharedAppDelegate] managedObjectContext];
	NSFetchRequest *fetchRequest = [[[CasocialAppDelegate sharedAppDelegate] managedObjectModel] fetchRequestTemplateForName:@"messages"];
	
	NSError *error;
	NSArray *array = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	for (Message *message in array) {
		[request setPostValue:@"" forKey:[NSString stringWithFormat:@"m[%i]", [message.messageId integerValue]]];
	}
	
	// Setup Parser Delegate
	request.parser = [[MessageParser alloc] init];
	[self fireRequest:request];
}


- (void)fetchMessages {
	NSDate *lastDate = nil;

	// Fetch the newest local message
	NSManagedObjectContext *managedObjectContext = [[CasocialAppDelegate sharedAppDelegate] managedObjectContext];
	NSFetchRequest *fetchRequest = [[[CasocialAppDelegate sharedAppDelegate] managedObjectModel] fetchRequestTemplateForName:@"messages"];
	
	// Setup Sort Descriptor
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	[fetchRequest setFetchLimit:1];
	NSError *error;
	NSArray *array = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	if (array != nil && [array count] > 0) {
		lastDate = [(Message *)[array lastObject] createdAt];		
	}
	
	NSURL *url;
	if (lastDate) {
		//		DLog([lastDate description]);
		//		DLog(@"%0.0f", [lastDate timeIntervalSince1970]);
		url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"?s=%0.0f", [lastDate timeIntervalSince1970]] relativeToURL:[[NSURL alloc] initWithString:URL_MESSAGES]];
	} else {
		url = [[NSURL alloc] initWithString:URL_MESSAGES];
	}
	
	//ParserHTTPRequest *request = [[ParserHTTPRequest alloc] initWithURL:url];
	ParserHTTPRequest *request = [[[ParserHTTPRequest alloc] initWithURL:url] autorelease];

	[url release];
	
	// Setup Parser Delegate
	request.parser = [[MessageParser alloc] init];	

	[self fireRequest:request];
}

#pragma mark -
#pragma mark ParserHTTPRequest generators

- (void)configRequest:(id)request {
	//	if (![ParserHTTPRequest sessionCookies]) {
	//		DLog(@"%@", [ParserHTTPRequest sessionCookies]);
	//	}
	
	[request addRequestHeader:@"Accept" value:@"text/xml"];
	[request addRequestHeader:@"User-Agent" value:@"ParserHTTPRequest"];
	[request setUsername:[[UIDevice currentDevice] uniqueIdentifier]];
	[request setPassword:[[UIDevice currentDevice] uniqueIdentifier]];	
	//[request setPassword:@"password"];
	//[request setUseSessionPersistance:YES]; //Shouldn't be needed as this is the default
	
	// FIXME: only for debug
	[request setAllowCompressedResponse:NO];
	
	
	[request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
	
}

- (void)fireRequest:(id)request {
	[self configRequest:request];
    NSOperationQueue *queue = [CasocialAppDelegate sharedAppDelegate].downloadQueue;
    [queue addOperation:request];
	// FIXME: maybe this is the objc_send problem?
    //[request release];
}



#pragma mark -
#pragma mark ParserHTTPRequest Delegate Methods

- (void)requestDone:(ParserHTTPRequest *)performedRequest
{
    NSData *data = [performedRequest responseData];
	// FIXME only for debug
	DLog(@"%@", [performedRequest responseHeaders]);

	if (performedRequest.parser) {
		NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
		[xmlParser setDelegate:performedRequest.parser];
		[xmlParser setShouldProcessNamespaces:NO];
		[xmlParser setShouldReportNamespacePrefixes:NO];
		[xmlParser setShouldResolveExternalEntities:NO];
		[xmlParser parse];
		[xmlParser release];
		//request.parser = nil;
	}
}

- (void)requestWentWrong:(ParserHTTPRequest *)request
{
	//    NSError *error = [request error];
	//
	//    if([delegate respondsToSelector:@selector(feed:didFailWithError:)])
	//    {
	//        [delegate feed:self didFailWithError:[error description]];
	//    }
}

- (NSURL*)createUrlWithString:(NSString*)url {
	return [[NSURL alloc] initWithString:url relativeToURL:serverUrl];
}


@end
