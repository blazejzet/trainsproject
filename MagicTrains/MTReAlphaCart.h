//
//  MTRotationCart.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 14.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTCart.h"
#import "MTResizeCart.h"
#import "MTReAlphaCart.h"

@class MTReAlphaCartOptions;
@class MTGhostRepresentationNode;
@interface MTReAlphaCart : MTResizeCart

@property bool optionsOpen;

-(BOOL)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode;
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train;
-(NSString*)getImageName;

+(NSString*)DoGetMyType;


@end