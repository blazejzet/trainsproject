 //
//  MTJoystickLeftNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 27.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTJoystickLeftArrowNode.h"
#import "MTGhostsBarNode.h"
#import "MTGhostIconNode.h"
#import "MTSceneAreaNode.h"
#import "MTTrain.h"
#import "MTGhost.h"
#import "MTStorage.h"
#import "MTLeftArrowLocomotiv.h"
#import "MTExecutor.h"
#import "MTGhostRepresentationNode.h"
#import "MTJoystickNotificationsNames.h"

@implementation MTJoystickLeftArrowNode
-(id) init {
    if ((self = [super initWithImageNamed:@"joystickLeft.png"]))
    {
        self.name = @"MTJoysitckLeftArrowNode";
        self.size = CGSizeMake(100, 100);
        self.position = CGPointMake(-90, 0);
        self.zPosition = 1000;
    }
    return self;
}

-(void)tapGesture:(UIGestureRecognizer *)g
{
    [[NSNotificationCenter defaultCenter] postNotificationName: N_JoystickLeftArrowPush object:self];
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
