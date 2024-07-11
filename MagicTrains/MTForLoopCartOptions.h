//
//  MTForLoopCartOptions.h
//  MagicTrains
//
//  Created by Kamil Tomasiak on 27.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTForLoopCart.h"
#import "MTCommonButtons.h"
#import "MTVisibleGlobalVar.h"


@interface MTForLoopCartOptions : NSObject <NSCoding>

@property MTWheelPanel* loopValuePanel;
-(void) showOptions;
-(void) hideOptions;

@end
