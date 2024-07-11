//
//  MTTrain.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 09.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTSubTrain.h"
@class MTGhostRepresentationNode;
@class MTCart;
@class MTGhost;
@class MTSubTrain;

@interface MTTrain : NSObject <NSCoding>

-(id)initWithTabNr:(uint)nr
             ghost:(MTGhost*)ghost
          position:(CGPoint) pos;

-(void) prepareMeBeforeSimulation;
-(void) consolidateCode;
-(bool) runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode;
-(bool) addCart: (MTCart *) newCart;
-(bool) insertCart: (MTCart *) newCart AtIndex:(int) index;
-(void) updateMyNumber;
-(MTCart* ) getFirstCart;

-(uint) getTabNumber;

@property NSMutableArray* code;
@property CGPoint positionInCodeArea;
@property MTSubTrain* mainSubTrain;
@property uint tabNr;
@property NSUInteger myNumber;
@property MTGhost* myGhost;


@end
