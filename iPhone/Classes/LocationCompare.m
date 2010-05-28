//
//  LocationCompare.m
//  Casocial
//
//  Created by Marcel Hild on 15.05.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LocationCompare.h"
#import "CasocialAppDelegate.h"


@implementation CLLocation (LocationCompare)

- (NSComparisonResult)compare:(CLLocation *)location {
	CLLocation *me = [CasocialAppDelegate sharedAppDelegate].location;
	CLLocationDistance me_to_self = [me getDistanceFrom:self];
	CLLocationDistance me_to_location = [me getDistanceFrom:location];
	
	//DLog(@"hmm %f", me_to_location);
	if (me_to_self > me_to_location) {
		return NSOrderedDescending;
	} else if (me_to_self < me_to_location) {
		return NSOrderedAscending;
	}
	return NSOrderedSame;
}

@end
