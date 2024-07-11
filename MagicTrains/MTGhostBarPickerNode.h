//
//  MTGhostBarPickerNode.h
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 18.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTSpriteNode.h"
#import "MTGhostIconNode.h"

@interface MTGhostBarPickerNode : MTSpriteNode
@property float sizeEl;
@property int centerIndex;
@property NSMutableArray *icons;
@property BOOL animationFlag;
@property float touchPositionBegan;
@property float touchPositionEnded;
@property float yBegan;
@property float xBegan;
@property float xMove;
@property float nextSpace;
@property BOOL vertical;
@property BOOL horizontal;
@property MTGhostIconNode *changedIcon;
@property BOOL hold;

-(void) addNewElementToPicker:(MTSpriteNode *) element;
-(void) updateAlpha;
-(void) tapGesture:(UIGestureRecognizer *)g WithIcon:(MTGhostIconNode *)icon;
-(void) removeIconFromPicker:(MTGhostIconNode *)icon;
-(void) fitIconsPPQ;
@end
