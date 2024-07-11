//
//  MTWheelCircleNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 06.05.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTWheelCircleNode.h"

@implementation MTWheelCircleNode
-(id) init
{
        if ((self = [super initWithImageNamed:@"circle_wheel.png"]))
            {
                    self.zPosition = 0;
                    self.size = CGSizeMake(0, 0);
                    self.position = CGPointMake(0, 0);
                }
    
        return self;
    }

-(void)rotateGesture:(UIGestureRecognizer *)g :(UIView *)v
{
        [(MTWheelCircleNode*)self.parent rotateGesture:g :v];
}

@end