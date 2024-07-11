//
//  MTSubTrain.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 31.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MTCart;
@class MTTrain;
@class MTGhostRepresentationNode;

@interface MTSubTrain : NSObject <NSCoding>

-(id) initWithTrain: (MTTrain *) train;
-(bool) addCart: (MTCart *) newCart;
-(bool) removeCart: (MTCart *) cart;
-(bool) removeAllCarts;

-(bool) insertCart: (MTCart *) cart AtIndex: (NSUInteger) i;
-(MTCart*)getCartAt: (uint) n;
-(bool) runMeWithGhostRep: (MTGhostRepresentationNode *)grn;
-(void) prepareForSimulation;
@property bool completion;
@property NSMutableArray *Carts;

@property uint nrOfNextCart;
///pole potrzebne do poprawnego odczytania licznika rozkazów podpociągu
@property uint myDepth;
@property MTTrain* myTrain;
//@property NSUInteger myNumber;
@property (weak) MTSubTrain* myParentSubTrain;
@property MTCart* myCartInParent;


@end
