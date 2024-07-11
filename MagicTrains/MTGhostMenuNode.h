//
//  MTGhostMenuNode.h
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 16.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTSpriteNode.h"
#import "MTGhostMenuIconNode.h"
#import "MTGhostMenuPickerVariantsNode.h"

@class MTGhostMenuPickerNode;
@class MTGhost;

@interface MTGhostMenuNode : MTSpriteNode
@property MTGhostMenuPickerNode *picker;
@property MTGhost *currentGhost;
@property MTGhostMenuIconNode *currentGhostIcon;
@property BOOL isVariantActionRunning;
@property BOOL isGhostPickerCenterActionRunning;
@property int lastPinchDirection;
@property float lastPinchValue;
@property int direction;

-(void) saveChangesWithVariant:(MTGhostMenuPickerVariantsNode *)variant;
-(void) changeGhostIconInGhostBar:(MTGhostMenuIconNode *)menuIcon;
-(void) addInstanceOptions;
-(void) accept;
-(void) cancel;
-(void) addOneInstance;
-(void) addMultiInstace;
-(void) addGhostIcons;
-(void) deleteAllInstances;
-(void)removeGhostVariantAnimationBlockade;
-(void) destoryMe;
@end
