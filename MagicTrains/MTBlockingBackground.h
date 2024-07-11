//
//  MTBlockingBackground.h
//  MagicTrains
//
//  Created by Mateusz Wieczorkowski on 04.05.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTSpriteNode.h"

@interface MTBlockingBackground : NSObject

@property MTSpriteNode *sceneBackground;
@property MTSpriteNode *ghostMenuBackground;
@property MTSpriteNode *categoryBarBackground;
@property MTSpriteNode *codeBackground;

@property float duration;
@property UIColor* backgroundColor;
@property float backgroundAlpha;


-(id) initFullBackgroundWithDuration: (CGFloat)duration Color: (UIColor*)color Alpha: (CGFloat)alpha andWaitTime: (CGFloat)wait;
-(id) initCodeAreaBackgroundWithDuration: (CGFloat)duration Color: (UIColor*)color Alpha: (CGFloat)alpha andWaitTime: (CGFloat)wait;
-(void) removeBackground;

@end
