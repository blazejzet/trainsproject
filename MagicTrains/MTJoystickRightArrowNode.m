//
//  MTJoystickRightArrowNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 27.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTJoystickRightArrowNode.h"
#import "MTExecutor.h"
#import "MTJoystickNotificationsNames.h"

@implementation MTJoystickRightArrowNode
-(id) init {
    if ((self = [super initWithImageNamed:@"joystickRight.png"]))
    {
        self.name = @"MTJoysitckRightArrowNode";
        self.size = CGSizeMake(100, 100);
        self.position = CGPointMake(90, 0);
        self.opQueue = [[NSOperationQueue alloc] init];
        [self.opQueue setMaxConcurrentOperationCount:1];
        self.zPosition = 1000;
    }
    return self;
}

-(void)tapGesture:(UIGestureRecognizer *)g
{
    [[NSNotificationCenter defaultCenter] postNotificationName: N_JoystickRightArrowPush object:nil];
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
