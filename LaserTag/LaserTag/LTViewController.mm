//
//  LTViewController.m
//  LaserTag
//
//  Created by Andrew Shim on 11/16/13.
//  Copyright (c) 2013 Andrew Shim. All rights reserved.
//

#import "LTViewController.h"
#import "LaserParticleSystemView.h"
#import <QuartzCore/QuartzCore.h>
#import "RoundsViewController.h"
#import "LTAppDelegate.h"
#import "RoundResultsViewController.h"
#import "SocketIO.h"

@interface LTViewController ()

@end

@implementation LTViewController {
    float _curRed;
    BOOL _increasing;
    GLKView *gView;
    GLfloat _zTranslate;
    NSArray *laserShots;
    int hours, minutes, seconds;
    int secondsLeft;
}

@synthesize myCounterLabel;
@synthesize roundJSON;

#pragma mark - UIViewController lifecycle

- (void)addTargetingCircle {
    // Set up the shape of the circle
    int radius = 10;
    CAShapeLayer *circle = [CAShapeLayer layer];
    // Make a circular shape
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    // Center the shape in self.view
    circle.position = CGPointMake(CGRectGetMidX(self.view.frame)-radius,
                                  CGRectGetMidY(self.view.frame)-radius);
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor redColor].CGColor;
    circle.lineWidth = 5;
    
    // Add to parent layer
    [self.view.layer addSublayer:circle];
}

- (void)initScoreLabels {
    NSArray *users = [roundJSON objectForKey:@"users"];
    NSDictionary *topScoringUser = [users objectAtIndex:0];
    NSString *topName = [topScoringUser objectForKey:@"name"];
    NSString *topScore = [topScoringUser objectForKey:@"score"];
    highScoreLabel.text = [[NSString alloc] initWithFormat:@"%@", topScore];
    myScoreLabel.text = [[NSString alloc] initWithFormat:@"%d", 0];
    topNameLabel.text = [[NSString alloc] initWithFormat:@"%@", topName];
    myNameLabel.text = [[NSString alloc] initWithFormat:@"%@", _myName];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // TODO: Add Multiple References Tracking
    // load our tracking configuration
    trackingConfigFile = [[NSBundle mainBundle] pathForResource:@"TrackingData_Marker" ofType:@"xml" inDirectory:@"./"];
    
	if(trackingConfigFile)
	{
		bool success = m_metaioSDK->setTrackingConfiguration([trackingConfigFile UTF8String]);
		if(!success) {
			NSLog(@"No success loading the tracking configuration");
        } else {
            NSLog(@"Loaded the tracking configuration");
        }
	}
    [self addTargetingCircle];
    [self initScoreLabels];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    [super viewDidUnload];
}


#pragma mark - App Logic
- (void)onSDKReady
{
	[super onSDKReady];
}

- (void)drawFrame
{
    [super drawFrame];
    
    // return if the metaio SDK has not been initialiyed yet
    if( !m_metaioSDK )
        return;
    
    // get all the detected poses/targets
    std::vector<metaio::TrackingValues> poses = m_metaioSDK->getTrackingValues();
    
//    if (poses.empty()) {
//        [laser setBirthrate:0.0f];
//    } else {
//        [laser setBirthrate:220.0f];
//    }
    for( std::vector<metaio::TrackingValues>::const_iterator i = poses.begin(); i != poses.end(); ++i) {
//        printf("Position: %f %f %f\n", i->translation.x, i->translation.y, i->translation.z);
    }
}



#pragma mark - Rotation handling


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    // allow rotation in all directions
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)increaseScore {
    NSNumber *myScore = [[[NSNumberFormatter alloc] init] numberFromString:myScoreLabel.text];
    myScoreLabel.text = [NSString stringWithFormat:@"%d", ([myScore intValue] + 100)];
}

- (void)sendShootRequest {
    NSString *urlString = [NSString stringWithFormat:@"%@:%@/shoot/%@/%@/1", LTAppDelegate.serverIP, LTAppDelegate.serverPort, [roundJSON objectForKey:@"_id"], _myName];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"%@\n", urlString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSURLResponse *urlResponse = nil;
    NSError *requestError;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    if (response !=  nil) {
        // Not used for now
//        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&requestError];
//        NSLog(@"%@\n", jsonArray);
    }
}

- (IBAction)shootButtonPressed:(id)sender {
    NSLog(@"shoot pressed");
    LaserParticleSystemView *laser = [[LaserParticleSystemView alloc] init];
    [laser setBirthrate:220.0f];
    [self.view addSubview:laser];
    
    std::vector<metaio::TrackingValues> poses = m_metaioSDK->getTrackingValues();
    if (!poses.empty()) {
        metaio::TrackingValues targetPosition = poses.front();
        float x = targetPosition.translation.x;
        float y = targetPosition.translation.y;
        float dim = 50.0f;
        int markerId = targetPosition.coordinateSystemID;
        NSLog(@"%d\n", markerId);
        if (x > -dim && x < dim && y > -dim && y < dim) {
            NSLog(@"you hit it");
            [self sendShootRequest];
            [self increaseScore];
       
            SocketIO *socket = [RoundsViewController socketIO];
            NSString *roundID = [roundJSON objectForKey:@"_id"];
            [socket sendEvent:@"shootSuccessful" withData:roundID];
            
        } else {
            NSLog(@"you missed");
        }
    } else {
        NSLog(@"you missed");
    }
}

- (void) roundOver {
    NSString *roundID = [roundJSON objectForKey:@"_id"];
    [self dismissViewControllerAnimated:YES completion:nil];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RoundResultsViewController * controller = (RoundResultsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"roundResultsViewController"];
    [self.navigationController pushViewController:controller animated:TRUE];
    
}

- (IBAction)leaveButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet {
    NSLog(@"HERERE: %@\n", [packet data]);
}


@end
