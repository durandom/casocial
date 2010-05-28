//
//  MessageViewController.h
//  Casocial
//
//  Created by Marcel Hild on 07.05.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@interface MessageViewController : UITableViewController <NSFetchedResultsControllerDelegate>  {
	NSFetchedResultsController *fetchedResultsController;	
	UINavigationController *navigationController;
	NSMutableArray *conversations;
	NSMutableDictionary *lookup;
}

@property (nonatomic, readonly) UINavigationController *navigationController;
@property (nonatomic, assign) NSMutableArray *conversations;
@property (nonatomic, assign) NSMutableDictionary *lookup;

- (void)fetchMessages;
- (void)syncFetchedResults;

@end
