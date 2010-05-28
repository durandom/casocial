//
//  DetailCell.h
//  Casocial
//
//  Created by Marcel Hild on 15.06.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Post;

@interface DetailCell : UITableViewCell {
    Post *post;
    UIImageView *categoryImage;
    UILabel *titleLabel;
	UILabel *distanceLabel;
	UILabel *timeLabel;
	UILabel *bodyLabel;
	UILabel *categoryLabel;
	UIButton *replyButton;
}

@property (nonatomic, retain) Post *post;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *distanceLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *bodyLabel;
@property (nonatomic, retain) UILabel *categoryLabel;
@property (nonatomic, retain) UIButton *replyButton;

- (CGFloat)cellHeight;

@end
