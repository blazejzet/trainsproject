//
//  MTStateOfSimulationGhostRepresentationNode.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 22.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTStateOfGhostRepresentationNode.h"

@interface MTStateOfSimulationGhostRepresentationNode : MTStateOfGhostRepresentationNode

-(void)setPositionOfRep:(MTGhostRepresentationNode *)rep WithPoint:(CGPoint)pt;
-(void)tapGesture:(UIGestureRecognizer *)g WithGhostRep:(MTGhostRepresentationNode *)rep;

@end
