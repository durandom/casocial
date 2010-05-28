//
//

#import "BrowseDetailViewController.h"
#import "Post.h"
#import "CasocialAppDelegate.h"


@implementation BrowseDetailViewController

@synthesize post, postTitle, postBody, replyView;


#pragma mark -
#pragma mark Constructor and destructor

- (id)init 
{
    if (self = [super initWithNibName:nil bundle:nil]) {
	}
    return self;
}

- (void)dealloc 
{	
	replyView.textView.delegate = nil;
	[replyView release];
	[postTitle release], postTitle = nil;
    [postBody release], postBody = nil;
	[post release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Overridden setter

- (void)setPost:(Post *)newPost
{
    if (post != newPost)
    {
//        [post setDelegate:nil];
        [post release];
        post = nil;
        post = [newPost retain];
        
//        if (item != nil)
//        {
//            item.delegate = self;
//        }
    }
}


#pragma mark -
#pragma mark UIViewController overridden methods

- (void)loadView {
	UIScrollView *scrollView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0 , VIEW_WIDTH, VIEW_HEIGHT)];
	self.view = scrollView;
	
	postTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, VIEW_WIDTH, TITLE_HEIGHT)];
	[self.view addSubview:postTitle];
	
	postBody = [[UITextView alloc] initWithFrame:CGRectMake(0.0, TITLE_HEIGHT, VIEW_WIDTH, 0.0)];
	postBody.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
	[self.view addSubview:postBody];

	
	replyView = [[ReplyView alloc] initWithFrame:CGRectMake(0.0, VIEW_HEIGHT - REPLY_VIEW_HEIGHT, VIEW_WIDTH, REPLY_VIEW_HEIGHT)];
	replyView.textView.delegate = self;
	[replyView.button addTarget:self action:@selector(replyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:replyView];
}

- (void)viewDidAppear:(BOOL)animated
{
 
}


- (void)viewDidLoad {
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    // Remove any existing selection.
//    [tableView deselectRowAtIndexPath:selectedIndexPath animated:NO];
//    // Redisplay the data.
//    [tableView reloadData];
	postTitle.text = post.title;
	postBody.text = post.body;
	CGRect frame = postBody.frame;
	frame.size = postBody.contentSize;
	postBody.frame = frame;
	
	[postBody sizeToFit];
	// make the text field not show a keyboard
	//postDetails.userInteractionEnabled = NO;
	
//	[[NSNotificationCenter defaultCenter]  addObserver:self
//											  selector:@selector(keyboardNotification:)
//												  name:UIKeyboardWillShowNotification
//												object:nil];
//	
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	// Dissmiss Keyboard
	if ([self.replyView.textView isFirstResponder]) [self.replyView.textView resignFirstResponder];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
//    [super setEditing:editing animated:animated];
//    [self.navigationItem setHidesBackButton:editing animated:animated];
//    [tableView reloadData];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return NO;
}



- (IBAction)replyButtonPressed:(id)sender
{
	[[[CasocialAppDelegate sharedAppDelegate] server] sendMessage:replyView.textView.text forPost:post inReplyTo:post.userId];
	// Dissmiss Keyboard
	if ([replyView.textView isFirstResponder]) [replyView.textView resignFirstResponder];
}

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
	//[self scrollViewToCenterOfScreen:textView];
	CGRect frame = self.view.frame;
	frame.size.height -= (V_KEYBOARD_HEIGHT - BOTTOM_BAR_HEIGHT);
	self.view.frame = frame;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	CGRect frame = self.view.frame;
	frame.size.height += (V_KEYBOARD_HEIGHT - BOTTOM_BAR_HEIGHT) ;
	self.view.frame = frame;
}

//- (void)scrollViewToCenterOfScreen:(UIView *)theView {
//	CGFloat viewCenterY = theView.center.y;
//	CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
//
//	CGFloat availableHeight = applicationFrame.size.height - keyboardBounds.size.height;	// Remove area covered by keyboard
//
//	CGFloat y = viewCenterY - availableHeight / 2.0;
//	if (y < 0) {
//		y = 0;
//	}
//	scrollView.contentSize = CGSizeMake(applicationFrame.size.width, applicationFrame.size.height + keyboardBounds.size.height);
//	[scrollView setContentOffset:CGPointMake(0, y) animated:YES];
//}

//- (void)keyboardNotification:(NSNotification*)notification {
//	NSDictionary *userInfo = [notification userInfo];
//	NSValue *keyboardBoundsValue = [userInfo objectForKey:UIKeyboardBoundsUserInfoKey];
//	[keyboardBoundsValue getValue:&keyboardBounds];
//}

//#pragma mark -
//#pragma mark <UITableViewDelegate, UITableViewDataSource> Methods
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
//    // 3 sections, one for each property
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
//    // Only one row for each section
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
//    if (cell == nil) {
//        // Create a new cell. CGRectZero allows the cell to determine the appropriate size.
//        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"MyIdentifier"] autorelease];
//    }
//    switch (indexPath.section) {
//        case 0: cell.text = post.title; break;
////        case 1: cell.text = [dateFormatter stringFromDate:book.copyright]; break;
////        case 2: cell.text = book.author; break;
//    }
//    return cell;
//}
//
//- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
//    // Return the displayed title for the specified section.
//    switch (section) {
//        case 0: return @"Title";
////        case 1: return @"Copyright";
////        case 2: return @"Author";
//    }
//    return nil;
//}
//
//- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Only allow selection if editing.
//    return (self.editing) ? indexPath : nil;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
// //   EditingViewController *controller = [MasterViewController editingViewController];
////    
////    controller.editedObject = book;
////    switch (indexPath.section) {
////        case 0: {
////            controller.textValue = book.title;
////            controller.editedFieldKey = @"title";
////            controller.dateEditing = NO;
////        } break;
////        case 1: {
////            controller.dateValue = book.copyright;
////            controller.editedFieldKey = @"copyright";
////            controller.dateEditing = YES;
////        } break;
////        case 2: {
////            controller.textValue = book.author;
////            controller.editedFieldKey = @"author";
////            controller.dateEditing = NO;
////        } break;
////    }
////    self.selectedIndexPath = indexPath;
////    [self.navigationController pushViewController:controller animated:YES];
//}
//
//- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
//    // Show the disclosure indicator if editing.
//    return (self.editing) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
//}
//

@end
