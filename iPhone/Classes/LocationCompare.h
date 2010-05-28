//
//  LocationCompare.h
//  Casocial
//
//  Created by Marcel Hild on 15.05.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface CLLocation (LocationCompare) 
	- (NSComparisonResult)compare:(CLLocation *)location;
@end
