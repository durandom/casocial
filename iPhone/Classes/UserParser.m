//
//  RSS.h
//  Casocial
//
//  Created by Marcel on 3/8/09.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "UserParser.h"
#import "CasocialAppDelegate.h"

@implementation UserParser

- (void)dealloc 
{
    [currentElement release];
	[currentId release];
    [super dealloc];
}


#pragma mark NSXMLParserDelegate methods

- (void)parserDidStartDocument:(NSXMLParser *)parser 
{
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
	attributes:(NSDictionary *)attributeDict
{
    currentElement = [elementName copy];
    
	if ([currentElement isEqualToString:@"id"]) {
        [currentId release];
        currentId = nil;        
        currentId = [[NSMutableString alloc] init];
	}     
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if ([currentElement isEqualToString:@"id"]) 
    {
        [currentId appendString:string];
    } 
}


- (void)parserDidEndDocument:(NSXMLParser *)parser 
{
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"user"]) {
		[CasocialAppDelegate sharedAppDelegate].userId = [currentId integerValue];
    }
}


@end
