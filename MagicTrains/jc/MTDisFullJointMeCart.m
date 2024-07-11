//  MTPauseCart.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.

#import "MTDisFullJointMeCart.h"
#import "MTGhostRepresentationNode.h"
#import "MTSceneAreaNode.h"
#import "MTGhost.h"
#import "MTGhostIconNode.h"
#import "MTTrain.h"
#import "MTExecutor.h"
#import "MTCodeTabNode.h"
#import "MTGUI.h"
#import "MTLocomotive.h"

@implementation MTDisFullJointMeCart

static NSString* myType = @"MTDisFullJointMeCart";

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
    return @"disJointFull";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{

        return [[MTDisFullJointMeCart alloc] initWithSubTrain:train];
}

-(int)getCategory
{
    return MTCategoryGhost;
}

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    for (SKPhysicsJoint * j in ghostRepNode.physicsBody.joints){
        [ghostRepNode.scene.physicsWorld removeJoint:j];
    }
    
    
    return true;
}

@end
