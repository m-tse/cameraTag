//
//  RoundsViewController.h
//  LaserTag
//
//  Created by Matthew on 11/16/13.
//  Copyright (c) 2013 Andrew Shim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketIO.h"
#import "SocketIOPacket.h"

@interface RoundsViewController : UIViewController <SocketIODelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
@property (nonatomic, retain) UINavigationController *navController;

@end
