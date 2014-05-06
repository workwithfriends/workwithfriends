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
<<<<<<< HEAD
- (id) initWithCoder:(NSCoder *) coder{
    self = [super initWithCoder:coder];
    if (self) {
        RequestToServer *friendsRequest = [[RequestToServer alloc] init];
        [friendsRequest setRequestType:@"getFriends"];
        NSDictionary *data = [friendsRequest makeRequest];
        friends = [data valueForKey:@"friends"];
        GlobalVariables *globals = [GlobalVariables sharedInstance];
        globals.FRIENDS = friends;
    }
    return self;
}

- (NSInteger*) friendSelected{
    return friendSelected;
=======
/*
RequestToServer *friendsRequest = [[RequestToServer alloc] init];
[friendsRequest setRequestType:@"getFriends"];
NSDictionary *data = [friendsRequest makeRequest];
friends = [data valueForKey:@"friends"];
GlobalVariables *globals = [GlobalVariables sharedInstance];
globals.FRIENDS = friends;
 
 */
- (NSInteger*) rowSelected{
    return rowSelected;
>>>>>>> 2e279bd177e5340f8c42dc7bc16e2639c8f898c5
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

- (void) setFriendSelected:(NSInteger *) friend{
    friendSelected=friend;
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
    GlobalVariables *globals = [GlobalVariables sharedInstance];
<<<<<<< HEAD
    NSArray *friends=globals.FRIENDS;
    friendToID = [[NSMutableDictionary alloc] init];
=======
    RequestToServer *friendsRequest = [[RequestToServer alloc] init];
    [friendsRequest setRequestType:@"getFriends"];
    NSDictionary *data = [friendsRequest makeRequest];
    friends = [data valueForKey:@"friends"];
    globals.FRIENDS = friends;
>>>>>>> 2e279bd177e5340f8c42dc7bc16e2639c8f898c5
    self.friendPictures=[[NSMutableDictionary alloc ]init];
    friendStringList = [[NSMutableArray alloc] init];
    for(NSDictionary *friend in friends){
        
        NSString *friendString=[NSString stringWithFormat: @"%@ %@", [friend valueForKey:@"friendFirstName"], [friend valueForKey:@"friendLastName"]];
        [friendStringList addObject:friendString];
        [friendToID setValue:[friend objectForKey:@"friendId"] forKey:friendString];
        [self.friendPictures setValue:[friend valueForKey:@"friendProfileImageUrl"] forKey:friendString];
        
    }
    self.friendStringListSorted=[friendStringList sortedArrayUsingSelector:
                                 @selector(localizedCaseInsensitiveCompare:)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    NSString *urlString=[self.friendPictures valueForKey:cellTextName];
    NSURL *imageURL=[NSURL URLWithString:urlString];
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    cell.tag=[[friendToID valueForKey:cellTextName] intValue];
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
<<<<<<< HEAD
    UITableViewCell *theCell = (UITableViewCell *)[(UITableView *)self.view cellForRowAtIndexPath:indexPath];
    self.friendSelected=(NSInteger*)theCell.tag;
=======
    self.rowSelected=(NSInteger *)indexPath.row;
>>>>>>> 2e279bd177e5340f8c42dc7bc16e2639c8f898c5
    [self performSegueWithIdentifier:@"friendDetails" sender:self];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"friendDetails"]) {
        
        // Get destination view
        FriendProfileViewController *vc = [segue destinationViewController];
<<<<<<< HEAD
        [vc setFriendID:self.friendSelected];
=======
        
        // Pass the information to your destination view
        [vc setRowSelected:((int) self.rowSelected)];
        NSLog(@"The row selected was %d", self.rowSelected);

>>>>>>> 2e279bd177e5340f8c42dc7bc16e2639c8f898c5
    }
}


@end
