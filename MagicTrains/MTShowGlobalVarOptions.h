//
//  MTShowGlobalVarOptions.h
//  MagicTrains
//
//  Created by Kamil Tomasiak on 30.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCart.h"
#import "MTVariableChoicePanel.h"

@interface MTShowGlobalVarOptions : MTCart <NSCoding>

@property  MTVariableChoicePanel *varForSetPanel;

-(void) uncheckGlobalVariables;
-(NSMutableArray *) getSelectVariable;
-(int) amountSelectedVariable;

@end
