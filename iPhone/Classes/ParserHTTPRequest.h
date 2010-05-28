//
//  ParserHTTPRequest.h
//  Casocial
//
//  Created by Marcel Hild on 19.05.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ASIHTTPRequest.h"

@interface ParserHTTPRequest : ASIHTTPRequest {
	id parser;

}
@property (nonatomic, retain) id parser;

@end
