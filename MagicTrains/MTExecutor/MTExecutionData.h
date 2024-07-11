//
//  MTExecutionData.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 09.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MTGhostRepresentationNode.h"

@interface MTExecutionData : NSObject

@property MTGhostRepresentationNode* ghostRepNode;
@property NSMutableArray* trains;

-(id)initWithGhostRep:(MTGhostRepresentationNode *) ghostRepresentationNode TrainsArray:(NSArray *) trains;
/*
-(void)addCommandsCounter:(NSMutableArray *)counter Train:(MTTrain *) train;
-(void)resetCommandsCounterAt:(NSUInteger) index;
-(NSMutableArray*)getCommandsCounterAt:(NSUInteger) index;
-(void)setCommandsCounterAt:(NSUInteger) index WithCounter:(NSMutableArray*) array;
-(MTTrain*)getCommandsCounterTrainAt:(NSUInteger) index;
*/

@end
