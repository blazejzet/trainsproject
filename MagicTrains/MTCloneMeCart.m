//  MTPauseCart.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.

#import "MTCloneMeCart.h"
#import "MTGhostRepresentationNode.h"
#import "MTSceneAreaNode.h"
#import "MTGhost.h"
#import "MTGhostIconNode.h"
#import "MTTrain.h"
#import "MTExecutor.h"
#import "MTCodeTabNode.h"
#import "MTGUI.h"
#import "MTLocomotive.h"

@implementation MTCloneMeCart

static NSString* myType = @"MTCloneMeCart";

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
    return @"cloneMe.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{

        return [[MTCloneMeCart alloc] initWithSubTrain:train];
}

-(int)getCategory
{
    return MTCategoryGhost;
}

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    MTExecutor *executor = [MTExecutor getInstance];
    @synchronized(executor.UserCloneNodes)
    {
        if(executor.UserCloneNodes.count < MAX_CLONE_GHOST_REP)
        {
            MTGhostRepresentationNode* newClone = [ghostRepNode initClone];
            float scale = newClone.xScale ;
            //[newClone setScale:0.05];
           
            [((NSMutableArray *)[MTExecutor getInstance].UserCloneNodes) addObject:newClone];
            [[MTExecutor getInstance] prepareExecutionDataForGhostRepNode:newClone];
            [ghostRepNode.parent addChild: newClone];
            [newClone setPos:newClone.position];
            ghostRepNode.zPosition+=1;
        
            int phca = newClone.physicsBody.categoryBitMask;
            int phco = newClone.physicsBody.collisionBitMask;
            newClone.physicsBody.categoryBitMask=0;
            newClone.physicsBody.collisionBitMask=0;
            
            //[[MTExecutor getInstance] prepareExecutionDataForGhostRepNode:newClone];
            newClone.alpha=0;
            [newClone runAction:[SKAction sequence:@[[SKAction fadeAlphaTo:1 duration:0.1],[SKAction runBlock:^{
                newClone.physicsBody.categoryBitMask=phca;
                newClone.physicsBody.collisionBitMask=phco;
                
            }]]]];
            
            
            
        }
    }
    return true;
}

@end
