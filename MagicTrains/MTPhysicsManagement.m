//
//  MTPhysicsManagement.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 11.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTPhysicsManagement.h"

#import "MTGUI.h"

#import "MTExecutor.h"
#import "MTGhost.h"
#import "MTTrain.h"
#import "MTGhostRepresentationNode.h"

#import "MTCollisionWithLeftWallLocomotiv.h"
#import "MTCollisionWithRightWallLocomotiv.h"
#import "MTCollisionWithTopWallLocomotiv.h"
#import "MTCollisionWithBottomWallLocomotiv.h"
#import "MTCollisionWithAnotherGhostLocomotiv.h"
#import "MTNotificationNames.h"
#import "MTExecutionData.h"

@implementation MTPhysicsManagement

-(id) initWithScene:(SKScene *) scene
{
    self = [super init];
    self.scene = scene;
    self.scene.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    
    return self;
}

-(void) manageCollision:(SKPhysicsContact *) contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }

#if DEBUG_NSLog
//    ////NSLog(@"oto1: %i", firstBody.categoryBitMask);
//    ////NSLog(@"oto2: %i", secondBody.categoryBitMask);
#endif
    //ZDERZENIA
   if(secondBody.categoryBitMask == 2 )
    {
        MTGhostRepresentationNode *rep = (MTGhostRepresentationNode *)secondBody.node;
        [rep auc];
    }
    if(firstBody.categoryBitMask == 2 )
    {
        MTGhostRepresentationNode *rep = (MTGhostRepresentationNode *)firstBody.node;
        [rep auc];
    }
    
    
    // Czy w stanie symulacji 
    //lewa - 0
    //gorna - 1
    //prawa - 2
    //dolna - 3
    if([MTExecutor getInstance].simulationStarted == true)
    {
        // duszek zderzyl sie ze sciana
        if(firstBody.categoryBitMask == 1 && secondBody.categoryBitMask == 2)
        {
            MTGhostRepresentationNode *rep = (MTGhostRepresentationNode *)secondBody.node;
            MTGhost *ghost = rep.myGhostIcon.myGhost;
            
            [rep removeAllActions];
            
            NSString *wallName = ((MTSpriteNode*)firstBody.node).name;
            uint numberWall;
            
            if ([wallName isEqualToString:@"leftWall"])
            {
                numberWall = 0;
            }
            else if ([wallName isEqualToString:@"topWall"])
            {
                numberWall = 1;
            }
            else if ([wallName isEqualToString:@"rightWall"])
            {
                numberWall = 2;
            }
            else if ([wallName isEqualToString:@"bottomWall"])
            {
                numberWall = 3;
            }
            
            if(rep.userClone)
            {
                for(MTTrain* train in ghost.trainsForCloneWallCollision[numberWall])
                {
                    [rep.executionData.trains addObject: train];
                }
            }
            else
            {
                for(MTTrain* train in ghost.trainsForWallCollision[numberWall])
                {
                    [rep.executionData.trains addObject: train];
                }
            }
        }
        
        // duszek zderzyl sie z innym duszkiem
        else if(firstBody.categoryBitMask == 2 && secondBody.categoryBitMask == 2)
        {
            MTGhostRepresentationNode *repFirst = (MTGhostRepresentationNode *)firstBody.node;
            MTGhost *firstGhost = repFirst.myGhostIcon.myGhost;
            uint numberFirstGhost = firstGhost.getMyNumber;
            
            MTGhostRepresentationNode *repSecond = (MTGhostRepresentationNode *)secondBody.node;
            MTGhost *secondGhost = repSecond.myGhostIcon.myGhost;
            uint numberSecondGhost = secondGhost.getMyNumber;
            
            //jest klonem uzytkownika
            if(repFirst.userClone)
            {
                for(MTTrain* train in firstGhost.trainsForCloneCollision[numberSecondGhost])
                {
                    [repFirst.executionData.trains addObject: train];
                }
                
            }
            else //jest zwyklym duszkiem
            {
                for(MTTrain* train in firstGhost.trainsForCollision[numberSecondGhost])
                {
                    [repFirst.executionData.trains addObject: train];
                }
                
            }
            
            if (repSecond.userClone)
            {
                for(MTTrain* train in secondGhost.trainsForCloneCollision[numberFirstGhost])
                {
                    [repSecond.executionData.trains addObject: train];
                }
            }
            else
            {
                for(MTTrain* train in secondGhost.trainsForCollision[numberFirstGhost])
                {
                    [repSecond.executionData.trains addObject: train];
                }
            }
            
        }
    }
}
            
@end
