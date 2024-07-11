//
//  MTMoveCartsOptions.m
//  MagicTrains
//
//  Created by Mateusz Wieczorkowski on 12.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTGoXYCartOptions.h"
#import "MTCategoryBarNode.h"
#import "MTViewController.h"
#import "MTGUI.h"
#import "MTWheelNode.h"
#import "MTStorage.h"
#import "MTGhost.h"

@implementation MTGoXYCartOptions

static MTGoXYCartOptions *myInstanceMTGXYCO;

+(void)clear
{
    myInstanceMTGXYCO = nil;
}

-(id) init
{
    self.xPanel = [[MTWheelPanel alloc] init];
    self.yPanel = [[MTWheelPanel alloc] init];
    
    [self prepareOptions];
    return self;

} -(void) prepareOptions
{
    [self.xPanel prepareAsUpperPanelWithMax: MAX_X_VALUE_GOXYCART  Min: MIN_X_VALUE_GOXYCART fullRotate:MAX_X_VALUE_GOXYCART / 2];
    [self.yPanel prepareAsLowerPanelWithMax: MAX_Y_VALUE_GOXYCART  Min: MIN_Y_VALUE_GOXYCART fullRotate:MAX_Y_VALUE_GOXYCART / 2];
    [self.xPanel setImage:@"WSKAZ_X.png"];
    [self.yPanel setImage:@"WSKAZ_Y.png"];

}

-(void) showOptions
{
    MTCategoryBarNode *categoryBarNode = (MTCategoryBarNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
    
    if (categoryBarNode.someOptionsOpened == false)
    {
        categoryBarNode.someOptionsOpened = true;
        
        [self.xPanel showPanel];
        [self.yPanel showPanel];
        
        [categoryBarNode openBlocksArea];
    }
}

-(void) hideOptions
{
    MTCategoryBarNode *categoryBarNode = (MTCategoryBarNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];

    [self.xPanel hidePanel];
    [self.yPanel hidePanel];
    
    categoryBarNode.someOptionsOpened = false;
}
///--------------------------------------------------------------------------///
// Serializacja                                                               //
///--------------------------------------------------------------------------///

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.xPanel = [aDecoder decodeObjectForKey:@"xPanel"];
    self.yPanel = [aDecoder decodeObjectForKey:@"yPanel"];
    
    [self prepareOptions];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.xPanel forKey:@"xPanel"];
    [aCoder encodeObject:self.yPanel forKey:@"yPanel"];
}

@end
