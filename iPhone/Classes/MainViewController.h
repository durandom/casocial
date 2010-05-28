//
//  MainViewController.h
//  Casocial
//
//  Created by Marcel Hild on 29.05.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@class Post, Message, DetailViewController, PostNewViewController;

@interface MainViewController : UITableViewController  <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;	
	UINavigationController *navigationController;
	DetailViewController *detailController;
	PostNewViewController *postNewController;
	NSMutableArray *posts;
	NSMutableSet *postIds;
	// Stored Data
	NSMutableDictionary *unreadMessages;
}

@property (nonatomic, readonly) UINavigationController *navigationController;
@property (nonatomic, retain) NSMutableArray *posts;
@property (nonatomic, retain) NSMutableSet *postIds;
@property (nonatomic, retain) DetailViewController *detailController;
@property (nonatomic, retain) PostNewViewController *postNewController;
@property (nonatomic, retain) NSMutableDictionary *unreadMessages;


- (void)reloadPosts;
- (void)refreshPostsForDefaultDistance;
- (void)reorderPostsToCurrentLocation;
- (NSUInteger)addPost:(Post*)newPost;
- (void)newPost;
- (void)showAbout;
- (void)setMessageUnread:(Message*)message;


@end
