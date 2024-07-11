//
//  MTIfCartOptions.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 27.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTIfCartOptions.h"
#import "MTCategoryBarNode.h"
#import "MTViewController.h"
#import "MTGUI.h"
#import "MTStorage.h"
#import "MTGhost.h"
#import "MTWheelPanel.h"
#import "MTConditionPanel.h"

@implementation MTIfCartOptions

-(id) init
{
    self.xPanel = [[MTWheelPanel alloc] init];
    self.yPanel = [[MTWheelPanel alloc] init];
    self.conditionPanel = [[MTConditionPanel alloc] init];
    //self.conditions = [[NSMutableArray alloc] init];
    
    [self prepareOptions];
    return self;
    
}

-(void) prepareOptions
{
    [self.xPanel prepareAsUpperPanelWithMax: MAX_X_IF_VALUE Min: MIN_X_IF_VALUE fullRotate: MAX_X_IF_VALUE/2];
    [self.yPanel prepareAsLowerPanelWithMax: MAX_Y_IF_VALUE Min: MIN_Y_IF_VALUE fullRotate: MAX_Y_IF_VALUE/2];
    [self.conditionPanel preparePanel];
    
    //warunki
    /*
    MTConditionNode *conditionLower = [[MTConditionNode alloc] initWithImageNamed:@"conditionLower.png" position:CGPointMake(BLOCK_AREA_WIDTH-150 - 70, 375) andParent:self];
    conditionLower.name = @"<";
    self.conditionLower = conditionLower;
    [self.conditions addObject:self.conditionLower];
    
    MTConditionNode *conditionEqual = [[MTConditionNode alloc] initWithImageNamed:@"conditionEqual.png" position:CGPointMake(BLOCK_AREA_WIDTH-150, 375) andParent:self];
    conditionEqual.name = @"=";
    conditionEqual.checked = YES;
    conditionEqual.alpha = 1;
    self.conditionEqual = conditionEqual;
    [self.conditions addObject:self.conditionEqual];
    
    MTConditionNode *conditionGreater = [[MTConditionNode alloc] initWithImageNamed:@"conditionGreater.png" position:CGPointMake(BLOCK_AREA_WIDTH-150 + 70, 375) andParent:self];
    conditionGreater.name = @">";
    self.conditionGreater = conditionGreater;
    [self.conditions addObject:self.conditionGreater];*/
    
    //koniec warunkow
    
}

-(void) showOptions
{
    MTCategoryBarNode *categoryBarNode = (MTCategoryBarNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
    
    if (categoryBarNode.someOptionsOpened == false)
    {
    
        [self.xPanel showPanel];
        [self.yPanel showPanel];
        [self.conditionPanel showPanel];
        [categoryBarNode openBlocksArea];
        
        categoryBarNode.someOptionsOpened = true;
    }
}

-(void) hideOptions
{
    MTCategoryBarNode *categoryBarNode = (MTCategoryBarNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
    
    [self.xPanel hidePanel];
    [self.yPanel hidePanel];
    [self.conditionPanel hidePanel];
    categoryBarNode.someOptionsOpened = false;
}

-(int) amountCheckedConditions
{
    return [self.conditionPanel amountCheckedConditions];
}

-(void) uncheckConditions
{
    [self.conditionPanel uncheckConditions];
}

-(NSString *) getCondition
{
    return [self.conditionPanel getCondition];
}
///--------------------------------------------------------------------------///
// Serializacja                                                               //
///--------------------------------------------------------------------------///

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.xPanel = [aDecoder decodeObjectForKey:@"xPanel"];
    self.yPanel = [aDecoder decodeObjectForKey:@"yPanel"];
    self.conditionPanel = [aDecoder decodeObjectForKey:@"conditionPanel"];
    [self prepareOptions];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.xPanel forKey:@"xPanel"];
    [aCoder encodeObject:self.yPanel forKey:@"yPanel"];
    [aCoder encodeObject:self.conditionPanel forKey:@"conditionPanel"];
}
@end

