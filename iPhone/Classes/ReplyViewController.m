//
//  ReplyViewController.m
//  Casocial
//
//  Created by Marcel Hild on 19.06.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CasocialAppDelegate.h"
#import "ReplyViewController.h"
#import "Message.h"
#import "Post.h"
#import "PostCategory.h"


@implementation ReplyViewController

@synthesize messageView, post, message, titleLabel, bodyView, distanceLabel, timeLabel, categoryLabel;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
- (id)init {
    if (self = [super initWithNibName:nil bundle:nil]) {
		message = nil;
		post = nil;
		
		navigationController = [[UINavigationController alloc] initWithRootViewController:self];		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
																							   target:self action:@selector(cancel:)] autorelease];
		// FIXME: localize to reply button
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
																								target:self action:@selector(send:)] autorelease];
		
		self.view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 86.0, 320.0, 200.0)];
		
		// Abstand: 8px        
		categoryImage = [[UIImageView alloc] initWithFrame:CGRectMake(20.0, 8.0, 32.0, 32.0)];
		categoryImage.contentMode = UIViewContentModeScaleAspectFill;
		categoryImage.clipsToBounds = YES;
		[self.view addSubview:categoryImage];
		
		categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 40.0, 32.0, 12.0)];
		categoryLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
		categoryLabel.textAlignment =  UITextAlignmentCenter;
		[self.view addSubview:categoryLabel];
		
		distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 55.0, 55.0, 12.0)];
		distanceLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
		//distanceLabel.textColor = [UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:1.0];	
		distanceLabel.textColor = [UIColor blueColor];	
		distanceLabel.textAlignment =  UITextAlignmentRight;
		[self.view addSubview:distanceLabel];
		
		timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 70.0, 55.0, 12.0)];
		timeLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
		timeLabel.textColor = [UIColor blueColor];
		timeLabel.textAlignment =  UITextAlignmentRight;
		[self.view addSubview:timeLabel];
		
		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64.0, 8.0, 250.0, 18.0)];
		titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
		titleLabel.numberOfLines = 0;
		//titleLabel.backgroundColor = [UIColor redColor];
		//titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin || UIViewAutoresizingFlexibleHeight;
		// textLabel.contentMode = UIViewContentModeScaleToFill;
		[self.view addSubview:titleLabel];
		
		bodyView = [[UITextView alloc] initWithFrame:CGRectMake(64.0, 30.0, 250.0, 54.0)];
		//bodyLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin || UIViewAutoresizingFlexibleHeight;
		bodyView.font = [UIFont fontWithName:@"Helvetica" size:12.0];
		bodyView.editable = NO;
		//bodyLabel.backgroundColor = [UIColor greenColor];
		// FIXME: bodyView should not become first Responder. I.e. the keyboard should not be dismissed
		[self.view addSubview:bodyView];
		
		messageView = [[UITextView alloc] initWithFrame:CGRectMake(0, 84, 320, 116)];	
		messageView.font = [UIFont systemFontOfSize:17.0];
		messageView.delegate = self;
		[self.view addSubview:messageView];						
    }
    return self;
}


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
	[categoryImage release];
    [titleLabel release];
	[distanceLabel release];
	[bodyView release];
	[timeLabel release];
	[categoryLabel release];
	
	[navigationController release];
	[messageView release];
	[message release];
	[post release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
	self.title = [NSString stringWithFormat:@"Re: %@", post.title];
	self.navigationItem.rightBarButtonItem.enabled = (self.messageView.text.length > 0);
	[bodyView scrollRangeToVisible:NSMakeRange(0, 1)];
	[messageView becomeFirstResponder];
}

-(void)loadView {
}


- (void)setPost:(Post *)newPost
{
    if (newPost != post) {
		[post release];
        post = nil;        
        post = [newPost retain];
	}
	
	if (post != nil)  {
		titleLabel.text = post.title;
		bodyView.text = post.body;
		
		timeLabel.text = [post dateString];
		distanceLabel.text = [post distanceFromHere];
		
		// FIXME: localize
		switch ( [post.category integerValue] ) 
		{ 
			case CAT_WANT: 
				[categoryImage setImage:[UIImage imageNamed:@"want.png"]];
				categoryLabel.text = @"Want";
				break;
			case CAT_HAVE:
				[categoryImage setImage:[UIImage imageNamed:@"have.png"]];	
				categoryLabel.text = @"Have";
				break;
			case CAT_OTHER:
				[categoryImage setImage:[UIImage imageNamed:@"other.png"]];				
				categoryLabel.text = @"Other";
				break;
		}
	}
}

- (void)textViewDidChange:(UITextView *)textView {
	self.navigationItem.rightBarButtonItem.enabled = (self.messageView.text.length > 0);
}

#pragma mark -
#pragma mark Actions

- (IBAction)cancel:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction)send:(id)sender {
	NSNumber *inReplyTo;
	if (message) {
		if ([[CasocialAppDelegate sharedAppDelegate] userId] == [message.userId integerValue]) {
			inReplyTo = message.inReplyToUserId;
		} else {
			inReplyTo = message.userId;
		}
	} else {
		inReplyTo = post.userId;
	}
	
	[[[CasocialAppDelegate sharedAppDelegate] server] sendMessage:messageView.text forPost:post inReplyTo:inReplyTo];	
	
	self.messageView.text = @"";
	
    // Dismiss the modal view to return to the main list
    [self.navigationController dismissModalViewControllerAnimated:YES];
}



@end
