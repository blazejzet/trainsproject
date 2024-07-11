//
//  MTMoveCartsOptions.h
//  MagicTrains
//
//  Created by Mateusz Wieczorkowski on 12.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTGoXYCart.h"
#import "MTWheelPanel.h"

@interface MTGoXYCartOptions : MTGoXYCart <NSCoding>

@property MTWheelPanel* xPanel;
@property MTWheelPanel* yPanel;

+(void)clear;
-(void) showOptions;
-(void) hideOptions;

@end
