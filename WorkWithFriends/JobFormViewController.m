//
//  JobFormViewController.m
//  WorkWithFriends
//
//  Created by LUIS SANMIGUEL on 4/6/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import "JobFormViewController.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
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


- (IBAction)AcceptButton:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goBack:(id)sender {

    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
