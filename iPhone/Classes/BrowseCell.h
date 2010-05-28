//
//  BrowseCell.h
//  Casocial
//
//  Created by Marcel on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@class Post;

@interface BrowseCell : UITableViewCell {
@private
    UILabel *titleLabel;
    Post *post;
    UIImageView *categoryImage;
	UILabel *distanceLabel;
	UILabel *timeLabel;
	UILabel *bodyLabel;
	UIButton *badge;
}

@property (nonatomic, retain) Post *post;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *distanceLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *bodyLabel;
@property (nonatomic, retain) UIButton *badge;

//- (void)loadImage;
//- (void)toggleImage;

@end
