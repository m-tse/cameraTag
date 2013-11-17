//
//  RoundViewController.h
//  LaserTag
//
//  Created by Matthew on 11/16/13.
//  Copyright (c) 2013 Andrew Shim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundsViewController.h"

@interface RoundViewController : UIViewController <UINavigationControllerDelegate> {
    NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) RoundsViewController *roundsViewController;
@property (weak, nonatomic) IBOutlet UILabel *myCounterLabel;
@property (nonatomic, copy) NSDictionary *roundJSON;

- (IBAction)enterRound:(id)sender;

@end
