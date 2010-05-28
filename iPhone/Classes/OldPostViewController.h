//
//  FirstViewController.h
//  Casocial
//
//  Created by Marcel Hild on 28.03.09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@interface OldPostViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	UINavigationController *navigationController;
	UINavigationController *newPostNavigationController;
	NSFetchedResultsController *fetchedResultsController;
}

@property (nonatomic, readonly) UINavigationController *navigationController;
@property (nonatomic, retain) UINavigationController *newPostNavigationController;

- (void)newPost;

@end
