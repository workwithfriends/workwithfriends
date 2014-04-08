//
//  MyJobsTableView.m
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/8/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import "MyJobsTableView.h"

@implementation MyJobsTableView

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (NSMutableArray *) jobStringList{
    return jobStringList;
}
- (void) setJobStringList: (NSMutableArray *)stringList{
    jobStringList=stringList;
}
- (NSInteger *) rowSelected{
    return rowSelected;
}
- (void) setRowSelected: (NSInteger *)rowNumber{
    rowSelected=rowNumber;
}
/**
- (SwitchViewController *) tableHolder{
    return tableHolder;
}
- (void) setTableHolder: (SwitchViewController *)holder{
    //tableHolder = holder;
}
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Step 1");
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    NSArray *myCurrentJobsAsEmployer = [[globals.ME objectForKey:@"jobs"] objectForKey:@"currentJobsAsEmployer"];
    NSArray *myCurrentJobsAsEmployee = [[globals.ME objectForKey:@"jobs"] objectForKey:@"currentJobsAsEmployee"];
    NSArray *myCompletedJobs = [[globals.ME objectForKey:@"jobs"] objectForKey:@"completedJobs"];
    NSArray *myPostedJobs= [[globals.ME objectForKey:@"jobs"] objectForKey:@"postedJobs"];
    NSLog(@"Step 2");
    self.jobStringList = [[NSMutableArray alloc] init];
    NSLog(@"Step 3");
    if (myCurrentJobsAsEmployer != [NSNull null]){
        for(int i=0; i < [myCurrentJobsAsEmployer count];i++){
            NSString *jobString=[NSString stringWithFormat: @"You hired %@ as a %@", [[myCurrentJobsAsEmployer objectAtIndex: i] valueForKey:@"employeeFirstName"], [[myCurrentJobsAsEmployer objectAtIndex: i] valueForKey:@"type"]];
            [self.jobStringList addObject:jobString];
        }
    }
    NSLog(@"Step 5");
    if (myCurrentJobsAsEmployee != [NSNull null]){
        for(NSDictionary *job in myCurrentJobsAsEmployee){
            NSString *jobString=[NSString stringWithFormat: @"%@ hired you as a %@ !", [job valueForKey:@"employerFirstName"], [job valueForKey:@"type"]];
            [self.jobStringList addObject:jobString];
        }
    }
    if (myCompletedJobs != [NSNull null]){
        for(NSDictionary *job in myCompletedJobs){
            NSString *jobString=[NSString stringWithFormat: @"You have completed a job for %@", [job valueForKey:@"employerFirstName"]];
            [self.jobStringList addObject:jobString];
        }
    }
    if (myPostedJobs != [NSNull null]){
        for(NSDictionary *job in myPostedJobs){
            NSString *jobString=[NSString stringWithFormat: @"You need a %@ who's good at %@", [job valueForKey:@"type"], [[job valueForKey:@"skills"] objectAtIndex:0]];
            NSLog(@"%@",jobString);
            [self.jobStringList addObject:jobString];
        }
    }
    NSLog(@"This code has run succesfully");

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.jobStringList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"theJobCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    // Configure the cell
    NSString *cellValue = [self.jobStringList objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.rowSelected=(NSInteger *)indexPath.row;
    //[self.tableHolder performSegueJobs];
}

@end
