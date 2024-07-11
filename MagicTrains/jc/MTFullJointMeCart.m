//  MTPauseCart.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.

#import "MTFullJointMeCart.h"
#import "MTGhostRepresentationNode.h"
#import "MTSceneAreaNode.h"
#import "MTGhost.h"
#import "MTGhostIconNode.h"
#import "MTTrain.h"
#import "MTExecutor.h"
#import "MTCodeTabNode.h"
#import "MTGUI.h"
#import "MTLocomotive.h"

@implementation MTFullJointMeCart

static NSString* myType = @"MTFullJointMeCart";

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
    return @"jointFull";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{

        return [[MTFullJointMeCart alloc] initWithSubTrain:train];
}

-(int)getCategory
{
    return MTCategoryGhost;
}

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    
    CGPoint x = CGPointMake(ghostRepNode.size.width/2, ghostRepNode.size.height/2);
    MTExecutor *executor = [MTExecutor getInstance];
    for (MTGhostRepresentationNode* n in executor.GhostRepNodes){
        CGFloat d = ghostRepNode.size.width/2+ n.size.width/2;
        CGFloat f = sqrt((n.position.x-ghostRepNode.position.x)*(n.position.x-ghostRepNode.position.x)+(n.position.y-ghostRepNode.position.y)*(n.position.y-ghostRepNode.position.y));
        
         NSLog(@"n: (%f,%f):%f, j: (%f,%f):%f, d: %f, f:%f",n.position.x,n.position.y,n.size.width/2,ghostRepNode.position.x,ghostRepNode.position.y,ghostRepNode.size.width/2,d,f);
        
        
        if (f<d)//tzn ze blisko siebie sa
        {
            if(ghostRepNode!=n){
                
                CGPoint A = [ghostRepNode.scene convertPoint:ghostRepNode.position
                                                    fromNode:ghostRepNode.parent];
                CGPoint B = [n.scene convertPoint:n.position
                                                    fromNode:n.parent];
                
                SKPhysicsJointFixed * a = [SKPhysicsJointFixed jointWithBodyA:ghostRepNode.physicsBody bodyB:n.physicsBody anchor:CGPointMake((A.x+B.x)/2, (A.y+B.y)/2)];
                
                ghostRepNode.physicsBody.allowsRotation=TRUE;
                n.physicsBody.allowsRotation=TRUE;
                
             
                
                @try {
                    if ( ghostRepNode!=nil) {
                        NSLog(@"BLAD Z GHOSTREPNODE  ghostRepNode!=nil");
                        if (ghostRepNode.scene!=nil){
                             NSLog(@"BLAD Z GHOSTREPNODE ghostRepNode.scene!=nil");
                            if (ghostRepNode.scene.physicsWorld!=nil){
                                 NSLog(@"BLAD Z GHOSTREPNODE ghostRepNode.scene.physicsWorld!=nil");
                                SKPhysicsWorld* w =ghostRepNode.scene.physicsWorld;
                                if(n.scene.physicsWorld!=nil){
                                    [w addJoint:a];
                                }
                            }
                        }
                    }
                    
                } @catch (NSException *exception) {
                    NSLog(@"BLAD Z GHOSTREPNODE %@",exception);
                } @finally {
                    
                }
                
            }
            //[n addNextJoint:ghostRepNode];
            //w obu kierunkach joint.
            }
        }
    
    
    return true;
}

@end
