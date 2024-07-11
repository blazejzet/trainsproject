//
//  MTStateOfEditingGhostRepresentationNode.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 22.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTStateOfGhostRepresentationNode.h"

@interface MTStateOfEditingGhostRepresentationNode : MTStateOfGhostRepresentationNode

-(void)panGesture:(UIGestureRecognizer *)g :(UIView *) v WithGhostRep:(MTGhostRepresentationNode *)rep;
-(void)tapGesture:(UIGestureRecognizer *)g WithGhostRep:(MTGhostRepresentationNode *)rep;
-(void)pinchGesture:(UIGestureRecognizer *)g :(UIView *)v WithGhostRep:(MTGhostRepresentationNode *)rep;
-(void)rotateGesture:(UIGestureRecognizer *)g :(UIView *)v WithGhostRep:(MTGhostRepresentationNode *)rep;

-(void)setPositionOfRep:(MTGhostRepresentationNode *)rep WithPoint:(CGPoint)pt;
-(void)setPositionOfAllReps;
@end
