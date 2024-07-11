 //
//  MTRotationCartOptions.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 12.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTRotationCartOptions.h"
#import "MTCategoryBarNode.h"
#import "MTViewController.h"
#import "MTGhost.h"
#import "MTVisibleGlobalVar.h"
#import "MTGUI.h"
#import "MTStorage.h"
#import "MTMainScene.h"

@implementation MTRotationCartOptions

static MTRotationCartOptions *myInstanceMTRCU;

+(void)clear
{
    myInstanceMTRCU = nil;
}
-(id) init
{
    self = [super init];
    self.timePanel = [[MTWheelPanel alloc] init];
    self.anglePanel = [[MTWheelPanel alloc] init];
    
    [self prepareOptions];
    return self;
}

-(void) prepareOptions
{
    [self.timePanel  prepareAsUpperPanelWithMax:MAX_CART_TIME   Min:MIN_CART_TIME   fullRotate: MAX_CART_TIME / 2];
    [self.anglePanel prepareAsLowerPanelWithMax:MAX_ANGLE_VALUE Min:MIN_ANGLE_VALUE fullRotate:MAX_ANGLE_VALUE];
}

-(void) showOptions
{
    MTCategoryBarNode *categoryBarNode = (MTCategoryBarNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
    
    if (categoryBarNode.someOptionsOpened == false)
    {
        categoryBarNode.someOptionsOpened = true;
        
        [self.timePanel showPanel];
        [self.anglePanel showPanel];
    
        [categoryBarNode openBlocksArea];
    }
}

-(void) hideOptions
{
    MTCategoryBarNode *categoryBarNode = (MTCategoryBarNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
    
    [self.timePanel hidePanel];
    [self.anglePanel hidePanel];
    [self.timePanel setImage:@"WSKAZ_CZAS.png"];
    [self.anglePanel setImage:@"WSKAZ_KAT.png"];
    
    categoryBarNode.someOptionsOpened = false;
    
}
///--------------------------------------------------------------------------///
// Serializacja                                                               //
///--------------------------------------------------------------------------///

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.anglePanel = [aDecoder decodeObjectForKey:@"anglePanel"];
    self.timePanel = [aDecoder decodeObjectForKey:@"timePanel"];
    
    [self prepareOptions];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.anglePanel forKey:@"anglePanel"];
    [aCoder encodeObject:self.timePanel forKey:@"timePanel"];
}
@end
