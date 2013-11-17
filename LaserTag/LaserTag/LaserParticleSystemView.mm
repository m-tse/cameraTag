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
    bool isDead;
    dispatch_queue_t backgroundQueue;
}

- (void)reportPosition {
    while (!isDead) {
        CAEmitterLayer *presentation = [laserEmitter presentationLayer];
        NSLog(@"X: %f Y: %f Z: %f\n",
              presentation.bounds.origin.x,
              presentation.bounds.origin.y,
              presentation.emitterZPosition);
        NSDate *timeNow = [[NSDate alloc] init];
        NSTimeInterval timeInterval = [timeNow timeIntervalSinceDate:startTime];
        NSLog(@"%f\n", timeInterval);
    }
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
//        
//        startTime = [[NSDate alloc] init];
//        
//        CABasicAnimation* ba = [CABasicAnimation animationWithKeyPath:@"emitterPosition"];
//        ba.fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 400)];
//        ba.toValue = [NSValue valueWithCGPoint:CGPointMake(300,0)];
//        ba.duration = 3;
//        ba.autoreverses = NO;
//        ba.delegate = self;
//        laserEmitter.emitterPosition = CGPointMake(300,0);
//        
//        [laserEmitter addAnimation:ba forKey:nil];
//        
//        CGFloat startZ = 0.0f;
//        CGFloat endZ = 100.0f;
//        
//        CABasicAnimation* ba2 = [CABasicAnimation animationWithKeyPath:@"emitterZPosition"];
//        ba2.fromValue = [NSValue valueWithBytes:&startZ objCType:@encode(CGFloat)];
//        ba2.toValue = [NSValue valueWithBytes:&endZ objCType:@encode(CGFloat)];
//        ba2.duration = 6;
//        ba2.autoreverses = NO;
//        
//        [laserEmitter addAnimation:ba2 forKey:nil];
//        dispatch_async(backgroundQueue, ^(void) {
//            [self reportPosition];
//        });
//        
    }
    return self;
}

+ (Class)layerClass {
    return [CAEmitterLayer class];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"finished");
    isDead = true;
}

- (void)setBirthrate:(float)birthrate {
    [laserEmitter setValue:[NSNumber numberWithInt:birthrate]
               forKeyPath:@"emitterCells.laser.birthRate"];
}

- (void)laserDied {
    NSLog(@"Removed");
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
