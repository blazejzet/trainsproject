//
//  MTMoveCartsOptions.m
//  MagicTrains
//
//  Created by Mateusz Wieczorkowski on 12.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//
//  Opcje dotycza wagonow MTGoTop; MTGoDown; MTGoLeft; MTGoRight
//  Czyli takich, ktore korzystaja z opcji - dwa kola (time i distance) i zmiennych
//

#import "MTMoveCartsOptions.h"
#import "MTCategoryBarNode.h"
#import "MTViewController.h"
#import "MTGUI.h"
#import "MTGhost.h"
#import "MTStorage.h"

@implementation MTMoveCartsOptions

static MTMoveCartsOptions *myInstanceMTMCO;


+(void)clear
{
    myInstanceMTMCO = nil;
}
-(id) init
{
    self.distancePanel = [[MTWheelPanel alloc] init];
    //self.distancePanel.numberSelectedVariable = 0;
    self.timePanel = [[MTWheelPanel alloc] init];
    //self.timePanel.numberSelectedVariable = 0;
    
    [self prepareOptions];
    return self;
}

-(void) prepareOptions
{
    [self.distancePanel prepareAsLowerPanelWithMax: MAX_GO_DISTANCE Min: MIN_GO_DISTANCE fullRotate: MAX_GO_DISTANCE /2];
    
    [self.timePanel     prepareAsUpperPanelWithMax: MAX_CART_TIME   Min: MIN_CART_TIME   fullRotate:MAX_CART_TIME /2];
    [self.timePanel setImage:@"WSKAZ_CZAS.png"];
    [self.distancePanel setImage:@"WSKAZ_DYSTANS.png"];
    
}

-(void) showOptions
{
    MTCategoryBarNode *categoryBarNode = (MTCategoryBarNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
    
    if (categoryBarNode.someOptionsOpened == false)
    {
        categoryBarNode.someOptionsOpened = true;
     
        [self.distancePanel showPanel];
        [self.timePanel     showPanel];
        
        [categoryBarNode openBlocksArea];
    }
}

-(void) hideOptions
{
    MTCategoryBarNode *categoryBarNode = (MTCategoryBarNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
    
    [self.distancePanel  hidePanel];
    [self.timePanel      hidePanel];
    
    categoryBarNode.someOptionsOpened = false;
}

///--------------------------------------------------------------------------///
// Serializacja                                                               //
///--------------------------------------------------------------------------///

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.distancePanel = [aDecoder decodeObjectForKey:@"distancePanel"];
    self.timePanel = [aDecoder decodeObjectForKey:@"timePanel"];
    
    [self prepareOptions];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.distancePanel forKey:@"distancePanel"];
    [aCoder encodeObject:self.timePanel forKey:@"timePanel"];
}

@end
