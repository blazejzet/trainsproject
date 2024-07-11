//
//  MTLoopBlockNode.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 04.04.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTCodeBlockNode.h"
@class MTTrainNode;
@interface MTLoopBlockNode : MTCodeBlockNode
@property bool isMySubtrainVisible;
@property MTTrainNode* myTrainNode;
@end
