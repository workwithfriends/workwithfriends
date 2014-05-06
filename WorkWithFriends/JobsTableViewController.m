//
//  JobsTableViewController.m
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/5/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import "JobsTableViewController.h"
#import "RequestToServer.h"
#import "JobFormViewController.h"

@interface JobsTableViewController ()

@end

@implementation JobsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (NSInteger*) rowSelected{
    return rowSelected;
}

- (NSMutableDictionary*) profilePictures{
    return profilePictures;
}

- (void) setRowSelected:(NSInteger *) row{
    rowSelected=row;
}

- (void) setFriendPictures:(NSMutableDictionary *) pictures{
    profilePictures=pictures;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    RequestToServer *jobsRequest = [[RequestToServer alloc] init];
    [jobsRequest setRequestType:@"getPostedJobs"];
    [jobsRequest addParameter:@"query" withValue:@""];
    NSDictionary *data = [jobsRequest makeRequest];
    jobs= [data valueForKey:@"jobs"];
    jobStringList = [[NSMutableArray alloc] init];
    profilePictures = [[NSMutableDictionary alloc] init];
    for(NSDictionary *job in jobs){
        NSString *jobString=[NSString stringWithFormat: @"%@ needs a %@", [job valueForKey:@"employerFirstName"], [job valueForKey:@"type"]];
        [jobStringList addObject:jobString];
        [self.profilePictures setValue:[job valueForKey:@"employerProfileImageUrl"] forKey:jobString];

    }
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    globals.JOBPOSTS=jobs;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    

}

-(void)refresh {
    RequestToServer *jobsRequest = [[RequestToServer alloc] init];
    [jobsRequest setRequestType:@"getPostedJobs"];
    [jobsRequest addParameter:@"query" withValue:@""];
    NSDictionary *data = [jobsRequest makeRequest];
    jobs= [data valueForKey:@"jobs"];
    jobStringList = [[NSMutableArray alloc] init];
    for(NSDictionary *job in jobs){
        NSString *jobString=[NSString stringWithFormat: @"%@ needs a %@ who's good at %@", [job valueForKey:@"employerFirstName"], [job valueForKey:@"type"], [((NSArray*)[job valueForKey:@"skills"]) objectAtIndex:0]];
        [jobStringList addObject:jobString];
        
    }
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    globals.JOBPOSTS=jobs;
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [jobStringList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"jobCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    cell = [[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    // Configure the cell
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSString *cellValue = [searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = cellValue;
        cell.textLabel.font = [cell.textLabel.font fontWithSize:14.0];
        NSString *urlString=[self.profilePictures valueForKey:cellValue];
        NSURL *imageURL=[NSURL URLWithString:urlString];
        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    } else {
        NSString *cellValue = [jobStringList objectAtIndex:indexPath.row];
        cell.textLabel.text = cellValue;
        cell.textLabel.font = [cell.textLabel.font fontWithSize:14.0];
        NSString *urlString=[self.profilePictures valueForKey:cellValue];
        NSURL *imageURL=[NSURL URLWithString:urlString];
        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    }
    return cell;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    searchResults = [jobStringList filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.rowSelected=(NSInteger *)indexPath.row;
    [self performSegueWithIdentifier:@"jobDetails" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"preparing for segue: %@", segue.identifier);
    if ([[segue identifier] isEqualToString:@"jobDetails"]) {
        
        // Get destination view
        JobFormViewController *vc = [segue destinationViewController];
        NSLog(@"number is %d", (int) self.rowSelected);
        
        // Pass the information to your destination view
        [vc setRowSelected:((int) self.rowSelected)];
    }
}

@end
