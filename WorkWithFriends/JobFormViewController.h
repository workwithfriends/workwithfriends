//
//  JobFormViewController.h
//  WorkWithFriends
//
//  Created by LUIS SANMIGUEL on 4/6/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobFormViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *EmployerLabel;
@property (weak, nonatomic) IBOutlet UILabel *JobTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *SkillsLabel;
@property (weak, nonatomic) IBOutlet UILabel *CompensationLabel;


- (IBAction)AcceptButton:(id)sender;
- (IBAction)goBack:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *employer;
@property (weak, nonatomic) IBOutlet UILabel *jobType;
@property (weak, nonatomic) IBOutlet UILabel *skills;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end
