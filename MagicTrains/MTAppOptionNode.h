//
//  MTAppOptionNode.h
//  MagicTrains
//
//  Created by Mateusz Wieczorkowski on 30.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTSpriteNode.h"

@interface MTAppOptionNode : MTSpriteNode

-(id) initDebugInPosition: (CGPoint)position;
-(id) initJoystickInPosition: (CGPoint)position;
-(id) initSaveInPosition: (CGPoint)position;
-(void) refleshOptions;

@property bool selected;

@end
