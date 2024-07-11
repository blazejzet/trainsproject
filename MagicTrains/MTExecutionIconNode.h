//
//  MTCompilationIconNode.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 19.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTSpriteNode.h"

@interface MTExecutionIconNode : MTSpriteNode

-(void) tapGesture:(UIGestureRecognizer *)g;

/*Obiekt zawiera obsluge animacji bezczynnosci*/
@property(nonatomic) NSTimer* timer;
@property float idleTime;
@property float randomTime;

@end
