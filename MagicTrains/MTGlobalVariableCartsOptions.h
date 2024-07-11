//
//  MTGlobalVarPlusVariableCartOptions.h
//  MagicTrains
//
//  Created by Kamil Tomasiak on 28.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTGlobalVarPlusVariableCart.h"
#import "MTWheelPanel.h"
#import "MTVariableOneChoicePanel.h"
@interface MTGlobalVariableCartsOptions : NSObject <NSCoding>

@property MTWheelPanel *valuePanel;
@property MTVariableOneChoicePanel *choicePanel;
-(void) showOptions;
-(void) hideOptions;
//-(CGFloat  *) getValue;

//nowe numery zaznaczonych zmiennych:

@end
