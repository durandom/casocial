//
//  EditMessageCell.m
//  Casocial
//
//  Created by Marcel Hild on 25.05.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ChatBubbleView.h"
#import "MessageCell.h"
#import "Message.h"
#import "ReplyButton.h"

@implementation MessageCell

@synthesize cellView, replyButton;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	[super initWithFrame:frame reuseIdentifier:reuseIdentifier];

    cellView = [[[ChatBubbleView alloc] initWithFrame:CGRectZero] autorelease];
    [self.contentView addSubview:cellView];
	
	replyButton = [[ReplyButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
	
	replyButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	replyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[replyButton setTitle:NSLocalizedStringFromTable(@"Reply", @"Localized", nil) forState:UIControlStateNormal]; 
	[replyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	replyButton.titleLabel.font = [UIFont boldSystemFontOfSize: 14];
	
	
	UIImage *newImage = [[UIImage imageNamed:@"blueButton.png"] stretchableImageWithLeftCapWidth:12.0f topCapHeight:0.0f];
	[replyButton setBackgroundImage:newImage forState:UIControlStateNormal];
		
	replyButton.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:replyButton];

	return self;
}

#pragma mark -
#pragma mark Public methods

- (void)setMessage:(Message *)newMessage type:(BubbleType)type
{
    if (newMessage != message) {
		[message release];
        message = nil;        
        message = [newMessage retain];
	}
	
	if (message != nil)  {
		[cellView setMessage:message type:type];
		//cellView.image = [self getProfileImage:aMessage.user.profileImageUrl isLarge:false];
	}
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    cellView.frame = self.bounds;
 
//	DLog(@"w %f", cellView.frame.size.width);
//	DLog(@"h %f", cellView.frame.size.height);

	if (!replyButton.hidden) {
		CGRect frame = replyButton.frame;
		frame.origin.y = cellView.frame.size.height - 32;
		if (cellView.type == BUBBLE_TYPE_GRAY) {
			frame.origin.x = 252;
		} else {
			frame.origin.x = 8;
		}
		replyButton.frame = frame;
	}
}


- (void)dealloc {
	[replyButton release];
	[message release];
    [super dealloc];
}

+ (CGFloat)calcCellHeight:(Message*)msg
{
    // Calculate text bounds and cell height here
    //
    CGRect bounds;
    
    bounds = CGRectMake(0, 0, CHAT_BUBBLE_TEXT_WIDTH, 4000); // Maximum chat bubble height
    static UILabel *label = nil;
    if (label == nil) {
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:14];
    }
    
	label.numberOfLines = 0;
    label.text = msg.body;
    CGRect bubbleRect = [label textRectForBounds:bounds limitedToNumberOfLines:0];        
 //   CGFloat ret = bubbleRect.size.height + 5 +5 +5; // bubble height
	CGFloat ret = bubbleRect.size.height + 41; // bubble height
//	ret += 26;
    return ret;
}



@end
