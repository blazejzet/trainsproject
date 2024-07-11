//
//  MTRotateCart.h
//  MagicTrains
//
//  Created by Kamil Tomasiak on 14.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCart.h"
@class MTRotationCartOptions;
@class MTGhostRepresentationNode;

@interface MTRotateCart : MTCart

@property MTRotationCartOptions *options;

-(int)getCategory;
-(CGFloat) getSelectedValueRotationWithGhostRep: (MTGhostRepresentationNode *) ghostRepNode;
-(CGFloat) getSelectedValueTimeWithGhostRep: (MTGhostRepresentationNode *) ghostRepNode;
-(CGFloat) getRotationForFrameWithRepNode: (MTGhostRepresentationNode*)ghostRepNode;
//-(CGFloat) getRotationForFrameCartToAngleWithRepNode: (MTGhostRepresentationNode*)ghostRepNode;

@end
