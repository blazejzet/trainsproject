//
//  MTCollisionWithAnotherGhostLocomotivOptions.h
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 30.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCollisionWithAnotherGhostLocomotiv.h"
#import "MTCollisionWithAnotherGhostLocomotivTrainNode.h"
#import "MTCollisionWithAnotherGhostLocomotivSelectedGhostNode.h"
#import "MTCollisionWithAnotherGhostLocomotivTrackNode.h"
#import "MTSpriteNode.h"
@class MTCollisionWithAnotherGhostLocomotivGhostIconNode;

@interface MTCollisionWithAnotherGhostLocomotivOptions : NSObject
@property NSMutableArray *ghostIcons;
@property MTSpriteNode *centerIcon;
@property CGPoint prevPositionFromSelctedGhost;
@property CGPoint prevPositionWhenGhostBarIsOpenningAgain;
@property MTCollisionWithAnotherGhostLocomotivGhostIconNode * currentSelectedGhostIcon;
@property NSInteger selectedIconGhostNumber;
@property MTCollisionWithAnotherGhostLocomotivTrainNode *trainNode;
@property NSMutableArray *tracks;
@property MTCollisionWithAnotherGhostLocomotiv *myLocomotiv;
@property BOOL isAnimationRuning;

-(id) initWithLocomotiv:(MTCollisionWithAnotherGhostLocomotiv *)loc;

-(void) showOptions;
-(void) hideOptions;
-(void) savePrevPosition:(CGPoint )prevPosition WithSelectedIcon:(MTCollisionWithAnotherGhostLocomotivGhostIconNode *)selectedIconGhost;
@end
