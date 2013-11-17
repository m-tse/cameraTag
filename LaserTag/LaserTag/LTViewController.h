//
//  LTViewController.h
//  LaserTag
//
//  Created by Andrew Shim on 11/16/13.
//  Copyright (c) 2013 Andrew Shim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetaioSDKViewController.h"
#import "EAGLView.h"
#import <GLKit/GLKit.h>

@interface LTViewController : MetaioSDKViewController {
    NSString *trackingConfigFile;
    NSTimer *timer;
    IBOutlet UILabel *myCounterLabel;
}

@property (nonatomic, retain) UILabel *myCounterLabel;

- (IBAction)shootButtonPressed:(id)sender;

- (void)startCountdown:(CGFloat)millisecondsRemaining;
- (void)updateCounter:(NSTimer *)theTimer;
- (void)countdownTimer;


@end
