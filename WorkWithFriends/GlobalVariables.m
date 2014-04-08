//
//  GlobalVariables.m
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/7/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import "GlobalVariables.h"

@implementation GlobalVariables

@synthesize ME = _ME;
@synthesize ACCESSTOKEN= _ACCESSTOKEN;
@synthesize JOBPOSTS= _JOBPOSTS;

+ (GlobalVariables *)sharedInstance {
    static dispatch_once_t onceToken;
    static GlobalVariables *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[GlobalVariables alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _ME = [[NSMutableDictionary alloc] init];
        _ACCESSTOKEN = [[NSString alloc] init];
        _JOBPOSTS = [[NSArray alloc] init];
    }
    return self;
}
@end
