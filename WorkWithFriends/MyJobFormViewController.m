//
//  jobFormViewController.m
//  WorkWithFriends
//
//  Created by LUIS SANMIGUEL on 4/7/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import "MyJobFormViewController.h"
#import "RequestToServer.h"


@interface MyJobFormViewController ()

@end

@implementation MyJobFormViewController

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
- (int *) sectionSelected{
    return sectionSelected;
}
- (void) setSectionSelected: (int*) sectionNumber{
    sectionSelected=sectionNumber;
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
    NSArray *jobs;
    if (self.sectionSelected == 0) {
        jobs = [[globals.ME objectForKey:@"jobs"] objectForKey:@"currentJobsAsEmployer"];
        [_actionButton setTitle:@"Finish" forState:UIControlStateNormal];
    }
    else if (self.sectionSelected == 1){
        jobs = [[globals.ME objectForKey:@"jobs"] objectForKey:@"currentJobsAsEmployee"];
        [_actionButton setTitle:@"Pending" forState:UIControlStateNormal];
    }
    else if (self.sectionSelected == 2){
        jobs = [[globals.ME objectForKey:@"jobs"] objectForKey:@"postedJobs"];
        [_actionButton setTitle:@"Open" forState:UIControlStateNormal];
    }
    else if (self.sectionSelected == 3){
        jobs = [[globals.ME objectForKey:@"jobs"] objectForKey:@"completedJobsAsEmployee"];
        [_actionButton setTitle:@"Completed" forState:UIControlStateNormal];
    }
    else if (self.sectionSelected == 4){
        jobs = [[globals.ME objectForKey:@"jobs"] objectForKey:@"completedJobsAsEmployer"];
        [_actionButton setTitle:@"Completed" forState:UIControlStateNormal];
    }
    
    self.job = [jobs objectAtIndex: self.rowSelected];
    
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

- (IBAction)actionButton:(id)sender {
    if ([_actionButton.currentTitle isEqualToString:@"Finish"]) {
        RequestToServer *finishJobRequest = [[RequestToServer alloc] init];
        [finishJobRequest setRequestType:@"completeJob"];
        [finishJobRequest addParameter:@"jobId" withValue:[self.job valueForKey:@"jobId"]];
        NSDictionary *data=[finishJobRequest makeRequest];
        if (data != [NSNull null]){
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

@end