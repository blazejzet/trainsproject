//
//  MTCodeRailroadNode.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 30.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTSpriteNode.h"
@class MTTrain;
@class MTSubTrain;
@class MTBlockNode;
@interface MTCodeRailroadNode : MTSpriteNode

@property MTTrain* myTrain;
@property MTSubTrain* mySubTrain;
@property NSUInteger nextCartIndex;
-(id) initWithSubTrain:(MTSubTrain *) subTrain NextCartIndex:(NSUInteger)nextCartIndex;
-(void) whenBlockNodeIsOverMe:(MTBlockNode *) coveringNode;
-(void) whenBlockNodeWasOverMe:(MTBlockNode *) coveringNode;
-(void) blockDrop: (MTBlockNode *)block;
@end
