//
//  MTVariableChoicePanel.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 21.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCostumeChoicePanel.h"
#import "MTGlobalVarForSetNode.h"
#import "MTCategoryBarNode.h"
#import "MTViewController.h"
#import "MTGUI.h"
#import "MTStorage.h"


@implementation MTCostumeChoicePanel
@synthesize numberOfSelectedVariable;

-(id)init
{
    self.myVariablesForSet = [[NSMutableArray alloc] init];
    for(int i=1;i<=CURRENT_GGHOST_COUNT;i++){
              MTGlobalVarForSetNode* vs=[[MTGlobalVarForSetNode alloc] init];
       [self.myVariablesForSet addObject:vs];
    }
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
    for(int i = 0; i < self.myVariablesForSet.count; i++)
    {
        MTGlobalVarForSetNode* vs=((MTGlobalVarForSetNode *)self.myVariablesForSet[i]);
        int j=i;
        int y = j/4;
        int x = j %4;
        
       vs = [vs prepareWithNumberGlobalVariable:i+1 Image:[NSString stringWithFormat:@"D%d_C1.png",i+1] position:CGPointMake(BLOCK_AREA_WIDTH-280+x*90, 700-y*90) andParent:self kindOfGlobalVar:@"showGlobal" size:CGSizeMake(70, 70)];
        
}


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
    
    for(int i = 0; i < self.myVariablesForSet.count; i++)
    {
        [categoryBarNode addChild: (MTGlobalVarForSetNode *)self.myVariablesForSet[i]];
        
    }
    for(int i = 0; i < self.myVariablesForSet.count; i++)
    {
        ////NSLog(@"%d: %d",i+1,((MTGlobalVarForSetNode *)self.myVariablesForSet[i]).checked);
        
    }

}
-(void)hidePanel
{
    for(int i = 0; i < self.myVariablesForSet.count; i++)
    {
       [(MTGlobalVarForSetNode *)self.myVariablesForSet[i] removeFromParent];
        
    }

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
    for(int i = 0; i < self.myVariablesForSet.count; i++)
    {
       [((MTGlobalVarForSetNode *)self.myVariablesForSet[i]) setChecked:[aDecoder decodeBoolForKey:[NSString stringWithFormat:@"xv%dChecked",i+1]]];
        
    }


return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    for(int i = 0; i < self.myVariablesForSet.count; i++)
    {
        [aCoder encodeBool: ((MTGlobalVarForSetNode *)self.myVariablesForSet[i]).checked forKey:[NSString stringWithFormat:@"xv%dChecked",i+1]];
        
    }


}
@end
