//
//  MTCollisionWithAnotherGhostLocomotivSelectedGhostNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 30.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCollisionWithAnotherGhostLocomotivSelectedGhostNode.h"

@implementation MTCollisionWithAnotherGhostLocomotivSelectedGhostNode
-(id) initWithTexture:(SKTexture *) texture AndPosition:(CGPoint)position
{
    self.prevPosition = position;
    self.texture = texture;
    self.size = CGSizeMake(75, 75);
    
    return self;
}
@end
