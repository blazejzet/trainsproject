//
//  MTShowGlobalVar1.h
//  MagicTrains
//
//  Created by Mateusz Wieczorkowski on 30.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCart.h"

@class MTSwitchCostumeCart;
@class MTSwitchCostumeCartOptions;
@interface MTSwitchCostumeCart : MTCart

@property MTSwitchCostumeCartOptions * options;

-(BOOL)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode;

@end
