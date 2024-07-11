//
//  MTRotateToAngleCart.h
//  MagicTrains
//
//  Created by Kamil Tomasiak on 02.05.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCart.h"
#import "MTRotateCart.h"

@class MTRotationCartOptions;
@class MTGhostRepresentationNode;
@interface MTRotateToAngleCart : MTRotateCart

@property MTRotationCartOptions * options;
@property bool optionsOpen;

//dodatkowo
@property CGFloat startRotation;

-(BOOL)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode;
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train;
-(NSString*)getImageName;

+(NSString*)DoGetMyType;

@end
