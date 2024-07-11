//  MTMoveXInSimulationON.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.

#import "MTGhostRepresentationNode.h"
#import "MTSceneAreaNode.h"
#import "MTGUI.h"
#import "MTMoveYInSimulationOFF.h"

@implementation MTMoveYInSimulationOFF

static NSString* myType = @"MTMoveYInSimulationOFF";

- (id) initWithSubTrain: (MTTrain *) t
{
    if(self = [super init])
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
    return @"yOFFCart.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    
    return [[MTMoveYInSimulationOFF alloc] initWithSubTrain:train];
}

-(int)getCategory
{
    return MTCategoryGhost;
}

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    ghostRepNode.moveYInSimulation = false;
    return true;
}

@end
