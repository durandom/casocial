//
//  FirstViewController.h
//  Casocial
//
//  Created by Marcel Hild on 28.03.09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@interface BrowseViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	UINavigationController *navigationController;
	NSFetchedResultsController *fetchedResultsController;
	NSArray *posts;
}

@property (nonatomic, readonly) UINavigationController *navigationController;
@property (nonatomic, retain) NSArray *posts;

- (void)reloadPosts;
- (void)syncFetchedResults;
- (void)reorderPostsToCurrentLocation;

@end
