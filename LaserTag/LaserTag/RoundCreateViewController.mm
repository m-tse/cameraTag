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
    NSLog(@"%d", secondsToMili);
    roundDuration = [NSString stringWithFormat:@"%d",secondsToMili];
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
                NSDate *now = [[NSDate alloc] init];
                NSTimeInterval timeInterval = [now timeIntervalSince1970] ;
                NSString *timeStartString = [json objectForKey:@"timeStart"];
                NSString *timeLimitString = [json objectForKey:@"duration"];
                CGFloat timeNow = [[NSNumber numberWithDouble:timeInterval] floatValue];
                CGFloat timeStart = (CGFloat)[timeStartString floatValue];
                CGFloat timeElapsed = timeNow - timeStart;
                CGFloat timeLimit = (CGFloat)[timeLimitString floatValue];
                CGFloat timeRemaining = timeLimit - timeElapsed;
                
                NSLog(@"Time remaining %f\n", timeRemaining);
                
                UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LTViewController *viewController = (LTViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LTViewController"];
                [viewController countdownTimer];
                [viewController setRoundJSON:json];
                [viewController setMyName:userName];
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
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Enter Username" message:@"Room created" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Go", nil];
        
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
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
