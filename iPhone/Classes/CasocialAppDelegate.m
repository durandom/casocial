//
//  CasocialAppDelegate.m
//  Casocial
//
//  Created by Marcel Hild on 08.04.09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "CasocialAppDelegate.h"
#import "MainViewController.h"
#import "Post.h"

NSString *kRestoreLocationLongitudeKey = @"lon";	// preference key to obtain our restore location
NSString *kRestoreLocationLatitudeKey = @"lat";	// preference key to obtain our restore location
NSString *kRestoreUserIdKey = @"uid";	// preference key to obtain our restore location
NSString *kRestoreUnreadMessages = @"urm";	// preference key to obtain our restore location

@implementation CasocialAppDelegate

@synthesize window, mainViewController, downloadQueue, location, locationManager, server, userId;

+ (CasocialAppDelegate *)sharedAppDelegate {
    return (CasocialAppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	downloadQueue = [[NSOperationQueue alloc] init];
    
	unreadMessages = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:kRestoreUnreadMessages]];
	// Remove old posts
	[self deleteOldPosts];

	
	// Start LocationService
	// FIXME: only create locationManager on demand
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = [CasocialAppDelegate sharedAppDelegate];
	locationManager.distanceFilter = 100; // 100 meters
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;

	// Check to see if the user has disabled location services all together
    // In that case, we just print a message and disable the "Start" button
    if ( ! locationManager.locationServicesEnabled ) {
		// FIXME: show a message
		//  [self addTextToLog:NSLocalizedString(@"NoLocationServices", @"User disabled location services")];
		//  startStopButton.enabled = NO;
    } else {
		[locationManager startUpdatingLocation];
	}
	
	// load the stored preference of the user's last location from a previous launch
	self.userId = [[NSUserDefaults standardUserDefaults] integerForKey:kRestoreUserIdKey];
	//	if (self.userId > 0) {
	//		CLLocationDegrees longitude = [[NSUserDefaults standardUserDefaults] doubleForKey:kRestoreLocationLongitudeKey];
	//		CLLocationDegrees latitude = [[NSUserDefaults standardUserDefaults] doubleForKey:kRestoreLocationLatitudeKey];
	//		self.location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
	//		DLog(@"restored %f %f %@", longitude, latitude, location);
	//	}
	location = nil;
	
	// Create Server
	self.server = [[CheckServer alloc] init];
	
	mainViewController = [[MainViewController alloc] init];
	mainViewController.unreadMessages = unreadMessages;
	//	DLog(@"startup UnreadMessages %@", unreadMessages);

	// Now show it
	[window addSubview:mainViewController.navigationController.view];
	
	// Fetch userId, in case we dont know it yet
	if (! self.userId) {
		[self.server fetchUserId];
	}
	
	// Also fetch new messages, posts are fetched when we have a location
	[self.server fetchAllNewMessages];
	
	// Add the tab bar controller's current view as a subview of the window
    [window makeKeyAndVisible];
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
//	[[NSUserDefaults standardUserDefaults] setDouble:location.coordinate.latitude forKey:kRestoreLocationLatitudeKey];
//	[[NSUserDefaults standardUserDefaults] setDouble:location.coordinate.longitude forKey:kRestoreLocationLongitudeKey];
	[[NSUserDefaults standardUserDefaults] setInteger:userId forKey:kRestoreUserIdKey];
	[[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:mainViewController.unreadMessages] forKey:kRestoreUnreadMessages];

//	DLog(@"%@", self.location);

	
    NSError *error;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Handle error
			DLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
        } 
    }
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Casocial.sqlite"]];
	
	NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        // Handle error
    }    
	
    return persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Maintanance Stuff
-(void) deleteOldPosts {
	NSDictionary *var = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate dateWithTimeIntervalSinceNow:MAX_POST_AGE], @"DATE", nil];
	NSFetchRequest *request = [self.managedObjectModel fetchRequestFromTemplateWithName:@"postsOlderThan" 
															   substitutionVariables:var];
	
	NSError *error;
	NSArray *posts = [self.managedObjectContext executeFetchRequest:request error:&error];
	if ([posts count] > 0) {
		for (Post* post in posts) {
			[self.managedObjectContext deleteObject:post];
		}

		if (![self.managedObjectContext save:&error]) {
			// Handle the error.
			DLog(@"Error in file %s (%i) \n%@", __FILE__, __LINE__, error);
		}
	}
}



#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}



//#pragma mark -
//#pragma mark LoadingView 
//
//- (void)showLoadingView
//{
//    if (loadingView == nil)
//    {
//        loadingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
//        loadingView.opaque = NO;
//        loadingView.backgroundColor = [UIColor darkGrayColor];
//        loadingView.alpha = 0.5;
//		
//        UIActivityIndicatorView *spinningWheel = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(142.0, 222.0, 37.0, 37.0)];
//        [spinningWheel startAnimating];
//        spinningWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
//        [loadingView addSubview:spinningWheel];
//        [spinningWheel release];
//    }
//    
//    [window addSubview:loadingView];
//}
//
//- (void)hideLoadingView
//{
//    [loadingView removeFromSuperview];
//}
//

#pragma mark -
#pragma mark CLLocation Delegate

// Called when the location is updated
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	// FIXME: nur reoorder wenn distanz größer als. Z.zt. noch bug beim ersten laden der Posts - sind nicht ordered
	if (newLocation && location && [newLocation getDistanceFrom:location] > 0) {
		[mainViewController reorderPostsToCurrentLocation];
		[mainViewController.tableView reloadData];
	}
	
	if (location == nil) {
		// Its the first location update
		self.location = newLocation;
		[mainViewController reorderPostsToCurrentLocation];
		[mainViewController.tableView reloadData];
		[mainViewController refreshPostsForDefaultDistance];
	} else {
		self.location = newLocation;
	}


	// FIXME: nur stop nachdem gewisse genauigkeit erreicht wurd
	//[locationManager stopUpdatingLocation];

	// reorder Posts array
	//[self.mainViewController reorderPostsToCurrentLocation];

	// refresh browseview if its the current view
	//DLog(@"%i", self.tabBarController.selectedIndex );
	//DLog(@"%i", selectedNavController.visibleViewController.view.tag );
	
	/*
	UINavigationController* selectedNavController = (UINavigationController *) self.tabBarController.selectedViewController;
	if (selectedNavController.visibleViewController.view.tag == TAG_TB_BROWSE_VIEW) {
		[[(BrowseViewController *) selectedNavController.visibleViewController tableView] reloadData];
	}
	 */

}

// Called when there is an error getting the location
- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	//NSMutableString *errorString = [[[NSMutableString alloc] init] autorelease];
	
	if ([error domain] == kCLErrorDomain) {
		
		// FIXME We handle CoreLocation-related errors here
		
		switch ([error code]) {
				// This error code is usually returned whenever user taps "Don't Allow" in response to
				// being told your app wants to access the current location. Once this happens, you cannot
				// attempt to get the location again until the app has quit and relaunched.
				//
				// "Don't Allow" on two successive app launches is the same as saying "never allow". The user
				// can reset this for all apps by going to Settings > General > Reset > Reset Location Warnings.
				//
			case kCLErrorDenied:
				//[errorString appendFormat:@"%@\n", NSLocalizedString(@"LocationDenied", nil)];
				break;
				
				// This error code is usually returned whenever the device has no data or WiFi connectivity,
				// or when the location cannot be determined for some other reason.
				//
				// CoreLocation will keep trying, so you can keep waiting, or prompt the user.
				//
			case kCLErrorLocationUnknown:
				//[errorString appendFormat:@"%@\n", NSLocalizedString(@"LocationUnknown", nil)];
				break;
				
				// We shouldn't ever get an unknown error code, but just in case...
				//
			default:
				//[errorString appendFormat:@"%@ %d\n", NSLocalizedString(@"GenericLocationError", nil), [error code]];
				break;
		}
	} else {
		// We handle all non-CoreLocation errors here
		// (we depend on localizedDescription for localization)
//		[errorString appendFormat:@"Error domain: \"%@\"  Error code: %d\n", [error domain], [error code]];
//		[errorString appendFormat:@"Description: \"%@\"\n", [error localizedDescription]];
	}
	
	
}


#pragma mark -
#pragma mark Memory management


- (void)dealloc {
	[unreadMessages release];
	[locationManager release];
	[mainViewController release];	
	[downloadQueue release];
    [window release];
	[server release];
    [super dealloc];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
 //   [[ImageCache sharedImageCache] removeAllImagesInMemory];
}


@end
