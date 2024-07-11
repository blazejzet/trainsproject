//
//  MTVariableOneChoicePanel.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 21.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTVariableOneChoicePanel.h"
#import "MTViewController.h"
#import "MTGUI.h"
@implementation MTVariableOneChoicePanel
@synthesize numberSelectedVariableForSet;
-(id)init
{
    self = [super init];
    self.myVariablesForSet = [[NSMutableArray alloc]init];
    self.var1ForSet = [[MTGlobalVarForSetNode alloc]init];
    self.var2ForSet = [[MTGlobalVarForSetNode alloc]init];
    self.var3ForSet = [[MTGlobalVarForSetNode alloc]init];
    self.var4ForSet = [[MTGlobalVarForSetNode alloc]init];
    
    [self.myVariablesForSet addObject:self.var1ForSet];
    [self.myVariablesForSet addObject:self.var2ForSet];
    [self.myVariablesForSet addObject:self.var3ForSet];
    [self.myVariablesForSet addObject:self.var4ForSet];
    return self;
}

-(void)setNumberSelectedVariableForSet:(NSUInteger)number
{
    
    for (int i = 0 ; i < self.myVariablesForSet.count;i++)
    {
        [(MTGlobalVarForSetNode*)self.myVariablesForSet[ i ] setChecked: NO];
    }
    if (number != 0)
    {
        [(MTGlobalVarForSetNode*)self.myVariablesForSet[number - 1] setChecked: YES];
    }
    numberSelectedVariableForSet = number;
}

-(void) preparePanel
{
    self.var1ForSet = [self.var1ForSet prepareWithNumberGlobalVariable:1 Image:@"varG1.png" position:CGPointMake(BLOCK_AREA_WIDTH-150 -120, 720) andParent:self kindOfGlobalVar:@"setGlobal" size:CGSizeMake(132, 132)];
    
    self.var2ForSet = [self.var2ForSet prepareWithNumberGlobalVariable:2 Image:@"varG2.png" position:CGPointMake(BLOCK_AREA_WIDTH-150 - 70, 620) andParent:self kindOfGlobalVar:@"setGlobal" size:CGSizeMake(132, 132)];
    
    self.var3ForSet = [self.var3ForSet prepareWithNumberGlobalVariable:3 Image:@"varG3.png" position:CGPointMake(BLOCK_AREA_WIDTH-150 + 70, 620) andParent:self kindOfGlobalVar:@"setGlobal" size:CGSizeMake(132, 132)];
    
    self.var4ForSet = [self.var4ForSet prepareWithNumberGlobalVariable:4 Image:@"varG4.png" position:CGPointMake(BLOCK_AREA_WIDTH-150 +120, 720) andParent:self kindOfGlobalVar:@"setGlobal" size:CGSizeMake(132, 132)];
    
}

-(void)showPanel
{
    MTCategoryBarNode *categoryBarNode = (MTCategoryBarNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
    
    [categoryBarNode addChild: self.var1ForSet];
    [categoryBarNode addChild: self.var2ForSet];
    [categoryBarNode addChild: self.var3ForSet];
    [categoryBarNode addChild: self.var4ForSet];
}
-(void)hidePanel
{
    [self.var1ForSet removeFromParent];
    [self.var2ForSet removeFromParent];
    [self.var3ForSet removeFromParent];
    [self.var4ForSet removeFromParent];
}

//----------------------------------------------------------------------------//
//       Serializacja                                                         //
//----------------------------------------------------------------------------//

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    [self setNumberSelectedVariableForSet: [aDecoder decodeIntegerForKey:@"numberSelectedVariable"]];
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger: self.numberSelectedVariableForSet forKey:@"numberSelectedVariable"];
}
@end
