//
//  RSS.h
//  Casocial
//
//  Created by Marcel on 3/8/09.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PostParser.h"
#import "Post.h"
#import "CasocialAppDelegate.h"

@implementation PostParser

- (void)dealloc 
{
    [currentElement release];
    [currentTitle release];
    [currentBody release];
	[currentLatitude release];
	[currentLongitude release];
	[currentId release];
	[currentUserId release];
	[currentCategory release];
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

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
                                        namespaceURI:(NSString *)namespaceURI 
                                       qualifiedName:(NSString *)qName 
                                          attributes:(NSDictionary *)attributeDict
{
    currentElement = [elementName copy];
    
    if ([currentElement isEqualToString:@"title"]) {
        [currentTitle release];
        currentTitle = nil;        
        currentTitle = [[NSMutableString alloc] init];
    }  else if ([currentElement isEqualToString:@"body"]) {
        [currentBody release];
        currentBody = nil;        
        currentBody = [[NSMutableString alloc] init];
    }  else if ([currentElement isEqualToString:@"longitude"]) {
        [currentLongitude release];
        currentLongitude = nil;        
        currentLongitude = [[NSMutableString alloc] init];
	}  else if ([currentElement isEqualToString:@"latitude"]) {
        [currentLatitude release];
        currentLatitude = nil;        
        currentLatitude = [[NSMutableString alloc] init];
	}  else if ([currentElement isEqualToString:@"id"]) {
        [currentId release];
        currentId = nil;        
        currentId = [[NSMutableString alloc] init];
	}  else if ([currentElement isEqualToString:@"c"]) {
        [currentCreatedAt release];
        currentCreatedAt = nil;        
        currentCreatedAt = [[NSMutableString alloc] init];
	}  else if ([currentElement isEqualToString:@"serial"]) {
        [currentSerial release];
        currentSerial = nil;        
        currentSerial = [[NSMutableString alloc] init];
    }  else if ([currentElement isEqualToString:@"category"]) {
        [currentCategory release];
        currentCategory = nil;        
        currentCategory = [[NSMutableString alloc] init];
    } else if ([currentElement isEqualToString:@"user-id"]) {
        [currentUserId release];
        currentUserId = nil;        
        currentUserId = [[NSMutableString alloc] init];
	}
	
	//    else if ([currentElement isEqualToString:@"media:thumbnail"]) 
	//    {
	//        [currentThumbnail appendString:[attributeDict objectForKey:@"url"]];
	//    }        
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([currentElement isEqualToString:@"title"]) 
    {
        [currentTitle appendString:string];
    } 
    else if ([currentElement isEqualToString:@"body"]) 
    {
        [currentBody appendString:string];
    } 
    else if ([currentElement isEqualToString:@"longitude"]) 
    {
        [currentLongitude appendString:string];
    } 
    else if ([currentElement isEqualToString:@"latitude"]) 
    {
        [currentLatitude appendString:string];
    } 
    else if ([currentElement isEqualToString:@"id"]) 
    {
        [currentId appendString:string];
    } 
    else if ([currentElement isEqualToString:@"c"]) 
    {
        [currentCreatedAt appendString:string];
    } 
    else if ([currentElement isEqualToString:@"serial"]) 
    {
        [currentSerial appendString:string];
    } 
    else if ([currentElement isEqualToString:@"category"]) 
    {
        [currentCategory appendString:string];
    } 
	else if ([currentElement isEqualToString:@"user-id"]) 
    {		
        [currentUserId appendString:string];
    } 
	
}


- (void)parserDidEndDocument:(NSXMLParser *)parser 
{
	//    if ([delegate respondsToSelector:@selector(feed:didFindPosts:)])
	//    {
	//        [delegate feed:self didFindPosts:posts];
	//    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
                                      namespaceURI:(NSString *)namespaceURI 
                                     qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:@"post"]) 
    {
		if ([[[[CasocialAppDelegate sharedAppDelegate] mainViewController] postIds] containsObject:[NSNumber numberWithInteger:[currentId integerValue]]]) {
			DLog(@"dont allow %@", currentId);
			return;
		}
		
		//        Post *post = [[Post alloc] init];
		NSManagedObjectContext *managedObjectContext = [[CasocialAppDelegate sharedAppDelegate] managedObjectContext];

		// Create and configure a new instance of the Post entity
		Post *post = (Post *)[NSEntityDescription insertNewObjectForEntityForName:@"Post"
														   inManagedObjectContext:managedObjectContext];
		
//        [currentTitle replaceOccurrencesOfString:@"\n" 
//                                      withString:@"" 
//                                         options:NSCaseInsensitiveSearch 
//                                           range:NSMakeRange(0, [currentTitle length])];

		[post setPostId:[NSNumber numberWithInteger:[currentId integerValue]]];
		[post setUserId:[NSNumber numberWithInteger:[currentUserId integerValue]]];
        [post setTitle:currentTitle];		
		[post setBody:currentBody];
		[post setSerial:[NSNumber numberWithInteger:[currentSerial integerValue]]];
		[post setLongitude:[NSNumber numberWithInteger:[currentLongitude integerValue]]];
		[post setLatitude:[NSNumber numberWithInteger:[currentLatitude integerValue]]];
		[post setCategory:[NSNumber numberWithInteger:[currentCategory integerValue]]];
		CLLocation* location = [[CLLocation alloc] initWithLatitude:[currentLatitude doubleValue] longitude:[currentLongitude doubleValue]];
		[post setLocation:location];
		[location release];
		[post setCreatedAt:[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[currentCreatedAt doubleValue]]];
		
		NSError *error;
		if (![managedObjectContext save:&error]) {
			// Handle the error.
			DLog(@"Error in file %s (%i) \n%@", __FILE__, __LINE__, error);
		}

//		post.postId = [currentId intValue];
//		post.location = [[CLLocation alloc] initWithLatitude:currentLatitude.floatValue longitude:currentLongitude.floatValue];
//        [posts addObject:post];
//        [post release];
    }
}


@end
