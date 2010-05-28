//
//  ParserFormDataRequest.m
//  Casocial
//
//  Created by Marcel Hild on 19.05.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ParserFormDataRequest.h"


@implementation ParserFormDataRequest

@synthesize parser;

- (void)dealloc
{
	[parser release];
	[super dealloc];
}

@end
