//
//  CasocialAppDelegate.h
//  Casocial
//
//  Created by Marcel Hild on 08.04.09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "MainViewController.h"
#import "CheckServer.h"

@interface CasocialAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate> {
    UIWindow *window;
	UIView *loadingView;	

	// Controllers
	MainViewController *mainViewController;

	// Holds the last location
	CLLocationManager *locationManager;
	CLLocation *location;
	
	NSMutableDictionary *unreadMessages;

	// CoreData 
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
	// Communication with Server
	NSOperationQueue *downloadQueue;
	CheckServer *server;
	NSInteger userId;	
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;
@property (nonatomic, retain) NSOperationQueue *downloadQueue;
@property (nonatomic, retain) CheckServer *server;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;
@property (nonatomic, assign) NSInteger userId;

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error;

-(void) deleteOldPosts;

+ (CasocialAppDelegate *)sharedAppDelegate;

@end

