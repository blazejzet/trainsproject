//
//  MTGlobalVariableAction.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 14.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTGlobalVarAction.h"
#import "MTGlobalVariableCartsOptions.h"
#import "MTGlobalVar.h"
#import "MTGhostRepresentationNode.h"
#import "MTGUI.h"

@implementation MTGlobalVarAction

-(id) initWithSubTrain: (MTSubTrain *) t
{
    if(self = [super initWithSubTrain:t])
    {
        self.options = [[MTGlobalVariableCartsOptions alloc] init];
        self.isInstantCart = true;
    }
    return self;
}

-(int)getCategory
{
    return MTCategoryLogic;
}

-(CGFloat) checkRange: (CGFloat) newValue
{
    CGFloat value = newValue;
    
    if (newValue > 999)
    {
        value = 999;
    }
    else if (newValue < -999)
    {
        value = -999;
    }
    
    return value;
}

-(CGFloat) getSelectedValue : (MTGhostRepresentationNode*) ghostRepNode
{
    CGFloat value = [self.options.valuePanel getMySelectedValueWithGhostRepNode:ghostRepNode];
    
    return value;
}

-(void)showOptions
{
    [self.options showOptions];
}

-(void) hideOptions
{
    [self.options hideOptions];
}


@end
