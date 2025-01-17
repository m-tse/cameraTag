//
//  RoundCreateViewController.m
//  LaserTag
//
//  Created by Matthew on 11/17/13.
//  Copyright (c) 2013 Andrew Shim. All rights reserved.
//

#import "RoundCreateViewController.h"
#import "LTAppDelegate.h"
#import "LTViewController.h"

@interface RoundCreateViewController ()

@end

@implementation RoundCreateViewController {
    NSString *roundID;
}
@synthesize roundsViewController;


NSString* roundDuration= @"300000";
NSString* roundName=@"";

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
    self.title = @"Create a new Round";


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setRoundDuration:(UIDatePicker*)sender {
    NSInteger secondsToMili = sender.countDownDuration * 1000;
    roundDuration = [NSString stringWithFormat:@"%d",secondsToMili];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSInteger cancel = 0;
    NSInteger go = 1;

    if(buttonIndex==cancel){
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:TRUE];
    }
    else if(buttonIndex==go){
        NSString *userName = [[alertView textFieldAtIndex:0] text];
        NSString *markerID = [[alertView textFieldAtIndex:1] text];
        NSString * urlString = [NSString stringWithFormat:@"%@:%@/rounds/register/%@/%@/%@", LTAppDelegate.serverIP, LTAppDelegate.serverPort, userName, roundID, markerID];
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
                [roundsViewController setLtViewController:viewController];
                [self.navigationController pushViewController:viewController animated:TRUE];
                
                SocketIO *socket = [RoundsViewController socketIO];
                NSString* sendData = @"data";
                [socket sendEvent:@"createRound" withData:sendData];
                
                
                
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



- (IBAction)createRound:(id)sender {
    NSString* maxUsers = _numberContestantsField.text;
    if (maxUsers == nil) {
         UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Unable to create room"
                                                          message:@"Specify number of contestants"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        
    }
    NSLog(@"HELLO HERE");
    NSLog(roundDuration);
    NSString * urlString = [NSString stringWithFormat:@"%@:%@/rounds/create/%@/%@/%@", LTAppDelegate.serverIP, LTAppDelegate.serverPort, roundName, maxUsers, roundDuration];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse *urlResponse = [[NSHTTPURLResponse alloc] init];
    NSError *requestError;
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response1 options:kNilOptions error:&requestError];
    if ([urlResponse statusCode] == 200) {
        roundID = [json objectForKey:@"_id"];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Enter User Info" message:@"Room created" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Go", nil];
        
        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [[alert textFieldAtIndex:0] setPlaceholder:@"Username"];
        [[alert textFieldAtIndex:1] setPlaceholder:@"QR Marker ID"];
        [alert show];
        
        
        
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Unable to create room"
                                                          message:[NSString stringWithFormat:@"%@",[json objectForKey:@"error"]]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }

}

- (void)textFieldShouldEndEditing:(UITextField *)textField{
    roundName = textField.text;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

@end
