//
//  MTCollisionWithAnotherGhostLocomotivGhostIconNode.h
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 30.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTSpriteNode.h"
#import "MTGhost.h"
#import "MTCollisionWithAnotherGhostLocomotivOptions.h"

@interface MTCollisionWithAnotherGhostLocomotivGhostIconNode : MTSpriteNode
@property MTGhost *ghostFromGhostBar;
@property MTCollisionWithAnotherGhostLocomotivOptions *myOptions;
@property float time;
@property CGPoint oldPosition;
@property int myNumber;
@property (weak) NSArray* allIcons;
-(id) initWithTexture:(SKTexture *)texture AndPosition:(CGPoint) position AndGhost:(MTGhost *)ghost andMyLocomotivOptions:(MTCollisionWithAnotherGhostLocomotivOptions *)options;
-(id)initWithImageNamed:(NSString *)name;
-(void)resetPosition;

@end
