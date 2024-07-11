//
//  MTRotationCartOptions.h
//  MagicTrains
//
//  Created by Kamil Tomasiak on 12.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTResizeCart.h"
//#import "MTCommonButtons.h"
//#import "MTVisibleGlobalVar.h"
#import "MTWheelPanel.h"


@interface MTResizeCartOptions : NSObject <NSCoding>

@property MTWheelPanel* timePanel;
@property MTWheelPanel* anglePanel;

-(void) showOptions;
-(void) hideOptions;

+(void)clear;
@end

