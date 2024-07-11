//
//  MTGlobalVariableAction.h
//  MagicTrains
//
//  Created by Kamil Tomasiak on 14.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCart.h"
@class MTGlobalVariableCartsOptions;
@class MTGhostRepresentationNode;

@interface MTGlobalVarAction : MTCart

@property MTGlobalVariableCartsOptions *options;

-(id) initWithSubTrain: (MTSubTrain *) t;
-(int)getCategory;
-(CGFloat) getSelectedValue : (MTGhostRepresentationNode*) ghostRepNodel;
-(CGFloat) checkRange: (CGFloat) newValue;
-(void)showOptions;
-(void) hideOptions;

@end
