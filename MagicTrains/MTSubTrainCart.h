//
//  MTSubTrainCart.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 04.04.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTCart.h"
@class MTSubTrain;
@interface MTSubTrainCart : MTCart

@property NSInteger lenghtOfLoopInCode;
@property MTSubTrain * subTrain;
@property bool isMySubTrainVisible;
-(void)addCart:(MTCart*) cart;

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode;
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train;
-(int)getCategory;
-(NSString*)getImageName;
-(NSString*)getSecondImageName;
+(NSString*)DoGetMyType;
-(id) initWithSubTrain: (MTSubTrain *) t;
@end
