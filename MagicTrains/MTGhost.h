//
//  MTGhostFactory.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.02.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MTGhostInstance;
@class MTGhostRepresentationNode;
@class MTTrain;
@interface MTGhost : NSObject <NSCoding>

-(id)initWithNr: (NSUInteger) n;

@property NSMutableArray *trains;
@property NSMutableArray *ghostInstances;

@property NSMutableArray* trainsForCollision;
@property NSMutableArray* trainsForCloneCollision;

@property NSMutableArray* trainsForWallCollision;
@property NSMutableArray* trainsForCloneWallCollision;


@property bool allowedCoding;
@property bool allowedTouching;
@property bool allowedOptions;
@property bool allowedClonning;

@property NSUInteger myNumber;
@property NSString *costumeName;
@property NSString *costumeCat;
@property CGFloat hp;
@property int initlalMass;
@property CGFloat hpInit;

-(void) addTrain: (MTTrain*) newTrain;
-(void) runMyTrainsWithGhostRepNode:(MTGhostRepresentationNode *) gRN;
//-(void) runMyTrainsWithGhostRepNodes:(NSArray *) gRN;
-(void) removeTrain: (MTTrain *) train;
-(CGFloat)getScaledMass;
-( MTTrain * ) getTrain: ( uint ) i;

-(id) CreateNewGhostInstance;
-(MTGhostInstance *) addNewInstance;

-(void) removeGhostInstance:(MTGhostInstance*)ghost;
-(MTGhostInstance *) getGhostInstanceAt:(uint)i;


-(bool) getAllowedCoding;
-(bool) getAllowedTouching;
-(bool) getAllowedOptions;
-(bool) getAllowedClonning;
-(void) setAllowedCodingToVal:(bool)val;
-(void) setAllowedTouchingToVal:(bool)val;
-(void) setAllowedOptionsToVal:(bool)val;
-(void) setAllowedColonningToVal:(bool)val;

-(NSUInteger) getMyNumber;
-(int)getIntHP;
-(void)setIntHP:(int)newhp;
-(int)mass;
-(void)setMass:(int)m;
@end 
