//
//  LaserParticleSystemView.m
//  LaserTag
//
//  Created by Andrew Shim on 11/16/13.
//  Copyright (c) 2013 Andrew Shim. All rights reserved.
//

#import "LaserParticleSystemView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LaserParticleSystemView {
    CAEmitterLayer *laserEmitter;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    laserEmitter = (CAEmitterLayer *)self.layer;
    
    //configure the emitter layer
    laserEmitter.emitterPosition = CGPointMake(50, 50);
    laserEmitter.emitterSize = CGSizeMake(10, 10);
    laserEmitter.renderMode = kCAEmitterLayerAdditive;
    
    CAEmitterCell* laser = [CAEmitterCell emitterCell];
    laser.birthRate = 200;
    laser.lifetime = 3.0;
    laser.lifetimeRange = 0.5;
    laser.color = [[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1] CGColor];
    laser.contents = (id)[[UIImage imageNamed:@"particle.png"] CGImage];
    [laser setName:@"fire"];
    
    //add the cell to the layer and we're done
    laserEmitter.emitterCells = [NSArray arrayWithObject:laser];
    
    laser.velocity = 10;
    laser.velocityRange = 20;
    laser.emissionRange = M_PI_2;
    
    laser.scaleSpeed = 0.3;
    laser.spin = 0.5;
}

+ (Class)layerClass {
    return [CAEmitterLayer class];
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
