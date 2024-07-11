//
//  MTJoystickAButtonNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 27.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTJoystickAButtonNode.h"
#import "MTExecutor.h"
#import "MTGUI.h"
#import "MTJoystickNotificationsNames.h"

@implementation MTJoystickAButtonNode
-(id) init {
    if ((self = [super initWithImageNamed:@"joystickA.png"]))
    {
        self.name = @"MTJoysitckAButtonNode";
        self.size = CGSizeMake(50, 50);
        if(HEIGHT==1024){//ipadpro
            self.position = CGPointMake(400, -450);
        }else{
            self.position = CGPointMake(400, -350);
            
        }
        self.zPosition = 1000;
    }
    return self;
}

-(void)tapGesture:(UIGestureRecognizer *)g
{
    [[NSNotificationCenter defaultCenter] postNotificationName: N_JoystickAButtonPush object:self];
}

-(void)hold:(UIGestureRecognizer *)g :(UIView *)v
{
    if(g.state == UIGestureRecognizerStateBegan)
    {
        self.holdTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
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
