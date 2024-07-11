//
//  MTJoystickUpArrowNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 27.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTJoystickUpArrowNode.h"
#import "MTExecutor.h"
#import "MTJoystickNotificationsNames.h"

@implementation MTJoystickUpArrowNode
-(id) init {
    if ((self = [super initWithImageNamed:@"joystickUp.png"]))
    {
        self.name = @"MTJoysitckUpArrowNode";
        self.size = CGSizeMake(100, 100);
        self.position = CGPointMake(0, 90);
        self.zPosition = 1000;
    }
    return self;
}

-(void)tapGesture:(UIGestureRecognizer *)g
{
    [[NSNotificationCenter defaultCenter] postNotificationName: N_JoystickUpArrowPush object:self];
}

-(void)hold:(UIGestureRecognizer *)g :(UIView *)v
{
    if(g.state == UIGestureRecognizerStateBegan)
    {
        [self tapGesture:g];
        self.holdTimer = [NSTimer scheduledTimerWithTimeInterval:1/3
                                                          target:self
                                                        selector:@selector(tapGesture:)
                                                        userInfo:g
                                                         repeats:YES];
    }
    if(g.state == UIGestureRecognizerStateEnded)
    {
        [self.holdTimer invalidate];
    }
}

@end
