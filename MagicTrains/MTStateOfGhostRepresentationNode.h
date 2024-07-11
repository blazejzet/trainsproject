//
//  MTStateOfGhostRepresentationNode.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 22.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MTGhostRepresentationNode;
@class MTStateOfEditingGhostRepresentationNode;
@class MTStateOfSimulationGhostRepresentationNode;

@interface MTStateOfGhostRepresentationNode : NSObject

+(MTStateOfGhostRepresentationNode *) getMTStateOfEditingGhostRepresentationNode;
+(MTStateOfGhostRepresentationNode *) getMTStateOfSimulationGhostRepresentationNode;
+(MTStateOfGhostRepresentationNode *) getMTStateOfConstantGhostRepresentationNode;

-(void)panGesture:(UIGestureRecognizer *)g :(UIView *) v WithGhostRep:(MTGhostRepresentationNode *)rep;
-(void)tapGesture:(UIGestureRecognizer *)g WithGhostRep:(MTGhostRepresentationNode *)rep;
-(void)pinchGesture:(UIGestureRecognizer *)g :(UIView *)v WithGhostRep:(MTGhostRepresentationNode *)rep;
-(void)rotateGesture:(UIGestureRecognizer *)g :(UIView *)v WithGhostRep:(MTGhostRepresentationNode *)rep;
-(void)holdGesture:(UIGestureRecognizer *)g :(UIView *)v WithGhostRep:(MTGhostRepresentationNode *) rep;

-(void)setPositionOfRep:(MTGhostRepresentationNode *)rep WithPoint:(CGPoint)pt;

-(void)setHPOfRep:(MTGhostRepresentationNode *)rep WithUint:(uint)hp;

-(void)setRotationOfRep:(MTGhostRepresentationNode *)rep WithAngle:(CGFloat)a;

-(void)setScaleOfRep:(MTGhostRepresentationNode *)rep WithScale:(CGFloat)a;

-(void)setPhysics:(MTGhostRepresentationNode *)rep ToValue:(BOOL)val;

-(void)setDynamics:(MTGhostRepresentationNode *)rep ToValue:(BOOL)blocked;

-(void)setGravity:(MTGhostRepresentationNode *)rep ToValue:(BOOL)val;

-(void)setGravitation:(MTGhostRepresentationNode *)rep ToValue:(BOOL)val;
-(void)setGravitationMy:(MTGhostRepresentationNode *)rep ToValue:(BOOL)val;

-(void)setReversedGravity:(MTGhostRepresentationNode *)rep ToValue:(BOOL)value;

-(void)setJoystick:(MTGhostRepresentationNode *)rep ToValue:(BOOL)val;
-(void)setMasMy:(MTGhostRepresentationNode *)rep ToValue:(int)val;

@end
