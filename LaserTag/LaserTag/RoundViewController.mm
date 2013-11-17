//
//  RoundViewController.m
//  LaserTag
//
//  Created by Matthew on 11/16/13.
//  Copyright (c) 2013 Andrew Shim. All rights reserved.
//

#import "RoundViewController.h"
#import "RoundsViewController.h"
#import "LTViewController.h"
#import "LTAppDelegate.h"

@interface RoundViewController ()

@end

@implementation RoundViewController {
    int hours, minutes, seconds;
    int secondsLeft;
}

@synthesize roundJSON;
@synthesize myCounterLabel;
NSMutableArray* usersArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)render {
    //Get initial rounds
    NSString *roundName = [roundJSON objectForKey:@"roundName"];
    NSString *urlString = [NSString stringWithFormat:@"%@:%@/activeRounds/%@", LTAppDelegate.serverIP, LTAppDelegate.serverPort, roundName];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *urlResponse = nil;
    NSError *requestError;
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    roundJSON = [NSJSONSerialization JSONObjectWithData:response1 options:kNilOptions error:&requestError];
    usersArray = [roundJSON objectForKey:@"users"];
    [_tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self render];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString * roundName = [roundJSON objectForKey:@"roundName"];
    self.title = roundName;
    self.automaticallyAdjustsScrollViewInsets = NO;

    usersArray = [roundJSON objectForKey:@"users"];
    [self countdownTimer];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSInteger cancel = 0;
    NSInteger go = 1;
    NSLog(@"%d", buttonIndex);
    NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
    if(buttonIndex==cancel){
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:TRUE];
    }
    else if(buttonIndex==go){
        NSString *userName = [[alertView textFieldAtIndex:0] text];
        NSString *roundID = [roundJSON objectForKey:@"_id"];
        NSString * urlString = [NSString stringWithFormat:@"%@:%@/rounds/register/%@/%@", LTAppDelegate.serverIP, LTAppDelegate.serverPort, userName, roundID];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        
        NSHTTPURLResponse *urlResponse = [[NSHTTPURLResponse alloc] init];
        NSError *requestError;
        NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
        if (response1 !=  nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response1 options:kNilOptions error:&requestError];
            NSLog(@"response: %@\n", json);
            if ([urlResponse statusCode] == 200) {
                
                UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LTViewController *viewController = (LTViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LTViewController"];
                viewController.userName = userName;
                [viewController countdownTimer];
                [viewController setRoundJSON:json];
                [viewController setMyName:userName];
                [viewController setModalPresentationStyle:UIModalTransitionStyleCoverVertical];
                [self.navigationController pushViewController:viewController animated:YES];
            } else {
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Nope"
                                                                  message:@"Could not enter room"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                [message show];
            }
        }
    }
}


- (IBAction)enterRound:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Enter Username" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Go", nil];

    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    return [usersArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    // Set the data for this cell:
    
    NSDictionary* roundObject = [usersArray objectAtIndex:indexPath.row];
    NSString* userName = [roundObject objectForKey:@"name"];
    NSString* score = [roundObject objectForKey:@"score"];
    NSString* scoreString = [NSString stringWithFormat:@"Score: %@", score];
    cell.textLabel.text = userName;
    cell.detailTextLabel.text = scoreString;
    
    // set the accessory view:
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (void)updateCounter:(NSTimer *)theTimer {
    NSString *timeStartString = [roundJSON objectForKey:@"timeStart"];
    NSString *timeLimitString = [roundJSON objectForKey:@"duration"];
    NSDate *timeStart = [[NSDate alloc] initWithTimeIntervalSince1970:[timeStartString doubleValue]/1000];
    NSDate *timeNow = [NSDate date];
    NSTimeInterval diff = [timeNow timeIntervalSinceDate:timeStart]-500;
    
    secondsLeft = [timeLimitString intValue]/1000 - diff;
    if(secondsLeft > 0 ) {
        hours = secondsLeft / 3600;
        minutes = (secondsLeft % 3600) / 60;
        seconds = (secondsLeft % 3600) % 60;
        myCounterLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    }
}

-(void)countdownTimer{
    hours = minutes = seconds = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}

- (void)startCountdown:(CGFloat)millisecondsRemaining {
    if (millisecondsRemaining > 0) {
        secondsLeft = millisecondsRemaining;
        [self countdownTimer];
    } else {
        NSLog(@"Sorry the round ended");
    }
}


@end
