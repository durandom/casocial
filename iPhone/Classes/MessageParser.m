//
//  Messages.m
//  Casocial
//
//  Created by Marcel Hild on 06.05.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MessageParser.h"
#import "Message.h"
#import "Post.h"
#import "CasocialAppDelegate.h"


@implementation MessageParser

- (void)dealloc 
{
    [currentElement release];
    [currentBody release];
    [currentSerial release];
	[currentCreatedAt release];
	[currentPostId release];
	[currentMessageId release];
	[currentUserId release];
	[currentInReplyToUserId release];
    [super dealloc];
}


#pragma mark NSXMLParserDelegate methods

// The following code is adapted from
// http://theappleblog.com/2008/08/04/tutorial-build-a-simple-rss-reader-for-iphone

- (void)parserDidStartDocument:(NSXMLParser *)parser 
{
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{
//    if([delegate respondsToSelector:@selector(feed:didFailWithError:)])
//    {
//        NSString *errorMsg = [NSString stringWithFormat:@"Unable to download feed from web site (Error code %i )", [parseError code]];
//        [delegate feed:self didFailWithError:errorMsg];
//    }    
}

-   (void)parser:(NSXMLParser *)parser 
 didStartElement:(NSString *)elementName 
	namespaceURI:(NSString *)namespaceURI 
   qualifiedName:(NSString *)qName 
	  attributes:(NSDictionary *)attributeDict  {
	
    currentElement = [elementName copy];
    
    if ([currentElement isEqualToString:@"body"]) {
        [currentBody release];
        currentBody = nil;        
        currentBody = [[NSMutableString alloc] init];
    }  else if ([currentElement isEqualToString:@"serial"]) {
        [currentSerial release];
        currentSerial = nil;        
        currentSerial = [[NSMutableString alloc] init];
    }  else if ([currentElement isEqualToString:@"post-id"]) {
        [currentPostId release];
        currentPostId = nil;        
        currentPostId = [[NSMutableString alloc] init];
	}  else if ([currentElement isEqualToString:@"c"]) {
        [currentCreatedAt release];
        currentCreatedAt = nil;        
        currentCreatedAt = [[NSMutableString alloc] init];
	}  else if ([currentElement isEqualToString:@"id"]) {
        [currentMessageId release];
        currentMessageId = nil;        
        currentMessageId = [[NSMutableString alloc] init];
    } else if ([currentElement isEqualToString:@"user-id"]) {
        [currentUserId release];
        currentUserId = nil;        
        currentUserId = [[NSMutableString alloc] init];
	}  else if ([currentElement isEqualToString:@"in-reply-to-user-id"]) {
        [currentInReplyToUserId release];
        currentInReplyToUserId = nil;        
        currentInReplyToUserId = [[NSMutableString alloc] init];
	} 
	//    else if ([currentElement isEqualToString:@"media:thumbnail"]) 
	//    {
	//        [currentThumbnail appendString:[attributeDict objectForKey:@"url"]];
	//    }        
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"message"]) {
		NSError *error;
		NSManagedObjectContext *managedObjectContext = [[CasocialAppDelegate sharedAppDelegate] managedObjectContext];
		
		// Find corresponding Post
		NSFetchRequest *request = [[[CasocialAppDelegate sharedAppDelegate] managedObjectModel] fetchRequestFromTemplateWithName:@"postForId" 
																										  substitutionVariables: [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:[currentPostId integerValue]], @"POSTID", nil]];
		
//		NSEntityDescription *entityDescription = [NSEntityDescription
//												  entityForName:@"Post" inManagedObjectContext:managedObjectContext];
//		NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
//		[request setEntity:entityDescription];
//		NSPredicate *predicate = [NSPredicate predicateWithFormat:
//								  @"(lastName LIKE[c] 'Worsley') AND (salary > %@)", minimumSalary];
//		[request setPredicate:predicate];
		
		NSArray *posts = [managedObjectContext executeFetchRequest:request error:&error];
		if (posts == nil || [posts count] == 0) {
			// FIXME fetch post from server
			DLog(@"No corresponding Post found for messageId %i", [currentMessageId integerValue]);
			return;
		}

		// Create and configure a new instance of the Message entity
		Message *message = (Message *)[NSEntityDescription insertNewObjectForEntityForName:@"Message"
																	inManagedObjectContext:managedObjectContext];

        [message setSerial:[NSNumber numberWithInteger:[currentSerial integerValue]]];
        [message setMessageId:[NSNumber numberWithInteger:[currentMessageId integerValue]]];
        [message setUserId:[NSNumber numberWithInteger:[currentUserId integerValue]]];
        [message setInReplyToUserId:[NSNumber numberWithInteger:[currentInReplyToUserId integerValue]]];
		[message setCreatedAt:[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[currentCreatedAt doubleValue]]];
		[message setBody:currentBody];
		[message setPost:[posts objectAtIndex:0]];

		[[[CasocialAppDelegate sharedAppDelegate] mainViewController] setMessageUnread:message];		
		if (![managedObjectContext save:&error]) {
			// Handle the error.
			DLog(@"Error in file %s (%i) \n%@", __FILE__, __LINE__, error);
			// FIXME: setMessage unread, in case
			return;
		}
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([currentElement isEqualToString:@"body"]) 
    {
        [currentBody appendString:string];
    } 
    else if ([currentElement isEqualToString:@"serial"]) 
    {
		[currentSerial appendString:string];
    } 
    else if ([currentElement isEqualToString:@"post-id"]) 
    {		
        [currentPostId appendString:string];
    } 
    else if ([currentElement isEqualToString:@"c"]) 
    {
        [currentCreatedAt appendString:string];
    } 
    else if ([currentElement isEqualToString:@"id"]) 
    {
        [currentMessageId appendString:string];
    } 
    else if ([currentElement isEqualToString:@"user-id"]) 
    {		
        [currentUserId appendString:string];
    } 
    else if ([currentElement isEqualToString:@"in-reply-to-user-id"]) 
    {		
        [currentInReplyToUserId appendString:string];
    } 
	
}

@end
