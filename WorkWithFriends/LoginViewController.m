//
//  LoginViewController.m
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/5/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

// Logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
    NSString *SERVERURL=@"http://www.workwithfriends.dreamhosters.com:8000/loginWithFacebook/";
    //Get access Token:
    //NSString *ACCESSTOKEN = [[[FBSession activeSession] accessTokenData] accessToken];
    
    //Get User ID:
    NSString *USERID = @"";
    [FBRequestConnection
     startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSString *USERID = [result objectForKey:@"id"];
         }
     }];
    
    //Make login request to server:
    NSURL *urlForRequest = [NSURL URLWithString:SERVERURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlForRequest];
    //ACCESSTOKEN
    [request setPostValue:@"" forKey:@"accessToken"];
    [request setPostValue:USERID forKey:@"userId"];
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


    [self performSegueWithIdentifier:@"login_success" sender:self];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
