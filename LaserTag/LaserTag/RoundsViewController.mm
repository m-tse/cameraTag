//
//  RoundsViewController.mm
//  LaserTag
//
//  Created by Matthew on 11/16/13.
//  Copyright (c) 2013 Andrew Shim. All rights reserved.
//

#import "RoundsViewController.h"
#import "RoundViewController.h"
#import "SocketIO.h"
#import "SocketIOPacket.h"
#import "LTAppDelegate.h"

@interface RoundsViewController ()

@end

@implementation RoundsViewController



SocketIO * socketIO;
NSMutableArray* roundJSONArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet{
    
    NSLog(@"did receive event, data: %@", packet.data);
}
- (void) socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet
{
    NSLog(@"didReceiveMessage");
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Active Rounds";
    socketIO = [[SocketIO alloc] initWithDelegate:self];
    [socketIO connectToHost:LTAppDelegate.serverIP onPort:8080];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [socketIO sendEvent:@"getActiveRounds" withData:dict];
    
//    navigationController = [[UINavigationController alloc]initWithRootViewController:self];

    
    //Get initial rounds
    NSString *urlString = [NSString stringWithFormat:@"%@:%@/activeRounds", LTAppDelegate.serverIP, LTAppDelegate.serverPort];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *urlResponse = nil;
    NSError *requestError;
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    roundJSONArray = [NSJSONSerialization JSONObjectWithData:response1 options:kNilOptions error:&requestError];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* roundJSON = [roundJSONArray objectAtIndex:indexPath.row];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RoundViewController * controller = (RoundViewController *)[storyboard instantiateViewControllerWithIdentifier:@"roundViewController"];
    controller.roundJSON = roundJSON;
    [self.navigationController pushViewController:controller animated:TRUE];


}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    return [roundJSONArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    // Set the data for this cell:
    
//    cell.textLabel.text = [roundJSONArray objectAtIndex:indexPath.row];
    NSDictionary* roundObject = [roundJSONArray objectAtIndex:indexPath.row];
    NSString* roundName = [roundObject objectForKey:@"roundName"];
    NSLog(@"%@", roundObject);
    
    cell.textLabel.text = roundName;
    NSString* maxUsers = [roundObject objectForKey:@"maxUsers"];
    NSArray* usersArray = [roundObject objectForKey:@"users"];
    NSString* currentNumUsers = [NSString stringWithFormat:@"%d", [usersArray count]];
    NSString* currentUsersInfo = [NSString stringWithFormat:@"%@/%@", currentNumUsers, maxUsers];
    cell.detailTextLabel.text = currentUsersInfo;

    
    // set the accessory view:
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

@end
