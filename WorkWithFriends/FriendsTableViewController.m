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
        // Custom initialization
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
    
    RequestToServer *friendsRequest = [[RequestToServer alloc] init];
    [friendsRequest setRequestType:@"getFriends"];
    NSDictionary *data = [friendsRequest makeRequest];
    NSLog(@"data object is :%@", data);
    friends = [data valueForKey:@"friends"];
    NSLog(@"friends object is :%@", friends);
    friendStringList = [[NSMutableArray alloc] init];
    for(NSDictionary *friend in friends){
        NSString *friendString=[NSString stringWithFormat: @"%@ %@", [friend valueForKey:@"friendFirstName"], [friend valueForKey:@"friendLastName"]];
        [friendStringList addObject:friendString];
        
    }
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    globals.FRIENDS = friends;
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
    return [friendStringList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friend" forIndexPath:indexPath];
    
    NSString *cellValue = [friendStringList objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"preparing for segue: %@", segue.identifier);
    if ([[segue identifier] isEqualToString:@"friendDetails"]) {
        
        // Get destination view
        FriendProfileViewController *vc = [segue destinationViewController];
        NSLog(@"number is %d", (int) self.rowSelected);
        
        // Pass the information to your destination view
        [vc setRowSelected:((int) self.rowSelected)];
    }
}


@end
