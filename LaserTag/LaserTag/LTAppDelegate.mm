//
//  LTAppDelegate.m
//  LaserTag
//
//  Created by Andrew Shim on 11/16/13.
//  Copyright (c) 2013 Andrew Shim. All rights reserved.
//

#import "LTAppDelegate.h"
#import "RoundsViewController.h"
#import "SocketIOPacket.h"


@implementation LTAppDelegate
@synthesize navigationController;
//static NSString* serverIP = @"http://10.190.72.149";
static NSString* serverIP = @"http://colab-sbx-13.oit.duke.edu";
static NSString* serverPort = @"3000";

+ (NSString*) serverIP { return serverIP; }
+ (NSString*) serverPort { return serverPort; }
//+ (SocketIO*) socketIO { return socketIO; }
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RoundsViewController * controller = (RoundsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"roundsViewController"];
    
    navigationController = [[UINavigationController alloc]
                            initWithRootViewController:controller];
    
    self.window = [[UIWindow alloc]
                   initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
    

    
    return YES;

}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
