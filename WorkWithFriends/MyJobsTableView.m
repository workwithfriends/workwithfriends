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

- (NSMutableDictionary *) jobStringList{
    return jobStringList;
}
- (NSInteger *) sectionLength{
    return sectionLength;
}
- (void) setJobStringList: (NSMutableDictionary *)stringList{
    jobStringList=stringList;
}

- (NSInteger *) rowSelected{
    return rowSelected;
}
- (void) setRowSelected: (NSInteger *)rowNumber{
    rowSelected=rowNumber;
}

- (NSInteger *) sectionSelected{
    return sectionSelected;
}
- (void) setSectionSelected: (NSInteger *)sectionNumber{
    sectionSelected=sectionNumber;
}

-(void)refresh {
    RequestToServer *getMyJobsRequest = [[RequestToServer alloc] init];
    [getMyJobsRequest setRequestType:@"getMyJobs"];
    NSDictionary *data = [getMyJobsRequest makeRequest];
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    [globals.ME setValue:[data valueForKey:@"myJobs"] forKey:@"jobs"];
    [self populateTable];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self populateTable];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void) populateTable {
    self.jobStringList=[[NSMutableDictionary alloc]init];
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    NSArray *myCurrentJobsAsEmployer = [[globals.ME objectForKey:@"jobs"] objectForKey:@"currentJobsAsEmployer"];
    NSArray *myCurrentJobsAsEmployee = [[globals.ME objectForKey:@"jobs"] objectForKey:@"currentJobsAsEmployee"];
    NSArray *myCompletedJobsAsEmployee = [[globals.ME objectForKey:@"jobs"] objectForKey:@"completedJobsAsEmployee"];
    NSArray *myCompletedJobsAsEmployer = [[globals.ME objectForKey:@"jobs"] objectForKey:@"completedJobsAsEmployer"];
    NSArray *myPostedJobs= [[globals.ME objectForKey:@"jobs"] objectForKey:@"postedJobs"];
    
    if (myCurrentJobsAsEmployer != [NSNull null]){
        NSMutableArray *theJobStringList = [[NSMutableArray alloc] init];
        for(NSDictionary *job in myCurrentJobsAsEmployer){
            NSString *jobString=[NSString stringWithFormat: @"You hired %@ as a %@", [job valueForKey:@"employeeFirstName"], [job valueForKey:@"type"]];
            [theJobStringList addObject:jobString];
        }
        self.sectionLength[0]=[myCurrentJobsAsEmployer count];
        [self.jobStringList setValue:theJobStringList forKey:@"0"];
    }
    if (myCurrentJobsAsEmployee != [NSNull null]){
        NSMutableArray *theJobStringList = [[NSMutableArray alloc] init];
        for(NSDictionary *job in myCurrentJobsAsEmployee){
            NSString *jobString=[NSString stringWithFormat: @"%@ hired you as a %@ !", [job valueForKey:@"employerFirstName"], [job valueForKey:@"type"]];
            [theJobStringList addObject:jobString];
        }
        self.sectionLength[1]=[myCurrentJobsAsEmployee count];
        [self.jobStringList setValue:theJobStringList forKey:@"1"];
    }
    if (myPostedJobs != [NSNull null]){
        NSMutableArray *theJobStringList = [[NSMutableArray alloc] init];
        for(NSDictionary *job in myPostedJobs){
            NSString *jobString=[NSString stringWithFormat: @"You need a %@", [job valueForKey:@"type"]];
            [theJobStringList addObject:jobString];
        }
        self.sectionLength[2]=[myPostedJobs count];
        [self.jobStringList setValue:theJobStringList forKey:@"2"];
    }
    if (myCompletedJobsAsEmployee != [NSNull null]){
        NSMutableArray *theJobStringList = [[NSMutableArray alloc] init];
        for(NSDictionary *job in myCompletedJobsAsEmployee){
            NSString *jobString=[NSString stringWithFormat: @"You have completed a job for %@", [job valueForKey:@"employerFirstName"]];
            [theJobStringList addObject:jobString];
        }
        self.sectionLength[3]=[myCompletedJobsAsEmployee count];
        [self.jobStringList setValue:theJobStringList forKey:@"3"];
    }
    if (myCompletedJobsAsEmployer != [NSNull null]){
        NSMutableArray *theJobStringList = [[NSMutableArray alloc] init];
        for(NSDictionary *job in myCompletedJobsAsEmployer){
            NSString *jobString=[NSString stringWithFormat: @"%@ completed a job for you", [job valueForKey:@"employeeFirstName"]];
            [theJobStringList addObject:jobString];
        }
        self.sectionLength[4]=[myCompletedJobsAsEmployer count];
        [self.jobStringList setValue:theJobStringList forKey:@"4"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"jobCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    // Configure the cell
    NSArray *array=[self.jobStringList objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]];
    NSString *cellValue = [array objectAtIndex :indexPath.row];
    cell.textLabel.text = cellValue;
    
    return cell;
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0)
        return @"Current jobs as employer";
    else if(section==1)
        return @"Current jobs as employee";
    else if(section==2)
        return @"My posted jobs";
    else if(section==3)
        return @"Completed jobs as employee";
    else if(section==4)
        return @"Completed jobs as employer";
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sectionLength[section];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.rowSelected=(NSInteger *)indexPath.row;
    self.sectionSelected = (NSInteger *) indexPath.section;
    [self performSegueWithIdentifier:@"jobDetails" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"preparing for segue: %@", segue.identifier);
    if ([[segue identifier] isEqualToString:@"jobDetails"]) {
        
        // Get destination view
        MyJobFormViewController *vc = [segue destinationViewController];
        NSLog(@"number is %d", (int) self.rowSelected);
        
        // Pass the information to your destination view
        [vc setRowSelected:((int) self.rowSelected)];
        [vc setSectionSelected:((int) self.sectionSelected)];
    }
}
@end
