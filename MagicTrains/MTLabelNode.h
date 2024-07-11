//
//  MTLabelNode.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 23.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MTGestureDelegate.h"

@interface MTLabelNode : SKLabelNode <MTGestureDelegate>

@property BOOL selected;  

@end
