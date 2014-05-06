//
//  jobFormViewController.m
//  WorkWithFriends
//
//  Created by LUIS SANMIGUEL on 4/7/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import "JobFormViewController.h"
#import "RequestToServer.h"


@interface JobFormViewController ()

@end

@implementation JobFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (int *) rowSelected{
   return rowSelected;
}
- (void) setRowSelected: (int*) rowNumber{
    rowSelected=rowNumber;
}
- (NSDictionary*) job{
    return job;
}
- (void) setJob: (NSDictionary*) theJob{
    job=theJob;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    self.job = [globals.JOBPOSTS objectAtIndex: self.rowSelected];
    
    _skills.text = [[job valueForKey:@"skills"] objectAtIndex:0];
    _type.text = [job valueForKey:@"type"];
    _description.text =[NSString stringWithFormat:@"%@",[job valueForKey:@"description"]];
    _compensation.text = [job valueForKey:@"compensation"];
    _employerName.text = [NSString stringWithFormat:@"%@ %@", [job valueForKey:@"employerFirstName"], [job valueForKey:@"employerLastName"]];
    NSURL *profileURL = [NSURL URLWithString:[job valueForKey:@"employerProfileImageUrl"]];
    _employerPicture.image = [UIImage imageWithData: [NSData dataWithContentsOfURL: profileURL]];
    
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



- (IBAction)backButton:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)acceptButton:(id)sender {
    RequestToServer *acceptJobRequest = [[RequestToServer alloc] init];
    [acceptJobRequest setRequestType:@"takeJob"];
    [acceptJobRequest addParameter:@"jobId" withValue:[self.job valueForKey:@"jobId"]];
    [acceptJobRequest addParameter:@"employerId" withValue:[self.job valueForKey:@"employerId"]];
    NSDictionary *data=[acceptJobRequest makeRequest];
    if (data != [NSNull null]){
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end