//
//  jobFormViewController.h
//  WorkWithFriends
//
//  Created by LUIS SANMIGUEL on 4/7/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h"

@interface JobFormViewController : UIViewController
{
    NSDictionary *job;
    int *rowSelected;
}
- (int*) rowSelected;
- (NSDictionary*) job;
- (void) setJob: (NSDictionary*) job;
- (void) setRowSelected: (int*) rowNumber;
- (IBAction)backButton:(id)sender;
- (IBAction)acceptButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *employerPicture;
@property (weak, nonatomic) IBOutlet UILabel *skillsLabel;
@property (weak, nonatomic) IBOutlet UITextView *description;
@property (weak, nonatomic) IBOutlet UILabel *compensationLabel;
@property (weak, nonatomic) IBOutlet UITextView *compensation;
@property (weak, nonatomic) IBOutlet UITextView *skills;
@property (weak, nonatomic) IBOutlet UITextView *employerName;




@end
