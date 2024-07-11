//
//  MTConditionPanel.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 21.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTOptionsPanel.h"
#import "MTConditionNode.h"
@interface MTConditionPanel : MTOptionsPanel

@property MTConditionNode *conditionEqual;
@property MTConditionNode *conditionLower;
@property MTConditionNode *conditionGreater;
@property NSMutableArray *conditions;
-(void) preparePanel;
-(void) uncheckConditions;
-(int) amountCheckedConditions;
-(NSString *) getCondition;

@end
