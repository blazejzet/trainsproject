//
//  MTShowGlobalVarOptions.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 30.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTShowGlobalVarOptions.h"
#import "MTGlobalVarForSetNode.h"
#import "MTGUI.h"
#import "MTViewController.h"
#import "MTCategoryBarNode.h"

@implementation MTShowGlobalVarOptions

-(id) init
{
    self.varForSetPanel = [[MTVariableChoicePanel alloc] init];
    
    [self prepareOptions];
    
    [self uncheckGlobalVariables];
    
    return self;
}

-(NSMutableArray *)getSelectVariable
{
    return self.varForSetPanel.myVariablesForSet;
}


-(void) prepareOptions
{
    [self.varForSetPanel prepareAsMiddlePanel];
}

-(void) uncheckGlobalVariables
{
    [self.varForSetPanel uncheckGlobalVariables];
}

-(int) amountSelectedVariable
{
    return [self.varForSetPanel amountSelectedVariable];
}

-(void) showOptions
{
    MTCategoryBarNode *categoryBarNode = (MTCategoryBarNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
    
    if (categoryBarNode.someOptionsOpened == false)
    {
        categoryBarNode.someOptionsOpened = true;

        [self.varForSetPanel showPanel];
        
        [categoryBarNode openBlocksArea];
    }
}

-(void) hideOptions
{
    MTCategoryBarNode *categoryBarNode = (MTCategoryBarNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
    
    [self.varForSetPanel hidePanel];
    
    categoryBarNode.someOptionsOpened = false;
}
///--------------------------------------------------------------------------///
// Serializacja                                                               //
///--------------------------------------------------------------------------///
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.varForSetPanel = [aDecoder decodeObjectForKey:@"panel"];
    
    [self prepareOptions];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.varForSetPanel forKey:@"panel"];
}
@end
