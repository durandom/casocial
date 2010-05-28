//
//  Definitions.h
//
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#   define DLog(...) NSLog(__VA_ARGS__)
#else
#   define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

// URLs
#ifdef URANDOM
#   define SERVER_NAME @"casocial.urandom.de"
#   define URL_SERVER @"http://casocial.urandom.de/"
#else
#   define SERVER_NAME @"192.168.1.165"
#   define URL_SERVER @"http://192.168.1.165:3000/"
#endif

#define URL_POSTS @"p"
#define URL_POST_CREATE @"posts"
#define URL_MESSAGES @"m"
#define URL_MESSAGE_CREATE @"messages"
#define URL_USER @"user"
#define URL_FEEDBACK @"feedbacks"

#define FETCH_DISTANCE 100000.0 // in meters

#define MAX_POSTS 100
#define MAX_POST_AGE -2678400 

#define TAG_TB_BROWSE_VIEW 100
#define TAG_TB_MESSAGE_VIEW 101
#define TAG_TB_POST_VIEW 102

#define V_KEYBOARD_HEIGHT 216.0
#define H_KEYBOARD_HEIGHT 162.0
#define BOTTOM_BAR_HEIGHT 49.0

#define VIEW_HEIGHT 367.0  // View with tab bar and navigation bar and status bar
#define VIEW_WIDTH  320.0

#define CAT_WANT 0
#define CAT_HAVE 1
#define CAT_OTHER 2


