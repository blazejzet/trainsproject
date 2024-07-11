//
//  MTMessageVictoryCart.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 07.05.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTMessageVictoryCart.h"
#import "MTExecutor.h"
#import "MTViewController.h"
#import "MTGhostRepresentationNode.h"
#import "MTSceneAreaNode.h"
#import "MTGhostInstance.h"
@implementation MTMessageVictoryCart

static NSString* myType = @"MTMessageVictoryCart";

- (id) initWithSubTrain: (MTSubTrain *) t
 {
 if(self = [super initWithSubTrain: t])
 {
     self.optionsOpen = true;
     self.isInstantCart = true;
 }
 return self;
}

+(NSString*)DoGetMyType{
    return myType;
}

-(NSString*)getImageName
{
    return @"victoryCart.png";
}

-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    
    return [[MTMessageVictoryCart alloc] initWithSubTrain:train];
}

-(int)getCategory
{
    return MTCategoryControl;
}

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    MTExecutor *executor = [MTExecutor getInstance];
    [executor changeStateForAllGhosts];
    
    [[MTViewController getInstance] showVictory:[ghostRepNode ghostName] ];
    return true;
}
@end
