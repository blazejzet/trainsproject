//
//  MTCollisionWithAnotherGhostLocomotivTrainNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 30.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCollisionWithAnotherGhostLocomotivTrainNode.h"

@implementation MTCollisionWithAnotherGhostLocomotivTrainNode
-(id) initWithPosition:(CGPoint) position
{
    if ((self = [super initWithImageNamed:@"collisionWithAnotherGhostLocomotivTrain2.png"]))
    {
        self.position = position;
        self.size = CGSizeMake(250, 250);
    }
    
    return self;
}
@end
