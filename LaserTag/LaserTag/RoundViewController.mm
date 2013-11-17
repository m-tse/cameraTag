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

@implementation RoundViewController
@synthesize roundJSON;
NSMutableArray* usersArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString * roundName = [roundJSON objectForKey:@"roundName"];
    self.title = roundName;
    usersArray = [roundJSON objectForKey:@"users"];
    

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
            NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:response1 options:kNilOptions error:&requestError];
            NSLog(@"response: %@\n", jsonArray);
            if ([urlResponse statusCode] == 200) {
                UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LTViewController *viewController = (LTViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LTViewController"];
                [viewController setModalPresentationStyle:UIModalTransitionStyleCoverVertical];
                [self presentViewController:viewController animated:YES completion:nil];
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

@end
