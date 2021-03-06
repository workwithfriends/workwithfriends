//
//  GlobalVariables.h
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/7/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalVariables : NSObject
{
    NSString *_ACCESSTOKEN;
    NSMutableDictionary *_ME;
    NSArray *_JOBPOSTS;
    NSArray *_FRIENDS;
}

+ (GlobalVariables *)sharedInstance;

@property(strong, nonatomic, readwrite) NSMutableDictionary *ME;

@property(strong, nonatomic, readwrite) NSString *ACCESSTOKEN;

@property(strong, nonatomic, readwrite) NSArray *JOBPOSTS;

@property(strong, nonatomic, readwrite) NSArray *FRIENDS;

@end
