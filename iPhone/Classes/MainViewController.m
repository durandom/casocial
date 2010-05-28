//
//  MainViewController.m
//  Casocial
//
//  Created by Marcel Hild on 29.05.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "CasocialAppDelegate.h"
#import "Post.h"
#import "PostCategory.h"
#import "Message.h"
#import "BrowseCell.h"
#import "PostNewViewController.h"
#import "DetailViewController.h"
#import "AboutViewController.h"


@implementation MainViewController

@synthesize navigationController, posts, postIds, detailController, unreadMessages, postNewController;

#pragma mark -
#pragma mark LifeCycle

- (id)init {
    if (self = [super initWithStyle:UITableViewStylePlain]) 
    {
        self.title = @"Browse";		
		self.view.tag = TAG_TB_BROWSE_VIEW;
		
		// Init Controllers
		// FIXME: make these lazy loading
		detailController = [[DetailViewController alloc] init];
		postNewController = [[PostNewViewController alloc] init];
        navigationController = [[UINavigationController alloc] initWithRootViewController:self];
        //        self.navigationItem.rightBarButtonItem = reloadButton;

		// Buttons
        UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
                                                                                      target:self 
                                                                                      action:@selector(reloadPosts)];
		// flex item used to separate the left groups items and right grouped items
		// FIXME: display loading and last sync info here, like in mail app
		UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																				  target:nil
																				  action:nil];
		
		UIBarButtonItem *newPostButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose 
																					   target:self 
																					   action:@selector(newPost)];
		
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"about"
																				 style:UIBarButtonItemStylePlain 
																				target:self 
																				action:@selector(showAbout)];
		
//		UIView* container = [[UIView alloc] init];
//		UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
//		[infoButton addTarget:self action:@selector(refreshPostsForDefaultDistance) forControlEvents:UIControlEventTouchUpInside];
//		[container addSubview:infoButton];
//		UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:container];
//		self.navigationItem.leftBarButtonItem = item;
		
//		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"other.png"]   //[[infoButton imageView] image]
//																				  style:UIBarButtonItemStylePlain
//																				 target:self 
//																				 action:@selector(cancel:)] autorelease];

//		CGRect frame = infoButton.frame;
//		frame.origin.x = 280.0;
//		frame.origin.y = 365.0;
//		infoButton.frame = frame;
//		[self.view.superview addSubview:infoButton];
		
		// ToolBar
		[navigationController setToolbarHidden:NO];
		self.toolbarItems = [NSArray arrayWithObjects:reloadButton, flexItem, newPostButton, nil];
		[newPostButton release];
        [reloadButton release];
		
		
		// Attach FetchedResultsController
		NSManagedObjectContext *context = [[CasocialAppDelegate sharedAppDelegate] managedObjectContext];
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		// Configure the request's entity, and optionally its predicate.
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:context];
		[request setEntity:entity];		
		// Configure Sort
		//NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"location" ascending:YES selector:@selector(compare:)];
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"postId" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[request setSortDescriptors:sortDescriptors];
		[sortDescriptors release];
		
		fetchedResultsController = [[NSFetchedResultsController alloc]
									initWithFetchRequest:request
									managedObjectContext:context
									sectionNameKeyPath:nil
									cacheName:@"posts"];
		[request release];
		fetchedResultsController.delegate = self;
		
		NSError *error;
		if (![fetchedResultsController performFetch:&error]) {
			DLog(@"Error in file %s (%i) \n%@", __FILE__, __LINE__, error);
		}
		posts = [[NSMutableArray alloc] initWithArray:[fetchedResultsController.fetchedObjects sortedArrayUsingSelector:@selector(compareByLocation:)]];
		postIds = [[NSMutableSet alloc] initWithCapacity:1];
		for (Post* p in posts) {
			[postIds addObject:p.postId];
		}
    }
	
    return self;
	
}
		
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

//- (void)viewDidLoad {
//}

- (void)dealloc 
{
	[unreadMessages release];
	[posts release];
	[fetchedResultsController release];
    [navigationController release];
	[detailController release];
	[postNewController release];
    [super dealloc];
}

#pragma mark -
#pragma mark Public methods

- (void)reorderPostsToCurrentLocation {
	[posts sortUsingSelector:@selector(compareByLocation:)];
}

- (NSUInteger) addPost:(Post*)newPost {
	NSUInteger i;
	NSUInteger c = [posts count];
	for (i = 0; i < c; i += 1) {
		Post* post = [posts objectAtIndex:i];
		if ([post compareByLocation:newPost] == NSOrderedDescending) {
			[posts insertObject:newPost atIndex:i];
			break;
		}
	}
	if (i == c) {
		[posts addObject:newPost];
	}
	[postIds addObject:newPost.postId];
	return i;
}

- (void)setMessageUnread:(Message*)message {
	// Wenn die msg von mir ist, dann return, die hab ich schon gelesen
	if ([message.userId integerValue] == [[CasocialAppDelegate sharedAppDelegate] userId]) {
		return;
	}
	DLog(@"set Unread %@", message.messageId);
	
	NSMutableArray *message_ids;		
	// Falls der Post schon existiert, dann füge die message hinzu	
	if (message_ids = [unreadMessages objectForKey:[message.post.postId stringValue]]) {
//		[message_ids addObject:[message.messageId stringValue]];
		[message_ids addObject:[NSNumber numberWithInt:[message.messageId integerValue]]];
	} else {
//		message_ids = [[NSMutableArray alloc] initWithObjects:[message.messageId stringValue], nil];
		message_ids = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:[message.messageId integerValue]], nil];
		[unreadMessages setObject:message_ids forKey:[message.post.postId stringValue]];
	}
	
//	if (message_ids = [unreadMessages objectForKey:message.post.postId]) {
//		[message_ids addObject:[NSNumber numberWithInt:[message.messageId integerValue]]];
//	} else {
//		message_ids = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:[message.messageId integerValue]], nil];
//		[unreadMessages setObject:message_ids forKey:[NSNumber numberWithInt:[message.post.postId integerValue]]];
//	}

}


#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// return [[fetchedResultsController sections] count];
	return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	//    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	//    return [sectionInfo numberOfObjects];
//	if ([posts count] >= MAX_POSTS) {
//		return [posts count];
//	}
	return [posts count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (indexPath.row == [posts count]) {
		static NSString *moreIdentifier = @"MoreCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:moreIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moreIdentifier] autorelease];
		}
		// FIXME  localize
		if ([posts count] > MAX_POSTS) {
			cell.textLabel.text = @"cannot fetch more Posts";
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		} else {
			cell.textLabel.text = @"more Posts";
		}
			
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		return cell;
	} else {
		static NSString *identifier = @"PostCell";
		
		//Post *post = (Post *)[fetchedResultsController objectAtIndexPath:indexPath];
		Post *post = (Post *)[posts objectAtIndex:indexPath.row];
		
		// Dequeue or create a new cell
		BrowseCell *cell = (BrowseCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
		if (cell == nil) 
		{
			//        CGRect rect = CGRectMake(0.0, 0.0, 320.0, 75.0);
			//        cell = [[[BrowseCell alloc] initWithFrame:rect reuseIdentifier:identifier] autorelease];
			cell = [[[BrowseCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
			//cell.delegate = self;
		}
		cell.post = post;
		
		DLog(@"unreadMessages %@", unreadMessages);
		if ([[unreadMessages valueForKey:[post.postId stringValue]] count] > 0) {
			DLog(@"count %i", [[unreadMessages valueForKey:[post.postId stringValue]] count] );
			cell.badge.hidden = NO;
			// FIXME: adjust badge with according to unread count, if unread count is > 9
			[cell.badge setTitle:[NSString stringWithFormat:@"%i", [[unreadMessages valueForKey:[post.postId stringValue]] count]] forState:UIControlStateNormal];
		} else {
			cell.badge.hidden = YES;
		}
		return cell;
	}
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    PostCell *postCell = (PostCell *)cell;
//    [postCell loadImage];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	if (indexPath.row == [posts count]) {
		// FIXME dont allow clicking 'fetch more' twice, this will result in double posts...
		CLLocation* myself = [ [CasocialAppDelegate sharedAppDelegate] location];
		if (myself && [posts count] <= MAX_POSTS) {
			// Dont fetch more than max posts
			if ([[[CasocialAppDelegate sharedAppDelegate] server] checkNetwork]) {
		        [[[CasocialAppDelegate sharedAppDelegate] server] fetchPosts];
			}
		}
		// Unselect row
		NSIndexPath* selection = [self.tableView indexPathForSelectedRow];
		if (selection)	{
			[self.tableView deselectRowAtIndexPath:selection animated:YES];
		}		
		return;
	}

	//    BrowseCell *cell = (BrowseCell *)[self.tableView cellForRowAtIndexPath:indexPath];
	//    [cell toggleImage];
	//	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	//	Post *post = (Post *)[fetchedResultsController objectAtIndexPath:indexPath];
	Post *post = (Post *)[posts objectAtIndex:indexPath.row];	
    detailController.post = post;
	
	NSMutableArray *unread_ids;
	if ([unread_ids = [unreadMessages valueForKey:[post.postId stringValue]] count]) {
		detailController.unread_ids = unread_ids;
	} else {
		detailController.unread_ids = nil;
	}

//    controller.postTitle.text = post.title;
    [self.navigationController pushViewController:detailController animated:YES];
	
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
//    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
//    return [sectionInfo indexTitle];
//}
//
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return [fetchedResultsController sectionIndexTitles];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    return [fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
//}

#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate

//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
//	[self syncFetchedResults];
//  [self.tableView reloadData];
//}

- (void)controller:(NSFetchedResultsController *)controller 
   didChangeObject:(id)anObject 
	   atIndexPath:(NSIndexPath *)indexPath 
	 forChangeType:(NSFetchedResultsChangeType)type 
	  newIndexPath:(NSIndexPath *)newIndexPath {

	
	UITableView *tableView = self.tableView;
	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
			DLog(@"change %i (insert)", type);
			NSInteger index = [self addPost:anObject];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]]
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
			DLog(@"change %i (delete)", type);
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//							 withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeUpdate:
			DLog(@"change %i (update)", type);
			// Update unreadMessages
			
			
			// Check in detail controller
			if (detailController.post == anObject) {
				[detailController checkForNewMessages];
			}
			NSInteger row = [posts indexOfObject:anObject];
			[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] 
							 withRowAnimation: UITableViewRowAnimationRight];
//            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
//					atIndexPath:indexPath];
            break;
			
//        case NSFetchedResultsChangeMove:
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//							 withRowAnimation:UITableViewRowAnimationFade];
//            [tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section]
//					 withRowAnimation:UITableViewRowAnimationFade];
//            break;
    }
}	

#pragma mark -
#pragma mark UIViewController methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated 
{
	// 8 (Abstand) + 32 (Bild) + 8 (Abstand) + 12 (Distance) + 8 (Abstand)
	self.tableView.rowHeight = 68.0;		
}

#pragma mark -
#pragma mark Actions

- (void)refreshPostsForDefaultDistance {
	if ([[[CasocialAppDelegate sharedAppDelegate] server] checkNetwork] &&
		[ [CasocialAppDelegate sharedAppDelegate] location]) {
		[[[CasocialAppDelegate sharedAppDelegate] server] fetchPostsWithin:FETCH_DISTANCE];
	}
}

- (void)reloadPosts
{
	[self refreshPostsForDefaultDistance];
	[[[CasocialAppDelegate sharedAppDelegate] server] fetchAllNewMessages];

	// Get distance from last post to myself
	//	CLLocation* myself = [ [CasocialAppDelegate sharedAppDelegate] location];
	//	CLLocation* lastPost =[ [posts lastObject] location];
	//	if (myself && lastPost) {
	//		CLLocationDistance distance = [myself getDistanceFrom:lastPost];
	//		[[[CasocialAppDelegate sharedAppDelegate] server] fetchPostsWithin:distance];
	//	}
	
	//	[[[CasocialAppDelegate sharedAppDelegate] locationManager] startUpdatingLocation];
	
	// set location to random location
	//	CLLocation *newRandomLocation = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)12.0 longitude:199];
	//	[CasocialAppDelegate sharedAppDelegate].location = newRandomLocation;
	//	[newRandomLocation release];
	//	[self reorderPostsToCurrentLocation];
	//	[self.tableView reloadData];
}

- (void)newPost
{
	//    controller.post = [[[Post alloc] init] autorelease];
	//    if (newPostNavigationController == nil) {
	//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
	//        self.newPostNavigationController = navController;
	//        [navController release];
	//    }
	[self.navigationController presentModalViewController:postNewController.navigationController animated:YES];
	//	[self.navigationController presentModalViewController:controller  animated:YES];
	//    [controller setEditing:YES animated:NO];
}

-(void)showAbout {
	AboutViewController *controller = [[AboutViewController alloc] init];
	//modalTransitionStyle
	[self.navigationController presentModalViewController:controller.navigationController animated:YES];
}

@end
