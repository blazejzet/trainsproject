//
//  MTGoCart.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCart.h"
@class MTShotCartsOptions;
@class MTGhostRepresentationNode;

@interface MTGoShotCart : MTCart
@property MTShotCartsOptions * options;

-(int)getCategory;

-(void)showOptions;
-(void)hideOptions;
-(CGVector)calculateValidVectorWith:(CGFloat) distance Rotation:(CGFloat)fi GhostRepresentation:(MTGhostRepresentationNode *)ghostRepNode;
-(CGFloat)getSelectedDirectionWithRepNode:(MTGhostRepresentationNode*)ghostRepNode;
-(CGVector)calculateValidImpulseVectorWith:(CGFloat) distance Rotation:(CGFloat)fi GhostRepresentation:(MTGhostRepresentationNode *)ghostRepNode;
@end
