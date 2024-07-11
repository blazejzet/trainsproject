//
//  MTRightRotationCart.h
//  MagicTrains
//
//  Created by Kamil Tomasiak on 30.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCart.h"
#import "MTRotateCart.h"

@class MTRotationCartOptions;
@class MTGhostRepresentationNode;
@interface MTRightRotationCart : MTRotateCart

@property MTRotationCartOptions * options;

@property bool optionsOpen;

-(BOOL)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode;
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train;
-(NSString*)getImageName;

+(NSString*)DoGetMyType;

@end
