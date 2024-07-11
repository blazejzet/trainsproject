//
//  MTRemoveMyGhostCart.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTCart.h"

@class MTGhostRepresentationNode;

@interface MTRemoveMyGhostCart : MTCart

@property bool optionsOpen;

//-(void)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode;
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train;
-(int)getCategory;
-(NSString*)getImageName;
+(NSString*)DoGetMyType;

@end
