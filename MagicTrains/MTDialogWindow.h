//
//  MTDialogWindow.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 24.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTSpriteNode.h"
#import "MTButton.h"
#import "MTLabelTextNode.h"
#import "MTBlockingBackground.h"

#define N_DialogOKTapped  @"DialogOKTapped"
#define N_DialogOffTapped @"DialogOffTapped"
@interface MTDialogWindow : MTSpriteNode

@property MTButton *OKButton;
@property MTButton *CancelButton;
@property MTSpriteNode *content;
@property MTLabelTextNode *descriptionLabel;

-(id)initWithContent:(MTSpriteNode *)content;

@end
