//  MTGhostRepresentationNode.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.02.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//
#import "MTTrain.h"
#import "MTSpriteNode.h"
#import "MTGhostInstance.h"
#import "MTGhostIconNode.h"
#import "MTGhostRepresentationEventFlags.h"
#import "MTSpriteMoodNode.h"

@class MTExecutionData;
@class MTStateOfGhostRepresentationNode;


@interface MTGhostRepresentationNode : MTSpriteNode
@property MTStateOfGhostRepresentationNode* state;
@property MTGhostInstance *myGhostInstance;
@property MTGhostIconNode *myGhostIcon;
@property CGFloat hp;
@property MTGhostRepresentationEventFlags *myFlags;
@property bool userClone;
// @property bool blocked;
@property int tapanimationactive;
@property int moodState;
@property BOOL draw;
@property int massign;

@property NSString* ghostName;

//wskaznik na MTExecutionData
@property MTExecutionData * executionData;

/// TRUE = mozliwosc przesuwania reprezentacji po X'owych wspolrzednych
@property bool moveXInSimulation;

/// TRUE = mozliwosc przesuwania reprezentacji po Y'owych wspolrzednych
@property bool moveYInSimulation;

/// TRUE = mozliwosc reakcji reprezentacji na Joystick
@property bool affectByJoystick;



@property bool deleted;

@property CGPoint tmp;

-(void) prepareMeBeforSimulation;

-(void) getAttributesFromInstance;
-(void) setAttributesToInstance;
-(MTGhostRepresentationNode *) getSelectedRepresentationNode;
+(MTGhostRepresentationNode *) getSelectedRepresentationNode;
+(void)resetSelectedRepresentationNode;
-(id) initWithGhostInstance:(MTGhostInstance *)sourceInstance ghostIcon:(MTGhostIconNode *)icon;

-(id) initClone;

-(void)goIntoStateOfEditing;
-(void)goIntoStateOfSimulation;
-(void)goIntoStateOfConstant;

-(void)makeMeSelected;
-(void)makeMeUnselected;
-(void) setupMoodVisuals:(NSString*) dName;

-(void)resetMe;
-(void)remove;
-(void)startGravitating;
-(void)stopGravitating;
-(void)startReverseGravitating;
-(void)stopReverseGravitating;

-(BOOL)setPos:(CGPoint) pt;
-(void)setPhysics:(bool) flag;
-(void)setDynamics:(bool) flag;
-(void)setJoystick:(bool)value;
-(void)setGravitation:(bool)value;
-(void)setGravitationMy:(bool)value;
-(void)setMasSign:(int)value;

-(void)setReversedGravity:(bool)value;
-(void)setRotation:(CGFloat)rot;

-(void) setMoodState;
- (id)getVariableWithName:(NSString *)varName Class: (Class) aClass ForCartNo:(NSInteger) cartNo TrainNo: (NSInteger) trainNo;
- (void)setVariable: (id) variable WithName:(NSString *)varName ForCartNo:(NSInteger) cartNo TrainNo: (NSInteger) trainNo;
//fizyka
-(void) physicBodyForGhostRep: (MTGhostRepresentationNode*)rep  width:(CGFloat)width height: (CGFloat)height scale:(CGFloat) scale;
///-(void)addCommandsCounter:(NSMutableArray *)counter Train:(MTTrain *) train;
///-(void)resetCommandsCounterAt:(NSUInteger) index;
///-(NSMutableArray*)getCommandsCounterAt:(NSUInteger) index;
///-(void)setCommandsCounterAt:(NSUInteger) index;
///-(MTTrain*)getCommandsCounterTrainAt:(NSUInteger) index;

-(void)auc;

-(void)removeFromStage;

-(void)increaseHP;
-(void)decreaseHP;


-(void)sendSignal:(NSString*)color;
-(void)receiveSignal:(NSString*)color;

-(void)addNextJoint:(MTGhostRepresentationNode*)n;
-(void)removeMyJoints;
-(void)removeAllJoints;
-(void)removeJoints:(MTGhostRepresentationNode*)n;

-(void)startDrawing:(BOOL)b;

@end
