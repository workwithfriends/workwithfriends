//
//  SettingsViewController.h
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/5/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet FBLoginView *FBlogout;
@property (weak, nonatomic) IBOutlet UITextField *feedbackText;
- (IBAction)submit:(id)sender;


@end
