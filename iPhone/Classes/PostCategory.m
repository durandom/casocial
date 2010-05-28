//
//  PostCompareByLocation.m
//  Casocial
//
//  Created by Marcel Hild on 18.05.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Post.h"
#import "PostCategory.h"
#import "CasocialAppDelegate.h"


@implementation  Post (PostCategory) 

- (NSComparisonResult)compareByLocation:(Post *)post {
	CLLocation *me = [CasocialAppDelegate sharedAppDelegate].location;
	CLLocationDistance me_to_self = [me getDistanceFrom:self.location];
	CLLocationDistance me_to_post = [me getDistanceFrom:post.location];
	
	//DLog(@"hmm %f", me_to_post);
	if (me_to_self > me_to_post) {
		return NSOrderedDescending;
	} else if (me_to_self < me_to_post) {
		return NSOrderedAscending;
	}
	return NSOrderedSame;
}

- (NSString*)dateString {
	// FIXME: maybe move to AppDelegate for reuse and performance?
	NSTimeInterval since = fabs([self.createdAt timeIntervalSinceNow]);
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[NSLocale currentLocale]];
	//DLog(@"Date for locale %@:", [[dateFormatter locale] localeIdentifier]);
	
	if (since <= 86400.0) { // 1d
		dateFormatter.timeStyle = NSDateFormatterShortStyle;
		dateFormatter.dateStyle = NSDateFormatterNoStyle;
	} else if (since <= 604800.0 ) { // 1w
		[dateFormatter setDateFormat:@"EEE"];
	} else {
		dateFormatter.timeStyle = NSDateFormatterNoStyle;
		dateFormatter.dateStyle = NSDateFormatterShortStyle;			
	}
	NSString *stringDate = [dateFormatter stringFromDate:self.createdAt];
	[dateFormatter release];
	return stringDate;
}

- (NSString*)distanceFromHere {
	//FIXME: localize km and miles

	if ([CasocialAppDelegate sharedAppDelegate].location && self.location) {
		//			CLLocation *a = [CasocialAppDelegate sharedAppDelegate].location;
		//			CLLocation *b = post.location;
		
		CLLocationDistance d = [[CasocialAppDelegate sharedAppDelegate].location getDistanceFrom:self.location];
		NSString *d_text;
		//			DLog(@"%@ %@", a, b);
		//			DLog(@"%0.2f", d);
		
		if (d < 1000) {
			d_text = [NSString stringWithFormat: @"%0.0f m", d];
		} else {
			d_text = [NSString stringWithFormat: @"%0.0f km", (d / 1000)];
		}
		return d_text;			
	} else {
		//FIXME: localize
		return @"n/a";
	}
}

@end
