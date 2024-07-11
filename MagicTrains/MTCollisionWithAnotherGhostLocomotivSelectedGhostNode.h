//
//  MTCollisionWithAnotherGhostLocomotivSelectedGhostNode.h
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 30.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTSpriteNode.h"

@interface MTCollisionWithAnotherGhostLocomotivSelectedGhostNode : MTSpriteNode
-(id) initWithTexture:(SKTexture *) texture AndPosition:(CGPoint)position;
@property CGPoint prevPosition;
@end
