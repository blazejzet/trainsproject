//
//  MTGlobalVarPlusVariableCartOptions.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 28.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTGlobalVariableCartsOptions.h"
#import "MTStorage.h"
#import "MTVisibleGlobalVar.h"
#import "MTGUI.h"
#import "MTViewController.h"
#import "MTCategoryBarNode.h"
#import "MTGlobalVarForSetNode.h"
#import "MTGlobalVar.h"

@implementation MTGlobalVariableCartsOptions


-(id) init
{
    if (self = [super init])
    {
        self.valuePanel = [[MTWheelPanel alloc] init];
        
        self.choicePanel = [[MTVariableOneChoicePanel alloc] init];
        
        [self prepareOptions];
        return self;
    }
    return nil;
}

-(void) prepareOptions
{
    
    [self.valuePanel prepareAsMidLowPanelWithMax: MAX_GLOBAL_VALUE Min: MIN_GLOBAL_VALUE fullRotate:MAX_GLOBAL_VALUE /2 ];
    
    [self.choicePanel preparePanel];
}

-(void) showOptions
{
    
    MTCategoryBarNode *categoryBarNode = (MTCategoryBarNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
    
    if (categoryBarNode.someOptionsOpened == false)
    {
        [self.valuePanel showPanel];
        [self.choicePanel showPanel];
        
        [categoryBarNode openBlocksArea];
        
        categoryBarNode.someOptionsOpened = true;
    }
}

-(void) hideOptions
{
    MTCategoryBarNode *categoryBarNode = (MTCategoryBarNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
    
    [self.valuePanel hidePanel];
    [self.choicePanel hidePanel];
    
    categoryBarNode.someOptionsOpened = false;
}

///--------------------------------------------------------------------------///
// Serializacja                                                               //
///--------------------------------------------------------------------------///

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.valuePanel = [aDecoder decodeObjectForKey:@"valuePanel"];
    self.choicePanel = [aDecoder decodeObjectForKey:@"choicePanel"];
    [self prepareOptions];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject: self.valuePanel forKey:@"valuePanel"];
    [aCoder encodeObject: self.choicePanel forKey:@"choicePanel"];
}
@end
