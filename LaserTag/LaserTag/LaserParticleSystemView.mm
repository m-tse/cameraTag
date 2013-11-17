//
//  LaserParticleSystemView.m
//  LaserTag
//
//  Created by Andrew Shim on 11/16/13.
//  Copyright (c) 2013 Andrew Shim. All rights reserved.
//

#import "LaserParticleSystemView.h"
#import <QuartzCore/QuartzCore.h>
#import <dispatch/dispatch.h>

@implementation LaserParticleSystemView {
    CAEmitterLayer *laserEmitter;
    CAEmitterCell *laser;
    NSTimer *timer;
    NSTimer *positionTimer;
    NSDate *startTime;
    dispatch_queue_t backgroundQueue;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        backgroundQueue = dispatch_queue_create("LaserTagDispatch", NULL);
        
        
        laserEmitter = (CAEmitterLayer *)self.layer;
        
        //configure the emitter layer
        CGFloat xMid = [UIScreen mainScreen].bounds.size.width/2;
        CGFloat yBot = [UIScreen mainScreen].bounds.size.height;
        laserEmitter.emitterPosition = CGPointMake(xMid, yBot/2);
        laserEmitter.velocity = 5.0f;
        laserEmitter.emitterSize = CGSizeMake(10, 10);
        laserEmitter.renderMode = kCAEmitterLayerAdditive;
        laserEmitter.preservesDepth = YES;
        
        laser = [CAEmitterCell emitterCell];
        laser.birthRate = 0;
        laser.lifetime = 0.1;
        laser.lifetimeRange = 0.5;
        laser.color = [[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1] CGColor];
        laser.contents = (id)[[UIImage imageNamed:@"particle.png"] CGImage];
        [laser setName:@"laser"];
        
        //add the cell to the layer and we're done
        laserEmitter.emitterCells = [NSArray arrayWithObject:laser];
        
        laser.velocity = 10;
        laser.velocityRange = 20;
        laser.emissionRange = M_PI_2;
        
        laser.scaleSpeed = 0.3;
        laser.spin = 0.5;
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(laserDied) userInfo:nil repeats:NO];
    }
    return self;
}

+ (Class)layerClass {
    return [CAEmitterLayer class];
}

- (void)setBirthrate:(float)birthrate {
    [laserEmitter setValue:[NSNumber numberWithInt:birthrate]
               forKeyPath:@"emitterCells.laser.birthRate"];
}

- (void)laserDied {
    [self removeFromSuperview];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
