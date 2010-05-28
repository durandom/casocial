//
//  DetailViewController.m
//  Casocial
//
//  Created by Marcel Hild on 15.06.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CasocialAppDelegate.h"
#import "DetailViewController.h"
#import "ReplyViewController.h"
#import "Post.h"
#import "Message.h"
#import "DetailCell.h"
#import "MessageCell.h"
#import "ReplyButton.h"


@implementation DetailViewController

@synthesize post, messages, message_uids, unread_ids, detailCell, replyController;


- (id)init {
	if (self = [[DetailViewController alloc] initWithNibName:nil bundle:nil]) {
		messages = [[NSMutableDictionary alloc] initWithCapacity:1];
		message_uids = [[NSMutableArray alloc] initWithCapacity:1];
		unread_ids = nil;
		detailCell = [[DetailCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"DetailCell"];
		// FIXME: make this lazy loading
		replyController = [[ReplyViewController alloc] init];
		// FIXME: implement up and down arrows to flip through posts
		scroll_to_top = YES;
		self.hidesBottomBarWhenPushed = YES;
	}
	return self;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	[messages release];
	[message_uids release];
	[post release];
	[detailCell release];
    [super dealloc];
}

#pragma mark -
#pragma mark TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	//DLog(@"sections %i",  [message_uids count]);
	return [message_uids count] + 1;
//	int i;
//	if (i = [message_uids count] ) {
//		return i + 1;
//	} else {
//		return 1;
//	}
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 1;
	}
    return [ [messages objectForKey:[message_uids objectAtIndex:section - 1] ] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	NSNumber *uid = [NSNumber numberWithInteger:[[CasocialAppDelegate sharedAppDelegate] userId]];

	if (indexPath.section == 0) {
		if ([uid isEqualToNumber:post.userId] || [messages count] > 0) {
			detailCell.replyButton.hidden = YES;
		} else {
			detailCell.replyButton.hidden = NO;
		}
		return detailCell;
	} else {
		// Message
		static NSString *CellIdentifier = @"conversationCell";
		MessageCell *cell = (MessageCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[MessageCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
		
		// Set up the cell...
		//Message* message = (Message *)[[post.messages allObjects] objectAtIndex:indexPath.row - 1];		
		Message* message = [ [messages objectForKey:[message_uids objectAtIndex:indexPath.section - 1] ] objectAtIndex:indexPath.row];
		//DLog(@"%@ %@", uid, message.userId);
		[cell setMessage:message type:[uid isEqualToNumber:message.userId] ? BUBBLE_TYPE_GREEN : BUBBLE_TYPE_GRAY];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		if (unread_ids && [unread_ids containsObject:message.messageId]) {
			// FIXME: show a badge instead of a button
			cell.cellView.backgroundColor = [UIColor lightGrayColor];
			// remove Id from unread_ids
			[unread_ids removeObject:message.messageId];
			// tell main view to reload data
			[[[CasocialAppDelegate sharedAppDelegate] mainViewController].tableView reloadData];
		} else {
			cell.cellView.backgroundColor = [UIColor whiteColor];
		}

		
		if (indexPath.row == [[messages objectForKey:[message_uids objectAtIndex:indexPath.section - 1] ] count] -1) {
			cell.replyButton.hidden = NO;
			// Add 
			[cell.replyButton addTarget:self action:@selector(replyToMessage:) forControlEvents:UIControlEventTouchUpInside];
			cell.replyButton.message = message;
		} else {
			cell.replyButton.hidden = YES;
		}
		return cell;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		detailCell.post = post;
		[detailCell.replyButton addTarget:self action:@selector(replyToPost) forControlEvents:UIControlEventTouchUpInside];		
		return [detailCell cellHeight];
	}
	
	Message* message = [ [messages objectForKey:[message_uids objectAtIndex:indexPath.section - 1] ] objectAtIndex:indexPath.row];
	return [MessageCell calcCellHeight:message];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section > 1) {
		return [NSString stringWithFormat:@"Somebody No. %i", section];
	} else if (section == 1) {
		return @"Somebody";
	} else {
		return @"";
	}
}




#pragma mark -
#pragma mark UIView methods

- (void)viewDidLoad {
//	tableView.allowsSelection = NO;
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {	
	self.title = post.title;
	[self.tableView reloadData];
	if ([unread_ids count] > 0) {
		NSInteger row = -1;
		NSInteger section = 1;
		for (NSNumber *uid in message_uids) {
			for (Message *msg in [messages objectForKey:uid]) {
				if ([unread_ids containsObject:msg.messageId]) {
					row = [ [messages objectForKey:uid] indexOfObject:msg];
					break;
				}
			}
			if (row >= 0) {
				break;
			}
			section += 1;
		}
		if (row >= 0) {
			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
		}
	} else {
		// scroll to top if its a new post
		if (scroll_to_top) {
			scroll_to_top = NO;
			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
		}
	}

}

- (void)viewWillDisappear:(BOOL)animated {	
	[super viewWillDisappear:animated];
//	if ([self.replyView.textView isFirstResponder]) [self.replyView.textView resignFirstResponder];
}

#pragma mark -
#pragma mark Overriden Setters

- (void)setPost:(Post *)newPost
{
    if (newPost != post) {
		[post release];
        post = nil;        
        post = [newPost retain];
	}
	
	if (post != nil)  {
		scroll_to_top = YES;
		
		// clear any remaining objects
		[messages removeAllObjects];
		[message_uids removeAllObjects];
		
		// init messages
		NSNumber *uid;
		NSNumber *myUserId = [NSNumber numberWithInt:[[CasocialAppDelegate sharedAppDelegate] userId]];
		NSMutableArray *messages_for_uid; // landen später in messages Dict
		for (Message *message in post.messages) {
			if ([myUserId isEqualToNumber:message.userId]) {
				uid = [NSNumber numberWithInt:[message.inReplyToUserId intValue]];
			} else {
				uid = [NSNumber numberWithInt:[message.userId intValue]];
			}
			
			if (messages_for_uid = [messages objectForKey:uid]) {
				// add message to conversation
				// flip through array
				NSInteger i;
				NSInteger c = [messages_for_uid count];
				for (i = 0; i < c; i += 1) {
					Message* msg = [messages_for_uid objectAtIndex:i];
					if ([message.createdAt compare:msg.createdAt] == NSOrderedAscending) {
						[messages_for_uid insertObject:message atIndex:i];
						break;
					}
				}
				if (i == c) {
					[messages_for_uid addObject:message];
				}
			} else {
				// FIXME: does this leak? Neue Number
				messages_for_uid = [NSMutableArray arrayWithObjects:message, nil];
				[messages setObject:messages_for_uid forKey:uid];
				[message_uids addObject:uid];
			}
		}
		
//		DLog(@"messages %@", messages);
//		DLog(@"uids %@", message_uids);
	}
}

#pragma mark -
#pragma mark Data methods
-(void) checkForNewMessages {
	//FIXME this sucks performance wise
	
	NSNumber *uid;
	NSNumber *myUserId = [NSNumber numberWithInt:[[CasocialAppDelegate sharedAppDelegate] userId]];
	NSMutableArray *messages_for_uid; // landen später in messages Dict
	Message* new_msg = nil;
	
	for (Message *message in post.messages) {
		// get conversation uid
		if ([myUserId isEqualToNumber:message.userId]) {
			uid = [NSNumber numberWithInt:[message.inReplyToUserId intValue]];
		} else {
			uid = [NSNumber numberWithInt:[message.userId intValue]];
		}

		if (messages_for_uid = [messages objectForKey:uid]) {
			// conversation exists, check if message is in array
			if ([messages_for_uid containsObject:message]) {
				continue;
			}
			
			// flip through array
			NSInteger i;
			NSInteger c = [messages_for_uid count];
			for (i = 0; i < c; i += 1) {
				Message* msg = [messages_for_uid objectAtIndex:i];
				if ([message.createdAt compare:msg.createdAt] == NSOrderedAscending) {
					[messages_for_uid insertObject:message atIndex:i];
					new_msg = message;
					break;
				}
			}
			if (i == c) {
				[messages_for_uid addObject:message];
				new_msg = message;
			}
			// add to tableView
//			NSInteger section = [message_uids indexOfObject:uid];
//			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:section+1]]
//			 withRowAnimation:UITableViewRowAnimationFade];

		} else {
			// FIXME: does this leak? Neue Number
			messages_for_uid = [NSMutableArray arrayWithObjects:message, nil];
			new_msg = message;
			[messages setObject:messages_for_uid forKey:uid];
			[message_uids addObject:uid];			
		}
	}
	if (new_msg) {
		if ([myUserId isEqualToNumber:new_msg.userId]) {
			uid = [NSNumber numberWithInt:[new_msg.inReplyToUserId intValue]];
		} else {
			uid = [NSNumber numberWithInt:[new_msg.userId intValue]];
		}		
		NSInteger section = [message_uids indexOfObject:uid] + 1;
		NSInteger row = [[messages objectForKey:uid] indexOfObject:new_msg];
		[self.tableView reloadData];
		[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] atScrollPosition:UITableViewScrollPositionNone animated:YES];
	}
}

#pragma mark -
#pragma mark Actions

-(void) replyToPost {
	// Create Reply View
    replyController.post = post;
	replyController.message = nil;
    [self.navigationController presentModalViewController:replyController.navigationController animated:YES];
}

-(void) replyToMessage:(ReplyButton*)sender {
	// Create Reply View
    replyController.post = post;
	replyController.message = sender.message;
    [self.navigationController presentModalViewController:replyController.navigationController animated:YES];
//    [replyController setEditing:YES animated:NO];			
}


@end
