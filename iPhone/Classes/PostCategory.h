//
//  PostCompareByLocation.h
//  Casocial
//
//  Created by Marcel Hild on 18.05.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@class Post;

@interface Post (PostCategory) 
- (NSComparisonResult)compareByLocation:(Post *)post;
- (NSString*)dateString;
- (NSString*)distanceFromHere;
@end
