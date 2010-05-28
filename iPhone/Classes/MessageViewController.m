//
//  MessageViewController.m
//  Casocial
//
//  Created by Marcel Hild on 07.05.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageConversationViewController.h"
#import "CasocialAppDelegate.h"
#import "Post.h"
#import "Message.h"
#import "MessageParser.h"
#import "BrowseCell.h"

@implementation MessageViewController

@synthesize navigationController, conversations, lookup;

- (id)init {
	
	
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        navigationController = [[UINavigationController alloc] initWithRootViewController:self];
        self.title = @"Messages";
        
        UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
                                                                                      target:self 
                                                                                      action:@selector(fetchMessages)];
        self.navigationItem.rightBarButtonItem = reloadButton;
        [reloadButton release];	
		
		// Attach FetchedResultsController
		//NSFetchRequest *request = [[[CasocialAppDelegate sharedAppDelegate] managedObjectModel] fetchRequestTemplateForName:@"messages"];
		NSManagedObjectContext *context = [[CasocialAppDelegate sharedAppDelegate] managedObjectContext];
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		// Configure the request's entity, and optionally its predicate.
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Message" inManagedObjectContext:context];
		[request setEntity:entity];		
		
		// Configure Sort
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[request setSortDescriptors:sortDescriptors];
		[sortDescriptors release];
		
		//NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc]
		fetchedResultsController = [[NSFetchedResultsController alloc]
												  initWithFetchRequest:request
												  managedObjectContext:CasocialAppDelegate.sharedAppDelegate.managedObjectContext
												  sectionNameKeyPath:nil
												  cacheName:@"messages"];
		[request release];
		fetchedResultsController.delegate = self;
		
		// Perform fetch
		NSError *error;
		if (![fetchedResultsController performFetch:&error]) {
			DLog(@"Error in file %s (%i) \n%@", __FILE__, __LINE__, error);
		}

		// Init conversations
		conversations = [[NSMutableArray alloc] initWithCapacity:1];
		lookup = [[NSMutableDictionary alloc] initWithCapacity:1];	
		
		[self syncFetchedResults];
    }
    return self;
}

- (void)dealloc 
{
	[fetchedResultsController release];
    [navigationController release];
	[conversations release];
	[lookup release];
    [super dealloc];
}

#pragma mark -
#pragma mark public methods

- (void)fetchMessages
{
	[[[CasocialAppDelegate sharedAppDelegate] server] fetchMessages];
}

- (void)syncFetchedResults {
	[self.conversations removeAllObjects];
	
	//NSMutableDictionary *lookup = [[NSMutableDictionary alloc] initWithCapacity:[fetchedResultsController.fetchedObjects count]];
	//	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
	//	DLog(@"messages %i", [sectionInfo numberOfObjects]);	

	NSInteger myUserId = [[CasocialAppDelegate sharedAppDelegate] userId];
	NSMutableArray *messages;
	
	//[lookup removeAllObjects];

	for (Message *message in fetchedResultsController.fetchedObjects) {
		//DLog(@"%@", message.createdAt);
		NSNumber *uid = (message.userId.integerValue == myUserId) ? message.inReplyToUserId : message.userId;
		NSArray *key = [NSArray arrayWithObjects:message.post.postId, uid, nil];

		NSNumber *index;
		if (index = [lookup objectForKey:key]) {
			// add message to conversation, at the front, so messages are sorted in reverse
			//[[conversations objectAtIndex:[index integerValue]] addObject:message];
			[[conversations objectAtIndex:[index integerValue]] insertObject:message atIndex:0];
		} else {
			// Not yet at an index, create initial conversation
			DLog(@"new conv %@", key);
			messages = [NSMutableArray arrayWithObjects:message, nil];
			[conversations addObject:messages];
			[lookup setObject:[NSNumber numberWithInteger:[conversations count]-1] forKey:key];
		}
	}
	DLog(@"conversations %i", [conversations count]);
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
	return [conversations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *identifier = @"MessageOverviewCell";
	
	Post *post = (Post *)[[[conversations objectAtIndex:indexPath.row] objectAtIndex:0] post];
	
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
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo indexTitle];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	Post *post = (Post *)[[[conversations objectAtIndex:indexPath.row] objectAtIndex:0] post];
    MessageConversationViewController *controller = [[MessageConversationViewController alloc] init];
    controller.conversations = [conversations objectAtIndex:indexPath.row];
	
	controller.title = post.title;
	// FIXME: userId von anderem poster
	
	//controller.userId = [[controller.conversations objectAtIndex:0] userId];
	//controller.userId =[ [lookup allKeysForObject:[NSNumber numberWithInt:indexPath.row]] objectAtIndex:1];
	controller.lookupKey = [[lookup allKeysForObject:[NSNumber numberWithInt:indexPath.row]] objectAtIndex:0];
	controller.userId = [controller.lookupKey objectAtIndex:1];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
	
}



#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
	
	MessageConversationViewController* conversationsController = (MessageConversationViewController *) [self.navigationController visibleViewController];
	if ( [conversationsController respondsToSelector:@selector(lookupKey)] ) {
		
		//		if ( [conversationsController.lookupKey isEqualToArray:selectedLookupKey] ) {
		
		//conversationsController.conversations = [conversations objectAtIndex:selectedRow];
		//	DLog(@"row %i", [self.tableView indexPathForSelectedRow].row);
		[conversationsController.tableView reloadData];
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[conversationsController.conversations count]-1 inSection:0];
		[conversationsController.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];	
	}
}

- (void)controller:(NSFetchedResultsController *)controller 
   didChangeObject:(id)anObject 
	   atIndexPath:(NSIndexPath *)indexPath 
	 forChangeType:(NSFetchedResultsChangeType)type 
	  newIndexPath:(NSIndexPath *)newIndexPath {

	Message *message = (Message*) anObject;
	NSInteger myUserId = [[CasocialAppDelegate sharedAppDelegate] userId];

	NSNumber *uid = (message.userId.integerValue == myUserId) ? message.inReplyToUserId : message.userId;
	NSArray *key = [NSArray arrayWithObjects:message.post.postId, uid, nil];

	if (type == NSFetchedResultsChangeInsert) {
		//DLog(@"insert");
		NSNumber *index;

		if (index = [lookup objectForKey:key]) {
			DLog(@"insert here %@ %@", key, index);

			[[conversations objectAtIndex:[index integerValue]] addObject:message];
		} else {
			// Not yet at an index, create initial conversation
			NSMutableArray *messages = [NSMutableArray arrayWithObjects:message, nil];
			[conversations addObject:messages];
			[lookup setObject:[NSNumber numberWithInteger:[conversations count]-1] forKey:key];
		}		
	} else if (type == NSFetchedResultsChangeDelete) {
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
	

//    //self.tableView.rowHeight = 76.0;
//	
//    // Unselect the selected row if any
//    // http://forums.macrumors.com/showthread.php?t=577677
//    NSIndexPath* selection = [self.tableView indexPathForSelectedRow];
//    if (selection) {
//        [self.tableView deselectRowAtIndexPath:selection animated:YES];
//    }
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


@end

