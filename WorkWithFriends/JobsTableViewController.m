//
//  JobsTableViewController.m
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/5/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import "JobsTableViewController.h"
#import "RequestToServer.h"
@interface JobsTableViewController ()

@end

@implementation JobsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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
    for(NSDictionary *job in jobs){
        NSString *jobString=[NSString stringWithFormat: @"%@ needs a %@ who's good at %@", [job valueForKey:@"employerFirstName"], [job valueForKey:@"type"], [((NSArray*)[job valueForKey:@"skills"]) objectAtIndex:1]];
        [jobStringList addObject:jobString];
    }
    

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
    // Configuration de la cellule
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSString *cellValue = [searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = cellValue;
    } else {
        NSString *cellValue = [jobStringList objectAtIndex:indexPath.row];
        cell.textLabel.text = cellValue;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"jobDetails" sender:self];
    
}

@end
