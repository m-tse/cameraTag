//
//  RoundViewController.h
//  LaserTag
//
//  Created by Matthew on 11/16/13.
//  Copyright (c) 2013 Andrew Shim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundViewController : UIViewController
- (IBAction)enterRound:(id)sender;
@property (nonatomic, copy) NSDictionary *roundJSON;
@end
