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
    NSDictionary *_ME;
}

+ (GlobalVariables *)sharedInstance;

@property(strong, nonatomic, readwrite) NSDictionary *ME;

@property(strong, nonatomic, readwrite) NSString *ACCESSTOKEN;

@end
