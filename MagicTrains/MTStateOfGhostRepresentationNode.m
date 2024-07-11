//
//  MTStateOfGhostRepresentationNode.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 22.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTStateOfGhostRepresentationNode.h"
#import "MTStateOfEditingGhostRepresentationNode.h"
#import "MTStateOfSimulationGhostRepresentationNode.h"
#import "MTStateOfConstantGhostRepresentationNode.h"

@implementation MTStateOfGhostRepresentationNode

static MTStateOfEditingGhostRepresentationNode* InstanceOfStateOfEditing;

+(MTStateOfGhostRepresentationNode *) getMTStateOfEditingGhostRepresentationNode
{
    if (InstanceOfStateOfEditing == NULL)
    {
        InstanceOfStateOfEditing = [[MTStateOfEditingGhostRepresentationNode alloc] init];
    }
    return (MTStateOfGhostRepresentationNode *)InstanceOfStateOfEditing;
}

static MTStateOfSimulationGhostRepresentationNode* InstanceOfStateOfSimulation;

+(MTStateOfGhostRepresentationNode *) getMTStateOfSimulationGhostRepresentationNode
{
    if (InstanceOfStateOfSimulation == NULL)
    {
        InstanceOfStateOfSimulation = [[MTStateOfSimulationGhostRepresentationNode alloc] init];
    }
    return (MTStateOfGhostRepresentationNode *)InstanceOfStateOfSimulation;
}

static MTStateOfConstantGhostRepresentationNode* InstanceOfConstantOfSimulation;

+(MTStateOfGhostRepresentationNode *) getMTStateOfConstantGhostRepresentationNode
{
    if (InstanceOfConstantOfSimulation == NULL)
    {
        InstanceOfConstantOfSimulation = [[MTStateOfConstantGhostRepresentationNode alloc] init];
    }
    return (MTStateOfGhostRepresentationNode *)InstanceOfStateOfSimulation;
}

-(void)panGesture:(UIGestureRecognizer *)g :(UIView *) v WithGhostRep:(MTGhostRepresentationNode *)rep
{}

-(void)tapGesture:(UIGestureRecognizer *)g WithGhostRep:(MTGhostRepresentationNode *)rep
{}

-(void)pinchGesture:(UIGestureRecognizer *)g :(UIView *)v WithGhostRep:(MTGhostRepresentationNode *)rep
{}

-(void)rotateGesture:(UIGestureRecognizer *)g :(UIView *)v WithGhostRep:(MTGhostRepresentationNode *)rep
{}
-(void)holdGesture:(UIGestureRecognizer *)g :(UIView *)v WithGhostRep:(MTGhostRepresentationNode *) rep
{}

-(void)setPositionOfRep:(MTGhostRepresentationNode *)rep WithPoint:(CGPoint)pt
{}
-(void)setHPOfRep:(MTGhostRepresentationNode *)rep WithUint:(uint)hp
{}
-(void)setRotationOfRep:(MTGhostRepresentationNode *)rep WithAngle:(CGFloat)a
{}
-(void)setScaleOfRep:(MTGhostRepresentationNode *)rep WithScale:(CGFloat)a
{}
-(void)setPhysics:(MTGhostRepresentationNode *)rep ToValue:(BOOL)blocked
{}
-(void)setDynamics:(MTGhostRepresentationNode *)rep ToValue:(BOOL)blocked
{}
-(void)setGravity:(MTGhostRepresentationNode *)rep ToValue:(BOOL)blocked
{}
-(void)setGravitation:(MTGhostRepresentationNode *)rep ToValue:(BOOL)val
{}
-(void)setGravitationMy:(MTGhostRepresentationNode *)rep ToValue:(BOOL)val
{}

-(void)setMasMy:(MTGhostRepresentationNode *)rep ToValue:(int)val
{}


-(void)setReversedGravity:(MTGhostRepresentationNode *)rep ToValue:(BOOL)value
{}
-(void)setJoystick:(MTGhostRepresentationNode *)rep ToValue:(BOOL)val
{}


@end
