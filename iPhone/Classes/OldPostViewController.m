//
//  FirstViewController.m
//  Casocial
//
//  Created by Marcel Hild on 28.03.09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "OldPostViewController.h"
#import "PostNewViewController.h"
#import "Post.h"
#import "BrowseCell.h"
#import "CasocialAppDelegate.h"



@implementation OldPostViewController

@synthesize navigationController, newPostNavigationController;

- (id)init
{
    if (self = [super initWithStyle:UITableViewStylePlain]) 
    {
        navigationController = [[UINavigationController alloc] initWithRootViewController:self];
        self.title = @"Post";
        
		// New Post Button
        UIBarButtonItem *newPostButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose 
                                                                                      target:self action:@selector(newPost)];
        self.navigationItem.rightBarButtonItem = newPostButton;
        [newPostButton release];
		
		// Attach FetchedResultsController
//      NSDictionary *var = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:[[CasocialAppDelegate sharedAppDelegate] userId]], @"USERID", nil];
//		NSDictionary *var = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:19], @"USERID", nil];
//		NSFetchRequest *request = [[[CasocialAppDelegate sharedAppDelegate] managedObjectModel] fetchRequestFromTemplateWithName:@"postsForUserId" 

		
		NSManagedObjectContext *context = [[CasocialAppDelegate sharedAppDelegate] managedObjectContext];
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		// Configure the request's entity, and optionally its predicate.
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:context];
		[request setEntity:entity];		
		NSPredicate *predicate = [NSPredicate predicateWithFormat:
								  @"(userId = %i)", [[CasocialAppDelegate sharedAppDelegate] userId]];
		[request setPredicate:predicate];
		

//		NSFetchRequest *request = [[[CasocialAppDelegate sharedAppDelegate] managedObjectModel] fetchRequestTemplateForName:@"posts"];

		
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
									cacheName:@"myPosts"];
		[request release];
		fetchedResultsController.delegate = self;		
    }
    return self;
}


- (void)dealloc 
{
    [navigationController release];
	[newPostNavigationController release];
	[fetchedResultsController release];
    [super dealloc];
}



#pragma mark -
#pragma mark Public methods

- (void)newPost {
	PostNewViewController *controller = [[PostNewViewController alloc] init];
    controller.post = [[[Post alloc] init] autorelease];
    [self.navigationController presentModalViewController:controller.navigationController animated:YES];
    [controller setEditing:YES animated:NO];	
}

#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}



#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *identifier = @"PostCell";
	
	Post *post = (Post *)[fetchedResultsController objectAtIndexPath:indexPath];
	
	// Dequeue or create a new cell
    BrowseCell *cell = (BrowseCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) 
    {
        CGRect rect = CGRectMake(0.0, 0.0, 320.0, 75.0);
        cell = [[[BrowseCell alloc] initWithFrame:rect reuseIdentifier:identifier] autorelease];
        //cell.delegate = self;
    }
    cell.post = post;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	//    BrowseCell *cell = (BrowseCell *)[self.tableView cellForRowAtIndexPath:indexPath];
	//    [cell toggleImage];
	//	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//	Post *post = (Post *)[fetchedResultsController objectAtIndexPath:indexPath];
//    BrowseDetailViewController *controller = [[BrowseDetailViewController alloc] init];
//    controller.post = post;
//    controller.postTitle.text = post.title;
//    [self.navigationController pushViewController:controller animated:YES];
//    [controller release];    
	
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

#pragma mark -
#pragma mark UIViewController methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated 
{
    self.tableView.rowHeight = 76.0;
	
    // Unselect the selected row if any
    // http://forums.macrumors.com/showthread.php?t=577677
    NSIndexPath* selection = [self.tableView indexPathForSelectedRow];
    if (selection)
    {
        [self.tableView deselectRowAtIndexPath:selection animated:YES];
    }
	
	// Perform fetch
	NSError *error;
	if (![fetchedResultsController performFetch:&error]) {
		DLog(@"Error in file %s (%i) \n%@", __FILE__, __LINE__, error);
	}
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

@end
