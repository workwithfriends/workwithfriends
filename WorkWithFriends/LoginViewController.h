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




@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet FBLoginView *FBLogin;

@end
