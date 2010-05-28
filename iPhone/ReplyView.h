//
//  ReplyView.h
//  Casocial
//
//  Created by Marcel Hild on 27.05.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#define REPLY_VIEW_HEIGHT 50
#define REPLY_VIEW_BUTTON_WIDTH 100.0

@interface ReplyView : UIView {
	UITextView *textView;
	UIButton *button;

}

@property (nonatomic, assign) UITextView *textView;
@property (nonatomic, assign) UIButton *button;


@end
