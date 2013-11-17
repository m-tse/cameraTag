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

@interface LTViewController ()

@end

@implementation LTViewController {
    float _curRed;
    BOOL _increasing;
    GLKView *gView;
    GLfloat _zTranslate;
    NSArray *laserShots;
}

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

- (void)sendShootRequest {
    NSString *urlString = [NSString stringWithFormat:@"%@:%@/shoot/52883ec72afe5b79a3000001/Andrew2/1"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSURLResponse *urlResponse = nil;
    NSError *requestError;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    if (response !=  nil) {
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&requestError];
        NSLog(@"%@\n", jsonArray);
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
        } else {
            NSLog(@"you missed");
        }
    } else {
        NSLog(@"you missed");
    }

}


@end
