//
//  EditMessageCell.h
//  Casocial
//
//  Created by Marcel Hild on 25.05.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "ChatBubbleView.h"

@class Message, ChatBubbleView, ReplyButton;

@interface MessageCell : UITableViewCell {
	Message *message;
    ChatBubbleView*     cellView;
	ReplyButton *replyButton;
}

@property (nonatomic, retain) ChatBubbleView* cellView;
@property (nonatomic, retain) ReplyButton *replyButton;
- (void)setMessage:(Message*)msg type:(BubbleType)type;

+ (CGFloat)calcCellHeight:(Message*)msg;

@end
