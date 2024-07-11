//
//  MTForLoopCartOptions.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 27.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTForLoopCartOptions.h"
#import "MTCategoryBarNode.h"
#import "MTViewController.h"
#import "MTWheelPanel.h"
#import "MTGhost.h"
#import "MTVisibleGlobalVar.h"
#import "MTGUI.h"
#import "MTStorage.h"

@implementation MTForLoopCartOptions

-(id) init
{
    self.loopValuePanel = [[MTWheelPanel alloc] init];
    
    [self prepareOptions];
    return self;
}

-(void) prepareOptions
{
    [self.loopValuePanel prepareAsMiddlePanelWithMax:MAX_LOOP_VALUE Min:MIN_LOOP_VALUE fullRotate:MAX_LOOP_VALUE /2];
}

-(void) showOptions
{
 
    MTCategoryBarNode *categoryBarNode = (MTCategoryBarNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
    
    if (categoryBarNode.someOptionsOpened == false)
    {
        categoryBarNode.someOptionsOpened = true;
        
        [self.loopValuePanel showPanel];
        
        [categoryBarNode openBlocksArea];
    }
}

-(void) hideOptions
{
    MTCategoryBarNode *categoryBarNode = (MTCategoryBarNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
    
    [self.loopValuePanel hidePanel];
    
    categoryBarNode.someOptionsOpened = false;
}
///--------------------------------------------------------------------------///
// Serializacja                                                               //
///--------------------------------------------------------------------------///

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.loopValuePanel = [aDecoder decodeObjectForKey:@"valuePanel"];
    
    [self prepareOptions];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.loopValuePanel forKey:@"valuePanel"];
}
@end

