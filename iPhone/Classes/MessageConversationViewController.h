//
//  MessageConversationViewController.h
//  Casocial
//
//  Created by Marcel Hild on 18.05.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


//#import "Three20/Three20.h"

@class ReplyView;

@interface MessageConversationViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate> {
	NSArray	*conversations;
	UITableView *tableView;
	//TTTextEditor *replyEditor;
	ReplyView* replyView;
	NSMutableDictionary *cells;
	NSNumber* userId;
	NSArray* lookupKey;
}

@property (nonatomic, retain) NSArray *conversations;
@property (nonatomic, retain) UITableView *tableView;
//@property (nonatomic, retain) TTTextEditor *replyEditor;
@property (nonatomic, retain) NSMutableDictionary *cells;
@property (nonatomic, retain) NSNumber* userId;
@property (nonatomic, retain) NSArray* lookupKey;
@property (nonatomic, retain) ReplyView* replyView;


- (void)replyButtonPressed:(id)sender;

@end
