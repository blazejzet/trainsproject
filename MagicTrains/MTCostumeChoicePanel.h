//
//  MTVariableChoicePanel.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 21.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTOptionsPanel.h"
#import "MTGlobalVarForSetNode.h"

@interface MTCostumeChoicePanel : MTOptionsPanel



@property (nonatomic) int numberOfSelectedVariable;

@property NSMutableArray *myVariablesForSet;

-(void) prepareAsMiddlePanel;
-(void) uncheckGlobalVariables;
-(int) amountSelectedVariable;

@end
