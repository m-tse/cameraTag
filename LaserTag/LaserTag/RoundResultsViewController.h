//
//  RoundResultsViewController.h
//  LaserTag
//
//  Created by Matthew on 11/17/13.
//  Copyright (c) 2013 Andrew Shim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundResultsViewController : UIViewController
- (IBAction)backToHomeScreen:(id)sender;
@property (nonatomic, copy) NSDictionary *roundJSON;

@end
