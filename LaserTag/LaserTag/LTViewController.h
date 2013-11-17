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
}
- (IBAction)shootButtonPressed:(id)sender;

@end
