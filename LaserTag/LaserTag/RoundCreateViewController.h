//
//  RoundCreateViewController.h
//  LaserTag
//
//  Created by Matthew on 11/17/13.
//  Copyright (c) 2013 Andrew Shim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundCreateViewController : UIViewController
- (IBAction)setRoundDuration:(UIDatePicker*)sender;
- (IBAction)createRound:(id)sender;
@property (nonatomic, retain) IBOutlet UITextField* roundNameField;
@end
