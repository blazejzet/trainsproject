//
//  MTGoCart.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCart.h"
@class MTMoveCartsOptions;
@class MTGhostRepresentationNode;

@interface MTGoCart : MTCart
@property MTMoveCartsOptions * options;

-(int)getCategory;

-(void)showOptions;
-(void)hideOptions;
-(CGVector)calculateValidVectorWith:(CGFloat) distance Rotation:(CGFloat)fi GhostRepresentation:(MTGhostRepresentationNode *)ghostRepNode;
-(CGFloat)getSelectedDirectionWithRepNode:(MTGhostRepresentationNode*)ghostRepNode;
-(CGFloat)getSelectedTimeWithRepNode:(MTGhostRepresentationNode*)ghostRepNode;
-(CGVector)calculateValidImpulseVectorWith:(CGFloat) distance Rotation:(CGFloat)fi GhostRepresentation:(MTGhostRepresentationNode *)ghostRepNode;
-(CGFloat) getDistanceForFrameWithRepNode: (MTGhostRepresentationNode*)ghostRepNode;
@end
