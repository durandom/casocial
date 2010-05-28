//
//  BrowseDetailViewController.h
//
//

#import "ReplyView.h"

#define TITLE_HEIGHT 40

@class Post;

@interface BrowseDetailViewController : UIViewController <UITextViewDelegate> {
@private
    Post *post;
	UILabel *postTitle;
	UITextView *postBody;
	ReplyView *replyView;
	//CGRect keyboardBounds;
}

@property (nonatomic, retain) Post *post;
@property (nonatomic, retain) UILabel *postTitle;
@property (nonatomic, retain) UITextView *postBody;
@property (nonatomic, retain) ReplyView *replyView;
//@property (nonatomic, assign) CGRect keyboardBounds;  

-(void)replyButtonPressed:(id)sender;
//-(void)scrollViewToCenterOfScreen:(UIView *)theView;


@end
