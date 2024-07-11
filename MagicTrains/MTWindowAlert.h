//
//  MTWindowAlert.h
//  MagicTrains
//
//  Created by Kamil Tomasiak on 30.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTSpriteNode.h"
#import "MTLabelTextNode.h"
#import "MTGhost.h"
#import "MTGhostsBarNode.h"
#import "MTGhostRepresentationNode.h"
#import "MTBlockNode.h"
#import "MTTrain.h"
#import "MTBlockingBackground.h"

@interface MTWindowAlert : MTSpriteNode

-(id) initWithGhost: (MTGhost *)gt ghostBarNode : (MTGhostsBarNode *)gBar ghostRepresentationNode: (MTGhostRepresentationNode *) ghostRep;
-(id) initWithNode: (MTBlockNode*)b CB:(void(^)(void))cb;
-(id) initWithNode: (MTBlockNode*)b inContainer:(SKNode*)cont CB:(void(^)(void))cb;
-(id) initWithBlock : (MTBlockNode *) block;
-(id) initRemoveAllClones;

-(void) startThread;
-(void)cancel;
-(void) removeMe;

@property bool flag;
@property double progressv;
@property MTLabelTextNode * label;
@property MTLabelTextNode * timeLabel;
@property SKShapeNode * progress;
@property NSThread* myThread;
@property NSCondition* myLock;
@property MTGhost * gt;
@property MTGhostsBarNode * gBar;
@property MTGhostRepresentationNode * ghostRep;

@property MTGhost * ghost;
@property MTTrain * train;
@property MTBlockNode * block;

@property MTBlockingBackground * background;

@end
