//
//  NewPostViewController.h
//  Casocial
//
//  Created by Marcel Hild on 08.04.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@class Post;

@interface PostNewViewController : UIViewController <UITextViewDelegate> {
@private
	IBOutlet UITextField *postTitle;
	IBOutlet UITextView *postDetails;
	IBOutlet UIButton *categoryButton;
	IBOutlet UILabel *categoryLabel;
	UINavigationController *navigationController;
	NSInteger currentCategory;
	Post *post;
}

@property (nonatomic, retain) UITextField *postTitle;
@property (nonatomic, retain) UITextView *postDetails;
@property (nonatomic, retain) UIButton *categoryButton;
@property (nonatomic, retain) UILabel *categoryLabel;;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) Post *post;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)titleDoneEditing:(id)sender;
- (IBAction)titleChangedEditing:(id)sender;
- (IBAction)categoryButtonPressed:(id)sender;
- (void)updateCategory;

@end
