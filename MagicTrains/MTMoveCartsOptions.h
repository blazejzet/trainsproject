//
//  MTMoveCartsOptions.h
//  MagicTrains
//
//  Created by Mateusz Wieczorkowski on 12.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//
//  Opcje dotycza wagonow MTGoTop; MTGoDown; MTGoLeft; MTGoRight
//  Czyli takich, ktore korzystaja z opcji - dwa kola (time i distance) i zmiennych
//

#import <Foundation/Foundation.h>
#import "MTWheelPanel.h"

@interface MTMoveCartsOptions : NSObject <NSCoding>

@property MTWheelPanel *distancePanel;
@property MTWheelPanel *timePanel;

//nowe numery zaznaczonych zmiennych:

+(void)clear;
-(void) prepareOptions;
-(void) showOptions;
-(void) hideOptions;

@end
