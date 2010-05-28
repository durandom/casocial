//
//  DetailCell.m
//  Casocial
//
//  Created by Marcel Hild on 15.06.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DetailCell.h"
#import "Post.h"
#import "PostCategory.h"
#import "CasocialAppDelegate.h"


@implementation DetailCell

@synthesize post, titleLabel, bodyLabel, distanceLabel, timeLabel, replyButton, categoryLabel;
#pragma mark -
#pragma mark Constructor and destructor


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier 
{
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) 
    {
		//self.contentView.backgroundColor = [UIColor yellowColor];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		// Abstand: 8px        
        categoryImage = [[UIImageView alloc] initWithFrame:CGRectMake(20.0, 8.0, 32.0, 32.0)];
        categoryImage.contentMode = UIViewContentModeScaleAspectFill;
        categoryImage.clipsToBounds = YES;
        [self.contentView addSubview:categoryImage];
		
		categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 40.0, 32.0, 12.0)];
        categoryLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
		categoryLabel.textAlignment =  UITextAlignmentCenter;
        [self.contentView addSubview:categoryLabel];
		
        
		distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 55.0, 55.0, 12.0)];
        distanceLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
		//distanceLabel.textColor = [UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:1.0];	
		distanceLabel.textColor = [UIColor blueColor];	
		distanceLabel.textAlignment =  UITextAlignmentRight;
        [self.contentView addSubview:distanceLabel];
		
		timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 70.0, 55.0, 12.0)];
        timeLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
		timeLabel.textColor = [UIColor blueColor];
		timeLabel.textAlignment =  UITextAlignmentRight;
        [self.contentView addSubview:timeLabel];
		
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
		titleLabel.numberOfLines = 0;
		//titleLabel.backgroundColor = [UIColor redColor];
		//titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin || UIViewAutoresizingFlexibleHeight;
		// textLabel.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:titleLabel];
		
        bodyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		bodyLabel.numberOfLines = 0;
		//bodyLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin || UIViewAutoresizingFlexibleHeight;
        bodyLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
		//bodyLabel.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:bodyLabel];
		
		replyButton = [[UIButton alloc] initWithFrame:CGRectZero];
		replyButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		replyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		[replyButton setTitle:NSLocalizedStringFromTable(@"Reply", @"Localized", nil) forState:UIControlStateNormal]; 
		[replyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		replyButton.titleLabel.font = [UIFont boldSystemFontOfSize: 14];
		UIImage *newImage = [[UIImage imageNamed:@"blueButton.png"] stretchableImageWithLeftCapWidth:12.0f topCapHeight:0.0f];
		[replyButton setBackgroundImage:newImage forState:UIControlStateNormal];		
		replyButton.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:replyButton];		
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}

- (void)dealloc 
{
	[replyButton release];
    [categoryImage release];
    [titleLabel release];
	[distanceLabel release];
	[bodyLabel release];
	[timeLabel release];
	[categoryLabel release];
    [post release];
    [super dealloc];
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
		
		// Toggle ReplyButton
		// If post is from the same user
		//DLog(@"%i %i", [[CasocialAppDelegate sharedAppDelegate] userId], [post.userId integerValue]);
		if ([[CasocialAppDelegate sharedAppDelegate] userId] == [post.userId integerValue]) {			
			replyButton.hidden = YES;
		} else {
			replyButton.hidden = NO;
		}
		
		titleLabel.frame = CGRectMake(64.0, 8.0, 250.0, 18.0);
		[titleLabel sizeToFit];
		
		bodyLabel.frame = CGRectMake(64.0, 8.0, 250.0, 12.0);
		[bodyLabel sizeToFit];
		CGRect frame = bodyLabel.frame;
		frame.origin.y += titleLabel.frame.size.height - 15; // 15 ist die font höhe, es wird immer eine leerzeile drangehangen?
		bodyLabel.frame = frame;
		
		// move reply button down
		CGFloat h;
		frame = CGRectMake(4.0, 84.0, 55.0, 30.0);
		if ( (h = bodyLabel.frame.origin.y + bodyLabel.frame.size.height) > 114.0 ) {
			frame.origin.y = bodyLabel.frame.origin.y + bodyLabel.frame.size.height - frame.size.height;
		}
		replyButton.frame = frame;
	}
}

- (CGFloat)cellHeight {
	CGFloat h;
	if ( (h = bodyLabel.frame.origin.y + bodyLabel.frame.size.height) > 114.0 ) {
		return h + 2;
	} 
	return 114.0;		
}

- (void)layoutSubviews
{
    [super layoutSubviews];
	
	

//	CGRect frame = bodyLabel.frame;
//	frame.size.width = titleLabel.size.width;
//	frame.origin.y += titleLabel.frame.size.height + 8;
//	bodyLabel.frame = frame;

}	

@end
