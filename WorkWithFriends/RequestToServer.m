//
//  RequestToServer.m
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/7/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import "RequestToServer.h"

@implementation RequestToServer

- (id) init
{
    if ( self = [super init] )
    {
    }
    return self;
}
- (NSString*) requestType{
  return requestType;
}
- (NSMutableDictionary*) parameterDict{
    return parameterDict;
}
- (void) setRequestType: (NSString*) type {
    requestType = type;
}
- (void) addParameter:(NSString *)parameterName:(NSString *)parameterData{
    [self.parameterDict setObject:parameterData forKey:parameterData];
}
-(NSDictionary*)makeRequest{
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    NSString *SERVERURL=@"http://www.workwithfriends.dreamhosters.com:8000/";
    SERVERURL = [[SERVERURL stringByAppendingString:self.requestType] stringByAppendingString:@"/"];
    NSLog(@"Yes we do get here");
    //Get access Token:
    NSString *token;
    NSString *userID;
    if ([self.requestType isEqualToString:@"loginWithFacebook"]){
       token = [[[FBSession activeSession] accessTokenData] accessToken];
        globals.ACCESSTOKEN=token;
    }
    else{
        token = globals.ACCESSTOKEN;
        userID = [globals.ME valueForKey:@"userID"];
    }
    NSURL *urlForRequest = [NSURL URLWithString:SERVERURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlForRequest];
    [request setPostValue:token forKey:@"accessToken"];
    if (![self.requestType isEqualToString:@"loginWithFacebook"]){
        [request setPostValue:userID forKey:@"userID"];
    }
    for(id key in self.parameterDict){
        [request setPostValue:[self.parameterDict objectForKey:key] forKey:key];
    }
    [request setShouldUseRFC2616RedirectBehaviour:YES];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@", response);
        NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (responseDict == NULL){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Error"
                                                            message:@"An unexpected response was received from our server."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else{
            BOOL err = [[responseDict valueForKey:@"isError"] boolValue];
            if (err){
                NSString *errorMessage = [[responseDict valueForKey:@"errorMessage"] stringValue];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Error"
                                                                message:errorMessage
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            }
            else{
                NSLog(@"Success! Now returning the responseDict");
                return [responseDict valueForKey:@"data"];
            }
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Error"
                                                        message:@"An unexpected error was encoutered while communicating with our sever."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    return NULL;
}
@end
