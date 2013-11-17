//
//  RoundCreateViewController.h
//  LaserTag
//
//  Created by Matthew on 11/17/13.
//  Copyright (c) 2013 Andrew Shim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketIO.h"
#import "RoundsViewController.h"

@interface RoundCreateViewController : UIViewController
- (IBAction)setRoundDuration:(UIDatePicker*)sender;
- (IBAction)createRound:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *numberContestantsField;
@property (nonatomic, retain) IBOutlet UITextField* roundNameField;
@property (nonatomic, retain) RoundsViewController *roundsViewController;
@end
