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
- (void) setRowSelected: (int*) rowNumber;
- (IBAction)backButton:(id)sender;
- (IBAction)acceptButton:(id)sender;
- (void) setJobForm: (int*) rowNumber;
@property (weak, nonatomic) IBOutlet UIImageView *employerPicture;
@property (weak, nonatomic) IBOutlet UILabel *employerName;
@property (weak, nonatomic) IBOutlet UILabel *skillsLabel;
@property (weak, nonatomic) IBOutlet UILabel *skills;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UILabel *compensationLabel;
@property (weak, nonatomic) IBOutlet UILabel *compensation;




@end
