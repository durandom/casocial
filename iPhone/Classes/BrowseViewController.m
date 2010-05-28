//
//  FirstViewController.m
//  Casocial
//
//  Created by Marcel Hild on 28.03.09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "BrowseViewController.h"
#import "BrowseDetailViewController.h"
#import "PostParser.h"
#import "Post.h"
#import "BrowseCell.h"
#import "CasocialAppDelegate.h"



@implementation BrowseViewController

@synthesize navigationController, posts;

- (id)init
{
    if (self = [super initWithStyle:UITableViewStylePlain]) 
    {
        navigationController = [[UINavigationController alloc] initWithRootViewController:self];
        self.title = @"Browse";
		
		self.view.tag = TAG_TB_BROWSE_VIEW;
        
		// Reload Button
        UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
                                                                                      target:self 
                                                                                      action:@selector(reloadPosts)];
        self.navigationItem.rightBarButtonItem = reloadButton;
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
		[self syncFetchedResults];
    }

    return self;
}

- (void)dealloc 
{
	[posts release];
	[fetchedResultsController release];
    [navigationController release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}



#pragma mark -
#pragma mark Public methods

- (void)reloadPosts
{
	[[[CasocialAppDelegate sharedAppDelegate] server] fetchPosts];

	// set location to random location
//	CLLocation *newRandomLocation = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)12.0 longitude:199];
//	[CasocialAppDelegate sharedAppDelegate].location = newRandomLocation;
//	[newRandomLocation release];
//	[self reorderPostsToCurrentLocation];
//	[self.tableView reloadData];
}

- (void)syncFetchedResults {
	self.posts = [[NSArray alloc] initWithArray:[fetchedResultsController.fetchedObjects sortedArrayUsingSelector:@selector(compareByLocation:)]];
	//self.posts = [[NSArray alloc] initWithArray:fetchedResultsController.fetchedObjects];
}

- (void)reorderPostsToCurrentLocation {
	self.posts = [self.posts sortedArrayUsingSelector:@selector(compareByLocation:)];
}


//#pragma mark -
//#pragma mark FeedDelegate methods
//
//- (void)feed:(Feed *)feed didFindPosts:(NSArray *)newPosts
//{
//    [posts release];
//    posts = [newPosts retain];
//    [self.tableView reloadData];
//    [self loadContentForVisibleCells]; 
//    [[CasocialAppDelegate sharedAppDelegate] hideLoadingView];
//}
//
//- (void)feed:(Feed *)feed didFailWithError:(NSString *)errorMsg
//{
//    [[CasocialAppDelegate sharedAppDelegate] hideLoadingView];
//}
//
//#pragma mark -
//#pragma mark BrowseCellDelegate methods
//
//- (void)postCellAnimationFinished:(BrowseCell *)cell
//{
//}
//
//#pragma mark -
//#pragma mark UIScrollViewDelegate methods
//
//// These methods are adapted from
//// http://idevkit.com/forums/tutorials-code-samples-sdk/2-dynamic-content-loading-uitableview.html
//
//- (void)loadContentForVisibleCells
//{
//    NSArray *cells = [self.tableView visibleCells];
//    [cells retain];
//    for (int i = 0; i < [cells count]; i++) 
//    { 
//        // Go through each cell in the array and call its loadContent method if it responds to it.
//        BrowseCell *postCell = (BrowseCell *)[[cells objectAtIndex: i] retain];
////        [postCell loadImage];
//        [postCell release];
//        postCell = nil;
//    }
//    [cells release];
//}

//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView; 
//{
//    // Method is called when the decelerating comes to a stop.
//    // Pass visible cells to the cell loading function. If possible change 
//    // scrollView to a pointer to your table cell to avoid compiler warnings
//    [self loadContentForVisibleCells]; 
//}
//
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
//{
//    if (!decelerate) 
//    {
//        [self loadContentForVisibleCells]; 
//    }
//}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   // return [[fetchedResultsController sections] count];
	return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	//    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	//    return [sectionInfo numberOfObjects];
	return [posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *identifier = @"browseCell";

	//Post *post = (Post *)[fetchedResultsController objectAtIndexPath:indexPath];
	Post *post = (Post *)[posts objectAtIndex:indexPath.row];
	
	// Dequeue or create a new cell
    BrowseCell *cell = (BrowseCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) 
    {
		//        CGRect rect = CGRectMake(0.0, 0.0, 320.0, 75.0);
		//        cell = [[[BrowseCell alloc] initWithFrame:rect reuseIdentifier:identifier] autorelease];
		cell = [[[BrowseCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
		//cell = [[NSBundle mainBundle] loadNibNamed:@"BrowseCell" owner:self options:nil];

		
        //cell.delegate = self;
    }
    cell.post = post;
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    PostCell *postCell = (PostCell *)cell;
//    [postCell loadImage];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
//    BrowseCell *cell = (BrowseCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//    [cell toggleImage];
//	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//	Post *post = (Post *)[fetchedResultsController objectAtIndexPath:indexPath];
	Post *post = (Post *)[posts objectAtIndex:indexPath.row];

    BrowseDetailViewController *controller = [[BrowseDetailViewController alloc] init];
    controller.post = post;
    controller.postTitle.text = post.title;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];    
	
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
#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self syncFetchedResults];
    [self.tableView reloadData];
}

- (void)controller:(NSFetchedResultsController *)controller 
   didChangeObject:(id)anObject 
	   atIndexPath:(NSIndexPath *)indexPath 
	 forChangeType:(NSFetchedResultsChangeType)type 
	  newIndexPath:(NSIndexPath *)newIndexPath {
	DLog(@"change %i", type);
}	

#pragma mark -
#pragma mark UIViewController methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated 
{
    self.tableView.rowHeight = 140.0;
	
    // Unselect the selected row if any
    // http://forums.macrumors.com/showthread.php?t=577677
    NSIndexPath* selection = [self.tableView indexPathForSelectedRow];
    if (selection)
    {
        [self.tableView deselectRowAtIndexPath:selection animated:YES];
    }
	
	// Perform fetch
//	NSError *error;
//	if (![fetchedResultsController performFetch:&error]) {
//		DLog([error description]);
//	}
//	[self syncFetchedResults];
//	[self.tableView reloadData];
}
@end
