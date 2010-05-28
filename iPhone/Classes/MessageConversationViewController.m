//
//  MessageConversationViewController.m
//  Casocial
//
//  Created by Marcel Hild on 18.05.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Message.h"
#import "MessageCell.h"
#import "ReplyView.h"
#import "CasocialAppDelegate.h"
#import "MessageConversationViewController.h"


@implementation MessageConversationViewController

@synthesize conversations, cells, userId, lookupKey, replyView, tableView;

- (id)init {
	if (self = [[MessageConversationViewController alloc] initWithNibName:nil bundle:nil]) {
		//	self.conversations = [[NSArray alloc] init];
//		CGRect frame = [self.tableView.superview frame];
//		frame.size = CGSizeMake(200.0, 100.0);
//		self.tableView.superview.frame = frame;
		
		UITableView *newTableView =
		[[[UITableView alloc]
		  initWithFrame:CGRectMake(0.0, 0.0, VIEW_WIDTH, VIEW_HEIGHT - REPLY_VIEW_HEIGHT)
		  style:UITableViewStylePlain]
		 autorelease];
		newTableView.rowHeight = 90;
		newTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		
		self.view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, VIEW_WIDTH, VIEW_HEIGHT)];
		//self.view.backgroundColor = [UIColor blueColor];
		
		self.tableView = newTableView;			
		[self.view addSubview:newTableView];
		//[newTableView release];

		replyView = [[ReplyView alloc] initWithFrame:CGRectMake(0.0, VIEW_HEIGHT - REPLY_VIEW_HEIGHT, VIEW_WIDTH, REPLY_VIEW_HEIGHT)];
		replyView.textView.delegate = self;
		[replyView.button addTarget:self action:@selector(replyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

		[self.view addSubview:replyView];
		//[replyView release];
		
		cells = [[NSMutableDictionary alloc] initWithCapacity:1];
	}
	return self;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	[lookupKey release];
	[userId release];
	
	replyView.textView.delegate = nil;
	[replyView release];
	[tableView release];
	[conversations release];
	[cells release];
    [super dealloc];
}

//
// setTableView
//
// This method connects to the view property by default.
//
- (void)setTableView:(UITableView *)newTableView
{
	[tableView release];
	tableView = [newTableView retain];
	[tableView setDelegate:self];
	[tableView setDataSource:self];
}

#pragma mark -
#pragma mark UIView methods

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {	
	[super viewWillAppear:animated];
	[tableView reloadData];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[conversations count]-1 inSection:0];
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];	
}

- (void)viewWillDisappear:(BOOL)animated {	
	[super viewWillDisappear:animated];
	if ([self.replyView.textView isFirstResponder]) [self.replyView.textView resignFirstResponder];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.conversations count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"ConversationCell";
	MessageCell *cell = (MessageCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[MessageCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	// Set up the cell...
	Message* message = (Message *)[self.conversations objectAtIndex:indexPath.row];
	NSNumber *uid = [NSNumber numberWithInteger:[[CasocialAppDelegate sharedAppDelegate] userId]];
	//DLog(@"%@ %@", uid, message.userId);
	[cell setMessage:message type:[uid compare:message.userId] ? BUBBLE_TYPE_GREEN : BUBBLE_TYPE_GRAY];
	
	return cell;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	Message* message = (Message *)[self.conversations objectAtIndex:indexPath.row];
	return [MessageCell calcCellHeight:message];
}



//- (void)prepCellAtIndexPath:(NSIndexPath *)indexPath {	
//	static NSString *CellIdentifier = @"ConversationCell";
//	
//	DLog(@"prep Cell at %i", indexPath.row);
//	if (! [cells objectForKey:indexPath]) {
//		DLog(@"Cell not in cache");
//
//		MessageCell *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//		if (cell == nil) {
//			DLog(@"alloc Cell");
//			cell = [[[MessageCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
//		}
//	
//		// Set up the cell...
//		Message* message = (Message *)[self.conversations objectAtIndex:indexPath.row];
//		NSNumber *uid = [NSNumber numberWithInteger:[[CasocialAppDelegate sharedAppDelegate] userId]];
//		[cell setMessage:message type:[uid compare:message.userId] ? BUBBLE_TYPE_GREEN : BUBBLE_TYPE_GRAY];
//		
//		DLog(@"%f", cell.frame.size.height);
//		[cell.cellView sizeToFit];
//		[cell sizeToFit];
//		DLog(@"%f", cell.frame.size.height);
//		DLog(@"%f", cell.cellView.frame.size.height);
//
//	//	cell.message = (Message *)[self.conversations objectAtIndex:indexPath.row];
//
//		[cells setObject:cell forKey:indexPath];
//	}
//}



- (void)textViewDidBeginEditing:(UITextView *)textView {
	//	[UIView beginAnimations:nil context:NULL];
	//    [UIView setAnimationBeginsFromCurrentState:YES];
	//    [UIView setAnimationDuration:0.3];
	
	/*
	frame = self.tableView.frame;
	frame.size.height -= V_KEYBOARD_HEIGHT;
	self.tableView.frame = frame;

	frame = self.replyEditor.frame;
	frame.origin.y -= V_KEYBOARD_HEIGHT;
	self.replyEditor.frame = frame;
	
	frame = self.replyButton.frame;
	frame.origin.y -= V_KEYBOARD_HEIGHT;
	self.replyButton.frame = frame;
	*/
	
//	
//	= CGRectMake(0.0, VIEW_HEIGHT - EDITOR_HEIGHT - V_KEYBOARD_HEIGHT, VIEW_WIDTH , EDITOR_HEIGHT);
	
	CGRect frame = self.view.frame;
	frame.size.height -= (V_KEYBOARD_HEIGHT - BOTTOM_BAR_HEIGHT);
	self.view.frame = frame;
	
	
	// Also move tableView content up
	if ( self.tableView.contentSize.height > self.view.frame.size.height + REPLY_VIEW_HEIGHT ) {
		CGPoint point = self.tableView.contentOffset;
		if (self.tableView.contentSize.height > VIEW_HEIGHT - REPLY_VIEW_HEIGHT ) {
			// content is larger than whole view, move up the whole keyboard + reply view
			//point.y += V_KEYBOARD_HEIGHT + EDITOR_HEIGHT - BOTTOM_BAR_HEIGHT;
			point.y += VIEW_HEIGHT - self.view.frame.size.height;
		} else {
			// only move up that bit, that was below 
			point.y += self.tableView.contentSize.height - self.view.frame.size.height;
		}
		self.tableView.contentOffset = point;
	}
	
	//	[UIView commitAnimations];
	
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	CGRect frame = self.view.frame;
	frame.size.height += (V_KEYBOARD_HEIGHT - BOTTOM_BAR_HEIGHT) ;
	self.view.frame = frame;
}


//- (BOOL)textEditor:(TTTextEditor*)textEditor shouldResizeBy:(CGFloat)height {
//	DLog(@"%f", height);
//	return YES;
//}

- (void)replyButtonPressed:(id)sender
{
	Post *post = [[self.conversations objectAtIndex:0] post];
	[[[CasocialAppDelegate sharedAppDelegate] server] sendMessage:self.replyView.textView.text forPost:post inReplyTo:userId];
	// Dissmiss Keyboard
	//[self.replyEditor.textView resignFirstResponder];
	if ([self.replyView.textView isFirstResponder]) [self.replyView.textView resignFirstResponder];
}


@end

