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
    
    SERVERURL=@"http://www.workwithfriends.dreamhosters.com:8000";
    //Get access Token:
    ACCESSTOCKEN = [[[FBSession activeSession] accessTokenData] accessToken];
    
    //Get User ID:
    [FBRequestConnection
     startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             USERID = [result objectForKey:@"id"];
         }
     }];
    
    //Make login request to server:
    NSString *urlForRequest = [SERVERURL stringByAppendingString:@"/loginWithFacebook/"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlForRequest];
    [request setPostValue:ACCESSTOCKEN forKey:@"accessToken"];
    [request setPostValue:USERID forKey:@"userId"];
    
    
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
