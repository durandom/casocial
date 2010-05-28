//
//  AboutViewController.m
//  Casocial
//
//  Created by Marcel Hild on 23.06.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import "CasocialAppDelegate.h"


@implementation AboutViewController

@synthesize navigationController, defaultFeedback, feedbackView;

- (id)init {
    self = [super initWithNibName:@"About" bundle:nil];
	self.navigationController = [[UINavigationController alloc] initWithRootViewController:self];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
																						   target:self action:@selector(done:)] autorelease];
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	// FIXME: localize
	self.title = @"About";
	self.defaultFeedback = feedbackView.text;
 
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (IBAction)done:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
	CGRect frame = self.view.frame;
	frame.size.height -= V_KEYBOARD_HEIGHT;
	self.view.frame = frame;
	
	if ([self.defaultFeedback isEqualToString:self.feedbackView.text]) {
		self.feedbackView.text = @"";
	}
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	CGRect frame = self.view.frame;
	frame.size.height += V_KEYBOARD_HEIGHT;
	self.view.frame = frame;
	
	// reset feedback text if needed
	if ([self.feedbackView.text isEqualToString:@""]) {
		self.feedbackView.text = self.defaultFeedback;
	}
}

- (IBAction)feedback:(id)sender {
	if (![[[CasocialAppDelegate sharedAppDelegate] server] checkNetwork]) return;
	// If not empty and not default string	
	if (![self.feedbackView.text isEqualToString:@""] && ![self.feedbackView.text isEqualToString:self.defaultFeedback]) {
		[[[CasocialAppDelegate sharedAppDelegate] server]  sendFeedback:self.feedbackView.text];
		self.feedbackView.text = @"Thanks for giving feedback.";
		feedbackButton.hidden = YES;
	}
	[feedbackView resignFirstResponder];
}

@end
