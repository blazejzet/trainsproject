//
//  MTSpriteNodeStopSimulation.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 02.04.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import "MTSpriteNodeStopSimulation.h"
#import "MTGhostsBarNode.h"
#import "MTSpriteNodeX.h"

@interface MTSpriteNodeStopSimulation()
@property CGPoint begin;
@property MTSpriteNode * n;
@property int direction;
@end

@implementation MTSpriteNodeStopSimulation
@synthesize begin;
@synthesize n;
@synthesize direction;

-(instancetype)init768{
    self = [super initWithImageNamed:@"stop_simulation_bg_empty"];
    n = [[MTSpriteNodeX alloc]initWithImageNamed:@"stop_simulation_full"];
    direction=-1;
    self.begin=n.position;
    self.userInteractionEnabled=true;
    n.userInteractionEnabled=true;
    [self addChild:n];
    return self;
}

-(instancetype)init{
    self = [super initWithImageNamed:@"stop_simulation_bg"];
    n = [[MTSpriteNodeX alloc]initWithImageNamed:@"stop_simulation"];
    [self addChild:n];
    self.begin=n.position;
    direction=-1;
    self.userInteractionEnabled=true;
    n.userInteractionEnabled=true;
    return self;
}

-(void)tapGesture:(UIGestureRecognizer *)g{
    //////NSLog(@"TAPNIETE");
    //[(MTGhostsBarNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTGhostsBarNode"]showBarNM];
    //[self runAction:[SKAction fadeAlphaTo:0.0 duration:0.3]];
   }

-(void)swipe:(UISwipeGestureRecognizer *)g :(UIView *)v{
    //[(MTGhostsBarNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTGhostsBarNode"]showBarNM];
    //[self runAction:[SKAction fadeAlphaTo:0.0 duration:0.3]];
  
}
@end
