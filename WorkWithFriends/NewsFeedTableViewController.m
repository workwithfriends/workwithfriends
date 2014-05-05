//
//  NewsFeedTableViewController.m
//  WorkWithFriends
//
//  Created by LUIS SANMIGUEL on 4/7/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//


#import "NewsFeedTableViewController.h"
#import "RequestToServer.h"

@interface NewsFeedTableViewController ()

@end

@implementation NewsFeedTableViewController

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
- (void) setRowSelected:(NSInteger *) row{
    rowSelected=row;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    RequestToServer *newsFeedRequest = [[RequestToServer alloc] init];
    [newsFeedRequest setRequestType:@"getNewsfeed"];
    NSDictionary *data = [newsFeedRequest makeRequest];
    newsfeedItems = [data valueForKey:@"newsfeed"];
    newsfeedItemsStringList = [[NSMutableArray alloc] init];
    newsfeedPictures = [[NSMutableArray alloc] init];
    for(NSDictionary *newsfeedItem in newsfeedItems){
        NSString *type = [newsfeedItem valueForKey:@"newsfeedItemType"];
        NSString *newsfeedItemString;
        NSString *fullName = [NSString stringWithFormat:@"%@ %@", [newsfeedItem valueForKey:@"userFirstName"], [newsfeedItem valueForKey:@"userLastName"]];
        if ([type isEqualToString:@"postedJob"]) {
            newsfeedItemString = [NSString stringWithFormat: @"%@ posted a job.", fullName];
            [newsfeedItemsStringList addObject:newsfeedItemString];
            [newsfeedPictures addObject: [newsfeedItem valueForKey:@"profileImageUrl"]];
        }
        else if ([type isEqualToString:@"completedJob"]) {
            newsfeedItemString = [NSString stringWithFormat: @"%@ completed a job.", fullName];
            [newsfeedItemsStringList addObject:newsfeedItemString];
            [newsfeedPictures addObject: [newsfeedItem valueForKey:@"profileImageUrl"]];
        }
        else if ([type isEqualToString:@"updatedAboutMe"]) {
            newsfeedItemString = [NSString stringWithFormat: @"%@ updated his about me.", fullName];
            [newsfeedItemsStringList addObject:newsfeedItemString];
            [newsfeedPictures addObject: [newsfeedItem valueForKey:@"profileImageUrl"]];
        }
    }
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    
}

-(void)refresh {
    NSLog(@"Yay Refreshed");
    RequestToServer *newsFeedRequest = [[RequestToServer alloc] init];
    [newsFeedRequest setRequestType:@"getNewsfeed"];
    NSDictionary *data = [newsFeedRequest makeRequest];
    newsfeedItems = [data valueForKey:@"newsfeed"];
    newsfeedItemsStringList = [[NSMutableArray alloc] init];
    newsfeedPictures = [[NSMutableArray alloc] init];
    for(NSDictionary *newsfeedItem in newsfeedItems){
        NSString *type = [newsfeedItem valueForKey:@"newsfeedItemType"];
        NSString *newsfeedItemString;
        NSString *fullName = [NSString stringWithFormat:@"%@ %@", [newsfeedItem valueForKey:@"userFirstName"], [newsfeedItem valueForKey:@"userLastName"]];
        if ([type isEqualToString:@"postedJob"]) {
            newsfeedItemString = [NSString stringWithFormat: @"%@ posted a job.", fullName];
            [newsfeedItemsStringList addObject:newsfeedItemString];
            [newsfeedPictures addObject: [newsfeedItem valueForKey:@"profileImageUrl"]];
        }
        else if ([type isEqualToString:@"completedJob"]) {
            newsfeedItemString = [NSString stringWithFormat: @"%@ completed a job.", fullName];
            [newsfeedItemsStringList addObject:newsfeedItemString];
            [newsfeedPictures addObject: [newsfeedItem valueForKey:@"profileImageUrl"]];
        }
        else if ([type isEqualToString:@"updatedAboutMe"]) {
            newsfeedItemString = [NSString stringWithFormat: @"%@ updated his about me.", fullName];
            [newsfeedItemsStringList addObject:newsfeedItemString];
            [newsfeedPictures addObject: [newsfeedItem valueForKey:@"profileImageUrl"]];
        }
    }
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
    return [newsfeedItemsStringList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsfeedItem" forIndexPath:indexPath];
    
    NSString *cellTextName= [newsfeedItemsStringList objectAtIndex:indexPath.row];
    cell.textLabel.text = cellTextName;
    cell.textLabel.font = [cell.textLabel.font fontWithSize:12.0];
    
    NSString *urlString=[newsfeedPictures objectAtIndex:indexPath.row];
    NSURL *imageURL=[NSURL URLWithString:urlString];
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    // Configure the cell...
    return cell;
}



@end
