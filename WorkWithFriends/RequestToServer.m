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
        [self setParameterDict];
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
- (void) setParameterDict{
    parameterDict = [[NSMutableDictionary alloc] init];
}
- (void) addParameter:(NSString *)key withValue:(NSObject *)value{
    [self.parameterDict setValue:value forKey:key];
}
-(NSDictionary*)makeRequest{
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    NSString *SERVERURL=@"http://www.workwithfriends.dreamhosters.com:8001/";
    SERVERURL = [[SERVERURL stringByAppendingString:self.requestType] stringByAppendingString:@"/"];
    //Get access Token:
    NSString *token;
    NSString *userID;
    if ([self.requestType isEqualToString:@"loginWithFacebook"]){
       token = [[[FBSession activeSession] accessTokenData] accessToken];
        globals.ACCESSTOKEN=token;
    }
    else{
        token = globals.ACCESSTOKEN;
        userID = [globals.ME valueForKey:@"userId"];
    }
    NSURL *urlForRequest = [NSURL URLWithString:SERVERURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlForRequest];
    [request setPostValue:token forKey:@"accessToken"];
    if (![self.requestType isEqualToString:@"loginWithFacebook"]){
        [request setPostValue:userID forKey:@"userId"];
    }
    NSArray *parameters = [self.parameterDict allKeys];
    for(int i=0;i < [parameters count];i++){
        NSString *theParameter = [parameters objectAtIndex:i];
        [request setPostValue:[self.parameterDict valueForKey:theParameter] forKey:theParameter];
    }
    [request setShouldUseRFC2616RedirectBehaviour:YES];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    if (![self.requestType isEqualToString:@"loginWithFacebook"]){
        [request startSynchronous];
    }
    else{
        [request startSynchronous];
    }
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        //NSLog(@"%@", response);
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
                NSString *errorMessage = [responseDict valueForKey:@"errorMessage"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Error"
                                                                message:errorMessage
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else{
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
