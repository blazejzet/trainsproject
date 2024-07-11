//
//  MTTrashNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 10.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTTrashNode.h"
#import "MTRecieveSignalLocomotiv.h"
#import "MTCart.h"
#import "MTGhostIconNode.h"
#import "MTWindowAlert.h"
#import "MTSceneAreaNode.h"
#import "MTCodeAreaNode.h"
#import "MTBlockingBackground.h"
#import "MTGUI.h"

@implementation MTTrashNode

-(id) init {
    if ((self = [super init]))
    {
        self = [self initWithImageNamed:@"trash"];
        self.name = @"MTTrashNode";
        //self.size = CGSizeMake(75, 75);
        self.xScale = 1.7;
        self.yScale = 1.7;
        self.color = [UIColor greenColor];
        //self.position = CGPointMake(37.5, 37.5);
        
        SKAction *binRotate0 = [SKAction waitForDuration:1];
        SKAction *binRotate1 = [SKAction rotateByAngle:-0.1 duration:0.2];
        SKAction *binRotate2 = [SKAction rotateByAngle:0.1 duration:0.2];
        SKAction *binRotate = [SKAction sequence:@[binRotate0, binRotate1, binRotate2, binRotate1, binRotate2]];
        
        self.rotateBin = [SKAction sequence:@[binRotate, binRotate]];
        self.hideBin = [SKAction fadeAlphaTo:0.0 duration:0.2];//[SKAction resizeToWidth:0 height:0 duration:0.2];
        self.showBin = [SKAction fadeAlphaTo:1.0 duration:0.2];//[SKAction resizeToWidth:75 height:75 duration:0.2];
        
    }
    return self;
}

-(void) blockDrop:(MTBlockNode *) block
{
    if ([block.myOrigin.name isEqualToString:@"MTTrainNode"])
    {
        if ([block removeMyCartInStorage])
        {
           // [[NSNotificationCenter defaultCenter] postNotificationName:@"Train Changed" object:[block getMySubTrain].myTrain];
        }
        else if([block.myCart getCategory] == MTCategoryLocomotive)
        {
           
            [block removeFullTrainInStorage];
            // MTBlockingBackground *background = [[MTBlockingBackground alloc] initFullBackgroundWithDuration:1.0 Color:[UIColor blackColor] Alpha:0.4 andWaitTime:0.1];
           // MTWindowAlert *alert = [[MTWindowAlert alloc] initWithBlock: block];
           // alert.background = background;
           // [((MTCodeAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTBlockRoot"]) addChild:alert];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Train Changed" object:[block getMySubTrain].myTrain];
        }
        
    }
}

-(void) ghostRepDrop:(MTGhostRepresentationNode *) ghostRep
{
    MTGhost *gt= ghostRep.myGhostIcon.myGhost;
    MTGhostsBarNode *gBar = (MTGhostsBarNode *)[(SKNode *)self.scene.children[0] childNodeWithName:@"MTGhostsBarNode"];
    
    if(gt.ghostInstances.count > 1 || gBar.ghostIconQuota > 1)
    {
        MTBlockingBackground *background = [[MTBlockingBackground alloc] initFullBackgroundWithDuration:1.0 Color:[UIColor blackColor] Alpha:0.4 andWaitTime:0.1];
        //MTWindowAlert *alert = [[MTWindowAlert alloc] initWithGhost: gt : gBar :ghostRep];
        MTWindowAlert *alert = [[MTWindowAlert alloc] initWithGhost:gt ghostBarNode:gBar ghostRepresentationNode:ghostRep];
        
        alert.background = background;
        [((MTSceneAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"]) addChild:alert];
    }
        
}

-(void) showTrash
{
    self.zRotation = 0.0;
    
    if(ANIMATIONS)
    {
        [self removeAllActions];
        self.hidden = false;
        //self.size = CGSizeMake(75, 75);
        [self runAction:self.showBin];
        [self runAction:self.rotateBin];
    }
    else
    {
        self.hidden = false;
    }
}

-(void) hideTrash
{
    self.zRotation = 0.0;
    
    if(ANIMATIONS)
    {
        [self removeAllActions];
        [self runAction: self.hideBin completion:^{
            self.hidden = true;
        }];
    }
    else
    {
        self.hidden = true;
    }
    
}


@end
