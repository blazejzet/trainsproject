//
//  MTPauseCart.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTCart.h"

@class MTPauseCartOptions;
@class MTGhostRepresentationNode;

@interface MTPauseCart : MTCart


@property MTPauseCartOptions * options;
@property CGFloat * pauseTime;

-(void) showOptions;
-(void) hideOptions;

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode;
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train;
-(int)getCategory;
-(NSString*)getImageName;
+(NSString*)DoGetMyType;

@end
