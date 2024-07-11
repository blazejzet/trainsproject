//
//  MTConditionPanel.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 21.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTConditionPanel.h"
#import "MTGUI.h"
#import "MTViewController.h"
#import "MTCategoryBarNode.h"
@implementation MTConditionPanel

-(id)init
{
    self.conditions = [[NSMutableArray alloc]init];
    
    self.conditionLower   = [[MTConditionNode alloc] initWithImageNamed:@"conditionLower.png"];
    self.conditionEqual   = [[MTConditionNode alloc] initWithImageNamed:@"conditionEqual.png"];
    self.conditionGreater = [[MTConditionNode alloc] initWithImageNamed:@"conditionGreater.png"];
    
    self.conditionEqual.checked = YES;
    
    [self.conditions addObject: self.conditionLower];
    [self.conditions addObject: self.conditionEqual];
    [self.conditions addObject: self.conditionGreater];
    
    return self;
}

-(void)preparePanel
{
    [self.conditionLower prepareWithImageNamed:@"conditionLower.png" position:CGPointMake(BLOCK_AREA_WIDTH-150 - 70, 375) andParent:self];
    self.conditionLower.name = @"<";

    [self.conditionEqual prepareWithImageNamed:@"conditionEqual.png" position:CGPointMake(BLOCK_AREA_WIDTH-150, 375) andParent:self];
    self.conditionEqual.name = @"=";

    [self.conditionGreater prepareWithImageNamed:@"conditionGreater.png" position:CGPointMake(BLOCK_AREA_WIDTH-150 + 70, 375) andParent:self];
    self.conditionGreater.name = @">";
}

-(int)amountCheckedConditions
{
    int amount = 0;
    
    for(int i = 0; i < self.conditions.count; i++)
    {
        if (((MTConditionNode *)self.conditions[i]).checked == YES)
        {
            amount++;
        }
    }
    return amount;
}

-(void) uncheckConditions
{
    for(int i = 0; i < self.conditions.count; i++)
    {
        ((MTConditionNode *)self.conditions[i]).checked = NO;
        ((MTConditionNode *)self.conditions[i]).alpha = 0.3;
    }
}
-(NSString *) getCondition
{
    NSString *condition= @"";
    
    for(int i = 0; i < self.conditions.count; i++)
    {
        if (((MTConditionNode *)self.conditions[i]).checked == YES)
        {
            condition = [NSString stringWithFormat:@"%@%@", condition, ((MTConditionNode *)self.conditions[i]).name];
        }
    }
    
    return condition;
}

-(void)showPanel{
    MTCategoryBarNode *categoryBarNode = (MTCategoryBarNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
    [categoryBarNode addChild: self.conditionLower];
    [categoryBarNode addChild: self.conditionGreater];
    [categoryBarNode addChild: self.conditionEqual];
}

-(void)hidePanel
{
    [self.conditionLower removeFromParent];
    [self.conditionEqual removeFromParent];
    [self.conditionGreater removeFromParent];
}
//----------------------------------------------------------------------------//
//       Serializacja                                                         //
//----------------------------------------------------------------------------//
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    [self.conditionEqual setChecked:[aDecoder decodeBoolForKey:@"conditionEqualChecked"]];
    [self.conditionGreater setChecked:[aDecoder decodeBoolForKey:@"conditionGreaterChecked"]];
    [self.conditionLower setChecked:[aDecoder decodeBoolForKey:@"conditionLowerChecked"]];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool: self.conditionEqual.checked forKey:@"conditionEqualChecked"];
    [aCoder encodeBool: self.conditionGreater.checked forKey:@"conditionGreaterChecked"];
    [aCoder encodeBool: self.conditionLower.checked forKey:@"conditionLowerChecked"];
}
@end
