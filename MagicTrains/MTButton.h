//
//  MTButton.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 24.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTSpriteNode.h"

#define N_ButtonTapped @"ButtonTapped"
#define N_ButtonHolded @"ButtonLongPressed"

@interface MTButton : MTSpriteNode

-(id)initWithText:(NSString *)text;
-(id)initWithImageOnActiveNamed:(NSString *)name;
-(id)initWithImageOnActiveNamed:(NSString *)nameActive imageOnUnactiveNamed:(NSString *) nameUnactive;

@property SKTexture *textureOnActive;
@property SKTexture *textureOnUnactive;
@property NSString *text;

@end
