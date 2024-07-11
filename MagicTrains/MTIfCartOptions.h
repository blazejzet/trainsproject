//
//  MTIfCartOptions.h
//  MagicTrains
//
//  Created by Kamil Tomasiak on 27.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTIfCart.h"
#import "MTCommonButtons.h"
#import "MTVisibleGlobalVar.h"
#import "MTConditionPanel.h"
#import "MTWheelPanel.h"

@interface MTIfCartOptions : NSObject <NSCoding>

@property MTWheelPanel *xPanel;
@property MTWheelPanel *yPanel;
@property MTConditionPanel *conditionPanel;
/*
@property MTConditionNode *conditionEqual;
@property MTConditionNode *conditionLower;
@property MTConditionNode *conditionGreater;
@property NSMutableArray *conditions;
-(void) uncheckConditions;
-(int) amountCheckedConditions;
 */
-(NSString *) getCondition;

-(void) showOptions;
-(void) hideOptions;


@end
