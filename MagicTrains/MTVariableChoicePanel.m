//
//  MTVariableChoicePanel.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 21.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTVariableChoicePanel.h"
#import "MTGlobalVarForSetNode.h"
#import "MTCategoryBarNode.h"
#import "MTViewController.h"
#import "MTGUI.h"


@implementation MTVariableChoicePanel
@synthesize numberOfSelectedVariable;

-(id)init
{
    self.myVariablesForSet = [[NSMutableArray alloc] init];
    self.var1ForSet = [[MTGlobalVarForSetNode alloc] init];
    self.var2ForSet = [[MTGlobalVarForSetNode alloc] init];
    self.var3ForSet = [[MTGlobalVarForSetNode alloc] init];
    self.var4ForSet = [[MTGlobalVarForSetNode alloc] init];
    return self;
}

-(void)setNumberOfSelectedVariable:(int)number
{
    for (int i=0 ; i < self.myVariablesForSet.count;i++)
    {
        if ([self.myVariablesForSet[i] checked])
        [self.myVariablesForSet[i] setAlpha:1.0];
    }
    
    numberOfSelectedVariable = number;
}

-(void) prepareAsMiddlePanel
{
    self.var1ForSet = [self.var1ForSet prepareWithNumberGlobalVariable:1 Image:@"varG1.png" position:CGPointMake(BLOCK_AREA_WIDTH-150, 550) andParent:self kindOfGlobalVar:@"showGlobal" size:CGSizeMake(132, 132)];
 
    self.var2ForSet = [self.var2ForSet prepareWithNumberGlobalVariable:2 Image:@"varG2.png" position:CGPointMake(BLOCK_AREA_WIDTH-150, 450) andParent:self kindOfGlobalVar:@"showGlobal" size:CGSizeMake(132, 132)];
    
    self.var3ForSet = [self.var3ForSet prepareWithNumberGlobalVariable:3 Image:@"varG3.png" position:CGPointMake(BLOCK_AREA_WIDTH-150, 350) andParent:self kindOfGlobalVar:@"showGlobal" size:CGSizeMake(132, 132)];
    
    self.var4ForSet = [self.var4ForSet prepareWithNumberGlobalVariable:4 Image:@"varG4.png" position:CGPointMake(BLOCK_AREA_WIDTH-150, 250) andParent:self kindOfGlobalVar:@"showGlobal" size:CGSizeMake(132, 132)];
    
    [self.myVariablesForSet addObject: self.var1ForSet];
    [self.myVariablesForSet addObject: self.var2ForSet];
    [self.myVariablesForSet addObject: self.var3ForSet];
    [self.myVariablesForSet addObject: self.var4ForSet];
}

-(void) uncheckGlobalVariables
{
    for(int i = 0; i < self.myVariablesForSet.count; i++)
    {
        ((MTGlobalVarForSetNode *)self.myVariablesForSet[i]).checked = NO;
    }
}

-(int) amountSelectedVariable
{
    int amount =0;
    
    for(int i = 0; i < self.myVariablesForSet.count; i++)
    {
        if (((MTGlobalVarForSetNode *)self.myVariablesForSet[i]).checked == YES)
        {
            amount ++;
        }
    }
    return amount;
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
-(int) getNumberOfSelectedVariable
{
    return numberOfSelectedVariable;
}

//--------------------------------------------------------------------------//
//       Serializacja                                                         //
//--------------------------------------------------------------------------//
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    self.var1ForSet.checked = [aDecoder decodeBoolForKey:@"v1Checked"];
    self.var2ForSet.checked = [aDecoder decodeBoolForKey:@"v2Checked"];
    self.var3ForSet.checked = [aDecoder decodeBoolForKey:@"v3Checked"];
    self.var4ForSet.checked = [aDecoder decodeBoolForKey:@"v4Checked"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool: self.var1ForSet.checked forKey:@"v1Checked"];
    [aCoder encodeBool: self.var2ForSet.checked forKey:@"v2Checked"];
    [aCoder encodeBool: self.var3ForSet.checked forKey:@"v3Checked"];
    [aCoder encodeBool: self.var4ForSet.checked forKey:@"v4Checked"];
}
@end
