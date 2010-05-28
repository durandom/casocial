//
//  ReplyView.m
//  Casocial
//
//  Created by Marcel Hild on 27.05.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ReplyView.h"


@implementation ReplyView

@synthesize textView, button;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		//		self.replyView = [[UIView alloc] initWithFrame:CGRectMake(0.0, VIEW_HEIGHT - EDITOR_HEIGHT, VIEW_WIDTH, EDITOR_HEIGHT)];
		//		self.replyView.backgroundColor = [UIColor blackColor];
		
		//      self.replyEditor = [[TTTextEditor alloc] initWithFrame:CGRectMake(0.0, VIEW_HEIGHT - EDITOR_HEIGHT, VIEW_WIDTH - BUTTON_WIDTH, EDITOR_HEIGHT)];
		//      self.replyEditor.autoresizingMask = UIViewAutoresizingFlexibleHeight;		
		//		self.replyEditor.backgroundColor = [UIColor blueColor];
		//		self.replyEditor.textView.backgroundColor = [UIColor whiteColor];
		//		self.replyEditor.placeholder = @"reply";
		//		self.replyEditor.minNumberOfLines = 1;
		//		self.replyEditor.maxNumberOfLines = 3;		
		//		self.replyEditor.textDelegate = self;
		
		self.backgroundColor = [UIColor whiteColor];
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
		frame.origin = CGPointMake(0,0);
		frame.size.width -= REPLY_VIEW_BUTTON_WIDTH;
		textView = [[UITextView alloc] initWithFrame:frame];
		//textView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
		
		button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		//CGRectMake(VIEW_WIDTH - REPLY_VIEW_BUTTON_WIDTH, y, REPLY_VIEW_HEIGHT, REPLY_VIEW_BUTTON_WIDTH)
		frame.origin.x = VIEW_WIDTH - REPLY_VIEW_BUTTON_WIDTH;
		frame.size.width = REPLY_VIEW_BUTTON_WIDTH;
		button.frame = frame;
		[button setTitle:@"reply" forState:UIControlStateNormal];
		//button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
	
		[self addSubview:textView];
		[self addSubview:button];
//		[textView release];
//		[button release];

    }
    return self;
}


//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}


- (void)dealloc {
	[textView release];
//	[button release]; autoreleased
    [super dealloc];
}


@end
