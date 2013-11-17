//
//  LTAppDelegate.h
//  LaserTag
//
//  Created by Andrew Shim on 11/16/13.
//  Copyright (c) 2013 Andrew Shim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketIOPacket.h"

@interface LTAppDelegate : UIResponder <UIApplicationDelegate>


{
    UINavigationController *navigationController;
}
+ (NSString*) serverIP;
+ (NSString*) serverPort;
//+ (SocketIO*) socketIO;

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UIWindow *window;
@end
