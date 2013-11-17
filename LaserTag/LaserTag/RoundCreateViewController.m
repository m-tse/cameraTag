//
//  RoundCreateViewController.m
//  LaserTag
//
//  Created by Matthew on 11/17/13.
//  Copyright (c) 2013 Andrew Shim. All rights reserved.
//

#import "RoundCreateViewController.h"
#import "LTAppDelegate.h"

@interface RoundCreateViewController ()

@end

@implementation RoundCreateViewController
NSString* roundDuration= @"300";
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
    roundDuration = [NSString stringWithFormat:@"%f",sender.countDownDuration];
}

- (IBAction)createRound:(id)sender {
    NSString* maxUsers = @"5";
    NSString * urlString = [NSString stringWithFormat:@"%@:%@/rounds/create/%@/%@/%@", LTAppDelegate.serverIP, LTAppDelegate.serverPort, roundName, maxUsers, roundDuration];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse *urlResponse = [[NSHTTPURLResponse alloc] init];
    NSError *requestError;
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];

}

- (void)textFieldShouldEndEditing:(UITextField *)textField{
    roundName = textField.text;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

@end
