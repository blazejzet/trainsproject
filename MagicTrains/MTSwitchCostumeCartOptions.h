//
//  MTShowGlobalVarOptions.h
//  MagicTrains
//
//  Created by Kamil Tomasiak on 30.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCart.h"
#import "MTCostumeChoicePanel.h"

@interface MTSwitchCostumeCartOptions : MTCart <NSCoding>

@property MTCostumeChoicePanel *varForSetPanel;

-(void) uncheckGlobalVariables;
-(NSMutableArray *) getSelectVariable;
-(int) amountSelectedVariable;

@end
