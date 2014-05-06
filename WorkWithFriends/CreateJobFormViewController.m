//
//  CreateJobFormViewController.m
//  WorkWithFriends
//
//  Created by LUIS SANMIGUEL on 4/8/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import "CreateJobFormViewController.h"
#import "GlobalVariables.h"
#import "RequestToServer.h"

@interface CreateJobFormViewController ()

@end

@implementation CreateJobFormViewController

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
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    _myName.text = [NSString stringWithFormat:@"%@ %@",[globals.ME valueForKey: @"firstName"],[globals.ME valueForKey: @"lastName"]];
    [_myName setFont:[_myName.font fontWithSize:20]];
    NSURL *profileURL = [NSURL URLWithString:[globals.ME valueForKey:@"profileImageUrl"]];
    _myProfilePicture.image = [UIImage imageWithData: [NSData dataWithContentsOfURL: profileURL]];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_type resignFirstResponder];
    [_skills resignFirstResponder];
    [_description resignFirstResponder];
    [_compensation resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_type resignFirstResponder];
    [_skills resignFirstResponder];
    [_description resignFirstResponder];
    [_compensation resignFirstResponder];
    
    return YES;
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

- (IBAction)postButton:(id)sender {
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    RequestToServer *postJobRequest = [[RequestToServer alloc] init];
    NSMutableDictionary *job = [[NSMutableDictionary alloc] init];
    [job setObject:_type.text forKey:@"type"];
    [job setObject:_description.text forKey:@"description"];
    [job setObject:_compensation.text forKey:@"compensation"];
    NSMutableArray *skillsArray = [[NSMutableArray alloc] init];
    [skillsArray addObject:_skills.text];
    [job setObject:skillsArray forKey:@"skills"];

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:job
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSLog([[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
    [postJobRequest setRequestType:@"postJob"];
    [postJobRequest addParameter:@"job" withValue: [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    NSDictionary *data = [postJobRequest makeRequest];
    if ([[job valueForKey:@"description"] isEqualToString :_description.text]){
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)cancelButton:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
    
@end