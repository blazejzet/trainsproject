//
//  MTTrainStartNode.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 30.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTCodeRailroadNode.h"
@class MTBlockNode;

@interface MTTrackStartNode : MTCodeRailroadNode

-(void)removeMyTrain;
-(id)initCurve;
-(void)blockDrop:(MTBlockNode*)block;

@end
