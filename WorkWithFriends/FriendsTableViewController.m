//
//  FriendsTableViewController.m
//  WorkWithFriends
//
//  Created by LUIS SANMIGUEL on 4/7/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "RequestToServer.h"
#import "FriendProfileViewController.h"

@interface FriendsTableViewController ()

@end

@implementation FriendsTableViewController

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

- (NSArray*) friendStringListSorted{
    return friendStringListSorted;
}

- (NSArray*) friendStringList{
    return friendStringList;
}

- (NSMutableDictionary*) friendPictures{
    return friendPictures;
}

- (void) setRowSelected:(NSInteger *) row{
    rowSelected=row;
}

- (void) setFriendStringListSorted:(NSArray *) array{
    friendStringListSorted=array;
}

- (void) setFriendStringList:(NSArray *) array{
    friendStringList=array;
}

- (void) setFriendPictures:(NSMutableDictionary *) pictures{
    friendPictures=pictures;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refresh];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
}
- (void) refresh{
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    RequestToServer *friendsRequest = [[RequestToServer alloc] init];
    [friendsRequest setRequestType:@"getFriends"];
    NSDictionary *data = [friendsRequest makeRequest];
    friends = [data valueForKey:@"friends"];
    globals.FRIENDS = friends;
    self.friendPictures=[[NSMutableDictionary alloc ]init];
    friendStringList = [[NSMutableArray alloc] init];
    for(NSDictionary *friend in friends){
        NSString *friendString=[NSString stringWithFormat: @"%@ %@", [friend valueForKey:@"friendFirstName"], [friend valueForKey:@"friendLastName"]];
        [friendStringList addObject:friendString];
        [self.friendPictures setValue:[friend valueForKey:@"friendProfileImageUrl"] forKey:friendString];
        
    }
    self.friendStringListSorted=[friendStringList sortedArrayUsingSelector:
                                 @selector(localizedCaseInsensitiveCompare:)];
    [self.tableView setDelegate:self];
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
    return [self.friendStringListSorted count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friend" forIndexPath:indexPath];
    
    NSString *cellTextName= [self.friendStringList objectAtIndex:indexPath.row];
    cell.textLabel.text = cellTextName;
    cell.textLabel.font = [cell.textLabel.font fontWithSize:14.0];
    NSString *urlString=[self.friendPictures valueForKey:cellTextName];
    NSURL *imageURL=[NSURL URLWithString:urlString];
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    // Configure the cell...
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 56;
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.rowSelected=(NSInteger *)indexPath.row;
    [self performSegueWithIdentifier:@"friendDetails" sender:self];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"friendDetails"]) {
        
        // Get destination view
        FriendProfileViewController *vc = [segue destinationViewController];
        
        // Pass the information to your destination view
        [vc setRowSelected:((int) self.rowSelected)];
        NSLog(@"The row selected was %d", self.rowSelected);

    }
}


@end

