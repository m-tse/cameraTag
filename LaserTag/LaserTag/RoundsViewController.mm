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
#import "LTAppDelegate.h"
#import "RoundCreateViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface RoundsViewController ()

@end

@implementation RoundsViewController

@synthesize ltViewController;

+ (SocketIO*) socketIO { return socketIO; }

static SocketIO * socketIO;

NSMutableArray* roundJSONArray;

- (void) vibrate {
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet{
    
    NSData* roundsJSONString = [packet.data dataUsingEncoding:NSUTF8StringEncoding];
    NSError *requestError;
    NSDictionary* JSON = [NSJSONSerialization JSONObjectWithData:roundsJSONString options:kNilOptions error:&requestError];
    NSString *eventType = [JSON objectForKey:@"name"];
    if([eventType  isEqual: @"resetActiveRounds"]){
        [self reRender];
    } else if ([eventType isEqualToString:@"sendHighestScoringUser"]) {
        if (ltViewController != nil) {
            NSArray *users = [JSON objectForKey:@"args"];
            NSDictionary *topUser = [users objectAtIndex:0];
            NSString *topName = [topUser objectForKey:@"name"];
            NSString *topScore = [NSString stringWithFormat:@"%@",[topUser objectForKey:@"score"]];
            [ltViewController setTopInfo:topName score:topScore];
        }
    } else if ([eventType isEqualToString:@"rumble"]) {
        if (ltViewController != nil) {
            NSArray *users = [JSON objectForKey:@"args"];
            NSDictionary *topUser = [users objectAtIndex:0];
            NSString *roundID = [topUser objectForKey:@"roundID"];
            NSString *username = [topUser objectForKey:@"username"];
            if ([username isEqualToString:[ltViewController myName]]) {
                [self vibrate];
            }
        }
    }
}
- (void) socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet
{
    NSLog(@"didReceiveMessage");
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    socketIO = [[SocketIO alloc] initWithDelegate:self];
    NSString* urlWithoutHTTP = [LTAppDelegate.serverIP substringFromIndex:7];
    [socketIO connectToHost:@"10.190.72.149" onPort:LTAppDelegate.serverPort.intValue];
    self.title = @"Active Rounds";
    self.automaticallyAdjustsScrollViewInsets = NO;
//    socketIO = [[SocketIO alloc] initWithDelegate:self];
//    [socketIO connectToHost:@"http://localhost" onPort:3000];
//    NSMutableDictionary *dirt = [NSMutableDictionary dictionary];
//    [socketIO sendEvent:@"getActiveRounds" withData:dict];
    

    
    //Get initial rounds
    [self reRender];
}
- (void) reRender
{
    //Get initial rounds
    NSString *urlString = [NSString stringWithFormat:@"%@:%@/activeRounds", LTAppDelegate.serverIP, LTAppDelegate.serverPort];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"%@\n", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *urlResponse = nil;
    NSError *requestError;
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    roundJSONArray = [NSJSONSerialization JSONObjectWithData:response1 options:kNilOptions error:&requestError];
}

- (void)viewWillAppear:(BOOL)animated {
    [self reRender];
    [_tableView reloadData];
    NSLog(@"rerendering");
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
    [controller setRoundsViewController:self];
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
    
    NSDictionary* roundObject = [roundJSONArray objectAtIndex:indexPath.row];
    NSString* roundName = [roundObject objectForKey:@"roundName"];

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

- (IBAction)createPressed:(id)sender {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RoundCreateViewController *viewController = (RoundCreateViewController *)[storyboard instantiateViewControllerWithIdentifier:@"RoundCreateViewController"];
    [viewController setRoundsViewController:self];
    [self.navigationController pushViewController:viewController animated:TRUE];
}

@end
