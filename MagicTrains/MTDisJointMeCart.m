//  MTPauseCart.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.

#import "MTDisJointMeCart.h"
#import "MTGhostRepresentationNode.h"
#import "MTSceneAreaNode.h"
#import "MTGhost.h"
#import "MTGhostIconNode.h"
#import "MTTrain.h"
#import "MTExecutor.h"
#import "MTCodeTabNode.h"
#import "MTGUI.h"
#import "MTLocomotive.h"

@implementation MTDisJointMeCart

static NSString* myType = @"MTDisJointMeCart";

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
    return @"disJoint";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{

        return [[MTDisJointMeCart alloc] initWithSubTrain:train];
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

-(bool)runMeWithGhostRepNodeX:(MTGhostRepresentationNode*) ghostRepNode
{
    CGPoint x = CGPointMake(ghostRepNode.size.width/2, ghostRepNode.size.height/2);
    MTExecutor *executor = [MTExecutor getInstance];
    for (MTGhostRepresentationNode* n in executor.GhostRepNodes){
        [n removeMyJoints];
    }/*MTExecutor *executor = [MTExecutor getInstance];
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
    }*/
    return true;
}

@end
