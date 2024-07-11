//
//  MTCategoryIconNode.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 06.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTCategoryIconNode.h"
#import "MTCategoryBarNode.h"
#import "MTCategoryBarNode.h"
#import "MTAppOptionNode.h"
#import "MTGUI.h"
#import "MTHelpView.h"

@implementation MTCategoryIconNode

static MTCategoryIconNode* SelectedCategoryIconNode;


+(void) resetIcon{
    SelectedCategoryIconNode = nil;
}
-(void) makeMeSelected
{
    if (SelectedCategoryIconNode != nil && !([self.name isEqualToString:@"MTCategoryIconNode50"] && self == SelectedCategoryIconNode))
    {
        [SelectedCategoryIconNode makeMeUnselected];
    }

        self.colorBlendFactor = 0.4;
    
    SelectedCategoryIconNode = self;
    
    ////NSLog(@"SEL %d", SelectedCategoryIconNode.CategoryNumber);
    
    
    if (SelectedCategoryIconNode.CategoryNumber==1){
        MTHelpView.helpScreen=hs_cars1;
    }
    if (SelectedCategoryIconNode.CategoryNumber==2){
        MTHelpView.helpScreen=hs_cars2;
    }
    if (SelectedCategoryIconNode.CategoryNumber==3){
        MTHelpView.helpScreen=hs_cars3;
    }
    if (SelectedCategoryIconNode.CategoryNumber==4){
        MTHelpView.helpScreen=hs_cars4;
    }
    if (SelectedCategoryIconNode.CategoryNumber==5){
        MTHelpView.helpScreen=hs_cars5;
    }
    if (SelectedCategoryIconNode.CategoryNumber==6){
        MTHelpView.helpScreen=hs_cars6;
    }
    if (SelectedCategoryIconNode.CategoryNumber==50){
        MTHelpView.helpScreen=hs_cars7;
    }
}

+(MTCategoryIconNode *) getSelectedIconNode
{
    return SelectedCategoryIconNode;
}

-(void) makeMeUnselected
{
    self.colorBlendFactor = 0.0;
    MTHelpView.helpScreen=hs_desktop_notempty;

    SelectedCategoryIconNode = nil;
}

-(void) makeMeUnactive
{
    //zmienna isActive sprawdzana przy gestach
    [self removeAllActions];
    [self runAction:[SKAction fadeAlphaTo:0.2 duration:0.1]];
    self.isActive = false;
}

-(void) makeMeActive
{
    [self removeAllActions];
    [self runAction:[SKAction fadeAlphaTo:1.0 duration:0.1]];
    self.isActive = true;
}

-(void)tapGesture:(UIGestureRecognizer *)g
{
    if(self.isActive)
    {
        if (self.CategoryNumber != 50)
        {
            if(self != SelectedCategoryIconNode)
            {
                [self makeMeSelected];

                [((MTCategoryBarNode *)self.parent) closeOpenedOptions];
                [((MTCategoryBarNode *)self.parent) openBlocksArea];
                [((MTCategoryBarNode *)self.parent) closeAppOptions];
            }
        }
        
        if (self.CategoryNumber == 50)
        {
            if(self != SelectedCategoryIconNode)
                [self makeMeSelected];
            
            [((MTCategoryBarNode *)self.parent) closeOpenedOptions];
            [((MTCategoryBarNode *)self.parent) openBlocksArea];
            [((MTCategoryBarNode *)self.parent) openAppOptions];
        }
    }
}

-(void)panGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    if(self.isActive)
    {
        if (self.CategoryNumber != 50)
        {
        
            [self makeMeSelected];
            [((MTCategoryBarNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode" ] )panGesture:g :v ];
            [((MTCategoryBarNode *)self.parent) closeAppOptions];
        }
    }
}

@end
