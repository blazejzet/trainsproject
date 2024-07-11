//
//  MTGoDownCartOptions.h
//  MagicTrains
//
//  Created by Kamil Tomasiak on 26.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTPauseCart.h"
#import "MTWheelPanel.h"

@interface MTPauseCartOptions : NSObject <NSCoding>

@property MTWheelPanel *timePanel;

-(void) showOptions;
-(void) hideOptions;

+(void)clear;
@end