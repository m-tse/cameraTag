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
#import "SocketIO.h"

@interface LTViewController : MetaioSDKViewController <SocketIODelegate> {
    NSString *trackingConfigFile;
    NSTimer *timer;
    IBOutlet UILabel *myCounterLabel;
    __weak IBOutlet UILabel *highScoreLabel;
    __weak IBOutlet UILabel *myScoreLabel;
    __weak IBOutlet UILabel *topNameLabel;
    __weak IBOutlet UILabel *myNameLabel;
}
@property (nonatomic, copy) NSString *userName;

@property (nonatomic, retain) NSDictionary *roundJSON;
@property (nonatomic, retain) NSString *myName;

- (IBAction)shootButtonPressed:(id)sender;
- (IBAction)leaveButtonPressed:(id)sender;

- (void)updateCounter:(NSTimer *)theTimer;
- (void)countdownTimer;
- (void)setTopInfo:(NSString *)name score:(NSString *)score;


@end
