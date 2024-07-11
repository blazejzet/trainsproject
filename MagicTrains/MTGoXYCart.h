//
//  MTGoXYCart.h
//  MagicTrains
//
//  Created by Kamil Tomasiak on 26.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTCart.h"

@class MTGoXYCartOptions;
@class MTGhostRepresentationNode;
@interface MTGoXYCart : MTCart

@property MTGoXYCartOptions * options;

@property bool optionsOpen;
-(void)showOptions;
-(void) hideOptions;

//-(void)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode;
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train;
-(int)getCategory;
-(NSString*)getImageName;
+(NSString*)DoGetMyType;

@end
