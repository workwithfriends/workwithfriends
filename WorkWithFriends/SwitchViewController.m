//
//  SwitchViewController.m
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/8/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import "SwitchViewController.h"

@interface SwitchViewController ()

@end

@implementation SwitchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_jobTable setTableHolder:self];
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

- (IBAction)switchButton:(id)sender {
    switch ([sender selectedSegmentIndex]){
        case 0:
            _jobTable.hidden=NO;
            _skillsTable.hidden=YES;
            break;
        case 1:
            _jobTable.hidden=YES;
            _skillsTable.hidden=NO;
            break;
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"jobDetailsFromProfile"]) {
        
        // Get destination view
        JobFormViewController *vc = [segue destinationViewController];
        
        // Pass the information to your destination view
        [vc setRowSelected:((int *)_jobTable.rowSelected)];
    }
}
- (void) performSegueJobs{
    [self performSegueWithIdentifier:@"jobDetailsFromProfile" sender:self];
}
@end
