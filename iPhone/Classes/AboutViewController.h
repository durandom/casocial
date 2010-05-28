//
//  AboutViewController.h
//  Casocial
//
//  Created by Marcel Hild on 23.06.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutViewController : UIViewController {
	UINavigationController *navigationController;
	NSString *defaultFeedback;
	IBOutlet UITextView *feedbackView;
	IBOutlet UIButton *feedbackButton;
}

@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, copy) NSString *defaultFeedback;
@property (nonatomic, retain) UITextView *feedbackView;


- (IBAction)done:(id)sender;
- (IBAction)feedback:(id)sender;

@end
