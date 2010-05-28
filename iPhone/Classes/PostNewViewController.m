//
//  NewPostViewController.m
//  Casocial
//
//  Created by Marcel Hild on 08.04.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CasocialAppDelegate.h"
#import "PostNewViewController.h"
#import "Post.h"

@implementation PostNewViewController

@synthesize postTitle, postDetails, categoryButton, categoryLabel, post, navigationController;


- (id)init {
    self = [super initWithNibName:@"PostNew" bundle:nil];
	navigationController = [[UINavigationController alloc] initWithRootViewController:self];
	currentCategory = CAT_WANT;
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
																						   target:self action:@selector(cancel:)] autorelease];
	// FIXME: change to "Reply" Field
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
																							target:self action:@selector(save:)] autorelease];
	// FIXME: localize
	self.title = @"New Post";
    return self;
}

- (void)dealloc 
{
	//    [post setDelegate:nil];
	DLog(@"dealloc PostNewViewController");
	[postTitle release];
    [postDetails release];
	[categoryButton release];
	[categoryLabel release];
	[navigationController release];
    [super dealloc];
}

- (void)viewDidLoad {
    // Override the DetailViewController viewDidLoad with different navigation bar items and title
	
//	UIImageView *otherView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"other.png"]];
//	UIImageView *wantView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"want.png"]];
//	UIImageView *haveView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"have.png"]];	
//	self.categories = [[NSArray alloc] initWithObjects: otherView, wantView, haveView, nil];
//	[otherView release];
//	[wantView release];
//	[haveView release];	
}

- (void)viewWillAppear:(BOOL)animated {	
    [super viewWillAppear:animated];
	[self updateCategory];
	[postTitle becomeFirstResponder];
	self.navigationItem.rightBarButtonItem.enabled = (self.postTitle.text.length > 0 && self.postDetails.text.length > 0);

    // Conditionally enable the "Save" button
    //self.navigationItem.rightBarButtonItem.enabled = (self.post.title && self.post.title.length > 0);
	//[self.categoryButton setImage:[UIImage imageNamed:@"other.png"] forState:UIControlStateNormal];
	//[self.categoryButton setImage:[(UIImageView *)[self.categoryPicker viewForRow:[self.categoryPicker selectedRowInComponent:0] forComponent:0] image] forState:UIControlStateNormal];
}

- (IBAction)cancel:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
	if ([[[CasocialAppDelegate sharedAppDelegate] server] checkNetwork]) {
		// FIXME: only save if some text and details are entered	
		[[[CasocialAppDelegate sharedAppDelegate] server] sendPostWithTitle:postTitle.text 
																   withBody:postDetails.text 
		 //														  withCategory:[self.categoryPicker selectedRowInComponent:0]];	
															   withCategory:currentCategory];	
		// reset post
		postTitle.text = @"";
		postDetails.text = @"";
		
		// Dismiss the modal view to return to the main list
		[self.navigationController dismissModalViewControllerAnimated:YES];
	}
}

- (void)textViewDidChange:(UITextView *)textView {
	self.navigationItem.rightBarButtonItem.enabled = (self.postTitle.text.length > 0 && self.postDetails.text.length > 0);
}

- (IBAction)titleDoneEditing:(id)sender {
//	[sender resignFirstResponder];
	[postDetails becomeFirstResponder];
}

- (IBAction)titleChangedEditing:(id)sender {
	self.title = postTitle.text;
}

- (IBAction)categoryButtonPressed:(id)sender {
	switch (currentCategory) {
		case CAT_WANT:
			currentCategory = CAT_HAVE;
			break;
		case CAT_HAVE:
			currentCategory = CAT_OTHER;
			break;
		case CAT_OTHER:
			currentCategory = CAT_WANT;
			break;
	}
	[self updateCategory];
	
	// Show select
//	self.categoryPicker.hidden = NO;
//	[self.categoryPicker becomeFirstResponder];	
}

- (void)updateCategory {

	// FIXME: localize
	switch (currentCategory) {
		case CAT_WANT:
			[categoryButton setImage:[UIImage imageNamed:@"want.png"] forState:UIControlStateNormal];
			categoryLabel.text = @"Want";
			break;
		case CAT_HAVE:
			[categoryButton setImage:[UIImage imageNamed:@"have.png"] forState:UIControlStateNormal];
			categoryLabel.text = @"Have";
			break;
		case CAT_OTHER:
			[categoryButton setImage:[UIImage imageNamed:@"other.png"] forState:UIControlStateNormal];
			categoryLabel.text = @"Other";
			break;
	}
}

/*

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{	
	return [self.categories count];
}
#pragma mark Picker Delegate Methods

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
		  forComponent:(NSInteger)component reusingView:(UIView *)view {
	return [self.categories objectAtIndex:row];
	
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	[self.categoryButton setImage:[(UIImageView *)[pickerView viewForRow:row forComponent:component] image] forState:UIControlStateNormal];
	self.categoryPicker.hidden = YES;
	[self.categoryPicker resignFirstResponder];
}

*/

@end
