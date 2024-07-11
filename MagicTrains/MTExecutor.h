//
//  MTResolver.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 09.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MTGhostRepresentationNode;
@class MTGhost;
@class MTTrain;
@interface MTExecutor : NSObject

@property NSArray* GhostRepNodes;
@property NSMutableArray* UserCloneNodes;
@property bool simulationStarted;
@property NSTimer *gyroTimer;
@property NSLock *lock;
@property bool useCM;

@property NSOperationQueue *test;

@property NSMutableArray *variablesArray;
+(void)clear;
+(MTExecutor *) getInstance;
-(void) remove;
-(void) executeCode;
-(void) stopSimulation;
-(void) processFrameOfSimulationWithTime: (CFTimeInterval) timeSinceLastUpdate;
-(void) prepareExecutionDataForGhostRepNode:(MTGhostRepresentationNode*) GRN;
-(void) changeStateForAllGhosts;

@end
