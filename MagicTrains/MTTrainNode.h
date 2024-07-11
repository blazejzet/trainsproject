//
//  MTTrainNode.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 05.04.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTSpriteNode.h"
@class MTTrain;
@class MTSubTrain;
@class MTBlockNode;
@interface MTTrainNode : MTSpriteNode

@property MTTrain * myTrain;
@property MTSubTrain * mySubTrain;
//@property (weak) MTTrainNode * mainTrainNode;

-(id)initWithPositon:(CGPoint) pos;

-(SKNode *) showSubTrain:(MTSubTrain *) subTrain;
-(void) fadeMeOut;
-(void) fadeMeIn;
-(void) moveMeToPoint:(CGPoint) pt;
-(CGPoint) getAbsolutePositionInCodeArea;
-(void) updatePositionInStorage;
-(CGFloat) getMyHeightRecursive;
-(void) onCartRemoved;
-(MTTrainNode*) getMainTrNode;
@end
