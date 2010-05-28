//
//  ReplyButton.h
//  Casocial
//
//  Created by Marcel Hild on 19.06.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Message;

@interface ReplyButton : UIButton {
	Message* message;
}

@property (nonatomic, assign) Message* message;

@end
