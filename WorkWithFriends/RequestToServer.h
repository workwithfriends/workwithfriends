//
//  RequestToServer.h
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/7/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ASIFormDataRequest.h"
#import "GlobalVariables.h"

@interface RequestToServer : NSObject
{
    NSString* requestType;

}

- (NSString*) requestType;
- (void) setRequestType:(NSString*) type;

- (NSDictionary*) makeRequest;

@end
