//
//  DetailViewController.h
//  Casocial
//
//  Created by Marcel Hild on 15.06.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Post, DetailCell, ReplyViewController;

@interface DetailViewController : UITableViewController  <UITextViewDelegate> {
	Post *post;
	NSMutableDictionary *messages; // { uid1 => [msg1, msg2], uid2 => [msg3] }
	NSMutableArray *message_uids;  // [ uid2, uid2 ] - ordered by date, used for sections
	NSMutableArray *unread_ids;    // [ msgid2 ]
	DetailCell *detailCell;
	ReplyViewController* replyController;
	BOOL scroll_to_top;
//	UITableView *tableView;
}

@property (nonatomic, retain) Post *post;
@property (nonatomic, retain) NSMutableDictionary *messages;
@property (nonatomic, retain) NSMutableArray *message_uids;
@property (nonatomic, retain) NSMutableArray *unread_ids;
@property (nonatomic, retain) DetailCell *detailCell;
@property (nonatomic, retain) ReplyViewController* replyController;

-(void) replyToPost;
-(void) replyToMessage:(UIButton*)sender;
-(void) checkForNewMessages;

@end
