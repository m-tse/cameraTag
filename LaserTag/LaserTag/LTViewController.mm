//
//  LTViewController.m
//  LaserTag
//
//  Created by Andrew Shim on 11/16/13.
//  Copyright (c) 2013 Andrew Shim. All rights reserved.
//

#import "LTViewController.h"
#import "LaserParticleSystemView.h"

@interface LTViewController ()

@end

@implementation LTViewController {
    LaserParticleSystemView *laser;
}

#pragma mark - UIViewController lifecycle

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
    laser = [[LaserParticleSystemView alloc] init];
    [[self view] addSubview:laser];
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
    
    if (poses.empty()) {
        [laser setBirthrate:0.0f];
    } else {
        [laser setBirthrate:220.0f];
    }
    for( std::vector<metaio::TrackingValues>::const_iterator i = poses.begin(); i != poses.end(); ++i) {
        printf("Position: %f %f %f\n", i->translation.x, i->translation.y, i->translation.z);
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

@end
