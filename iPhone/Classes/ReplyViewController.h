//
//  ReplyViewController.h
//  Casocial
//
//  Created by Marcel Hild on 19.06.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Message, Post;

@interface ReplyViewController : UIViewController <UITextViewDelegate> {
	UITextView *messageView;
	Post *post;
	Message *message;

	UIImageView *categoryImage;
    UILabel *titleLabel;
	UILabel *distanceLabel;
	UILabel *timeLabel;
	UITextView *bodyView;
	UILabel *categoryLabel;
	
	UINavigationController *navigationController;
}

@property (nonatomic, retain) UITextView *messageView;
@property (nonatomic, retain) Post *post;
@property (nonatomic, retain) Message *message;

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *distanceLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UITextView *bodyView;
@property (nonatomic, retain) UILabel *categoryLabel;

- (void)cancel:(id)sender;
- (void)send:(id)sender;


@end
