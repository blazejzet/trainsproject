//
//  MTMessageGameOver.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 30.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTMessageGameOverCart.h"
#import "MTGhostRepresentationNode.h"
#import "MTLabelNode.h"
#import "MTViewController.h"
#import "MTExecutor.h"
#import "MTSceneAreaNode.h"

@implementation MTMessageGameOverCart

static NSString* myType = @"MTMessageGameOverCart";

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
    return @"gameOverCart.png";
}

-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    
    return [[MTMessageGameOverCart alloc] initWithSubTrain:train];
}

-(int)getCategory
{
        return MTCategoryControl;
}

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    MTExecutor *executor = [MTExecutor getInstance];
    [executor changeStateForAllGhosts];

    [[MTViewController getInstance] showGameOver:[ghostRepNode ghostName] ];
    
    return true;
}

@end
