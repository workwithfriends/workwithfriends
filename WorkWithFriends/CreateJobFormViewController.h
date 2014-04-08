//
//  CreateJobFormViewController.h
//  WorkWithFriends
//
//  Created by LUIS SANMIGUEL on 4/8/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateJobFormViewController : UIViewController
- (IBAction)postButton:(id)sender;
- (IBAction)cancelButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *myProfilePicture;
@property (weak, nonatomic) IBOutlet UITextView *myName;
@property (weak, nonatomic) IBOutlet UILabel *skillsLabel;
@property (weak, nonatomic) IBOutlet UITextView *skills;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UITextView *type;

@property (weak, nonatomic) IBOutlet UITextView *compensation;
@property (weak, nonatomic) IBOutlet UILabel *compensationLabel;
@property (weak, nonatomic) IBOutlet UITextView *description;
@end
