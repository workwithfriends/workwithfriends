//
//  LoginViewController.h
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/5/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ASIFormDataRequest.h"


//extern NSString *USERFIRSTNAME;
//extern NSString *USERLASTNAME;
//extern NSString *PROFILEPICTURE;
//extern NSString *ACCESSTOCKEN;
//extern NSString *USERID;
//extern NSString *SERVERURL;
@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet FBLoginView *FBLogin;

@end
