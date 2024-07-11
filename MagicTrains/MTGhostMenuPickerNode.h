//
//  MTGhostMenuPickerNode.h
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 26.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//
@class MTGhost;

#import "MTSpriteNode.h"
#import "MTGhostMenuPickerVariantsNode.h"
#import "MTGhostMenuPickerElementNode.h"

@interface MTGhostMenuPickerNode : MTSpriteNode
@property float stop;
@property NSString *currentGhostCostumeCat;
@property NSMutableArray *pickersElements;
@property NSMutableArray *ringPickersElements;
@property NSMutableArray *ringPickersElements2;
@property NSMutableArray *currentGhosts;
@property NSMutableArray *variantsElements;
@property MTGhostMenuPickerElementNode *lastElement;
@property MTGhostMenuPickerVariantsNode *lastVariant;
@property int centerIndex;
@property BOOL animation;

-(void) initVariantsWithAlpha:(CGFloat) alpha;
-(void) changeGhost:(MTGhost *)ghost;
-(id) initWithCurrentGhost:(MTGhost *)currentGhost;
-(void) addCenterGhostAnimation;
-(void) changeGhostFromTapGesture:(MTGhostMenuPickerElementNode *)element;
-(void)removeCenterGhostAnimation;
-(void) hideOrUnhideRestPicker:(NSString *)op;
@end
