//
//  BrowseCell.m
//  Casocial
//
//  Created by Marcel on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BrowseCell.h"
#import "Post.h"
#import "PostCategory.h"
#import "Message.h"
#import "CasocialAppDelegate.h"

@implementation BrowseCell

@synthesize post, titleLabel, bodyLabel, distanceLabel, timeLabel, badge;

#pragma mark -
#pragma mark Constructor and destructor


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier 
{
    //if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) 
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) 
    {
		//self.backgroundColor = [UIColor blackColor];
		
		//CGRect contentRect = self.contentView.bounds;
		
		// Abstand: 8px
        
        categoryImage = [[UIImageView alloc] initWithFrame:CGRectMake(20.0, 8.0, 32.0, 32.0)];
        categoryImage.contentMode = UIViewContentModeScaleAspectFill;
        categoryImage.clipsToBounds = YES;
        [self.contentView addSubview:categoryImage];
        
		distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 47.0, 55.0, 12.0)];
        distanceLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
		//distanceLabel.textColor = [UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:1.0];	
		distanceLabel.textColor = [UIColor blueColor];	
        //distanceLabel.contentMode = UIViewContentModeScaleToFill;
		distanceLabel.textAlignment =  UITextAlignmentRight;
        [self.contentView addSubview:distanceLabel];

		timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(248.0, 8.0, 52.0, 12.0)];
        timeLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
		timeLabel.textColor = [UIColor blueColor];	
		timeLabel.textAlignment =  UITextAlignmentRight;
        [self.contentView addSubview:timeLabel];
		
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 8.0, 180.0, 18.0)];
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
       // textLabel.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:titleLabel];

        bodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 28.0, 240.0, 31.0)];
		bodyLabel.numberOfLines = 2;
        bodyLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        [self.contentView addSubview:bodyLabel];
		
		badge = [[UIButton alloc] initWithFrame:CGRectMake(8, 4, 15, 15)];
		badge.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		badge.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		[badge setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		badge.titleLabel.font = [UIFont boldSystemFontOfSize: 9];
		UIImage *newImage = [[UIImage imageNamed:@"badge.png"] stretchableImageWithLeftCapWidth:7.0f topCapHeight:0.0f];
		[badge setBackgroundImage:newImage forState:UIControlStateNormal];		
		badge.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:badge];
		

		//        scrollingWheel = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(27.0, 27.0, 20.0, 20.0)];
//        scrollingWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//        scrollingWheel.hidesWhenStopped = YES;
//        [scrollingWheel stopAnimating];
//        [self.contentView addSubview:scrollingWheel];
        
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}


- (void)dealloc 
{
    [categoryImage release];
    [titleLabel release];
	[distanceLabel release];
	[bodyLabel release];
	[timeLabel release];
//    [post setDelegate:nil];
    [post release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {	
	DLog(@"post %@ appears", post.postId);
//	if (unreadMessages) {
//		badge.hidden = NO;
//		[badge setTitle:[NSString stringWithFormat:@"%i", unreadMessages] forState:UIControlStateNormal]; 
//		if (unreadMessages > 9) {
//			CGRect frame = badge.frame;
//			badge = [[UIButton alloc] initWithFrame:CGRectMake(8, 4, 30, 15)];
//		}
//
//	} else {
//		badge.hidden = YES;
//	}
}

#pragma mark -
#pragma mark Public methods

- (void)setPost:(Post *)newPost
{
    if (newPost != post) {
		[post release];
        post = nil;        
        post = [newPost retain];
	}
		
	if (post != nil)  {
		//titleLabel.text = [NSString stringWithFormat: @"%@ %@", post.title, post.createdAt];
		titleLabel.text = post.title;
		bodyLabel.text = post.body;
	
		timeLabel.text = [post dateString];

		distanceLabel.text = [post distanceFromHere];

		switch ( [post.category integerValue] ) 
		{ 
			case CAT_WANT: 
				[categoryImage setImage:[UIImage imageNamed:@"want.png"]];				
				break;
			case CAT_HAVE:
				[categoryImage setImage:[UIImage imageNamed:@"have.png"]];				
				break;
			case CAT_OTHER:
				[categoryImage setImage:[UIImage imageNamed:@"other.png"]];				
				break;
		}
		
//		unreadMessages = 0;
//		for (Message* msg in post.messages) {
//			if (msg.unread) {
//				unreadMessages += 1;
//			}
//		}
	}
}

//- (void)toggleImage
//{
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:photo cache:YES];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
//    
//    photo.image = item.thumbnail;
//    
//    [UIView commitAnimations];
//}
//
//- (void)loadImage
//{
//    // The getter in the FlickrItem class is overloaded...!
//    // If the image is not yet downloaded, it returns nil and 
//    // begins the asynchronous downloading of the image.
//    UIImage *image = item.thumbnail;
//    if (image == nil)
//    {
//        [scrollingWheel startAnimating];
//    }
//    photo.image = image;
//}

#pragma mark -
#pragma mark FlickrItemDelegate methods

//- (void)post:(Post *)item didLoadThumbnail:(UIImage *)image
//{
//    photo.image = image;
//    [scrollingWheel stopAnimating];
//}
//
//- (void)post:(Post *)item couldNotLoadImageError:(NSError *)error
//{
//    // Here we could show a "default" or "placeholder" image...
//  //  [scrollingWheel stopAnimating];
//}
//
#pragma mark -
#pragma mark UIView animation delegate methods

- (void)animationFinished
{
}

@end
