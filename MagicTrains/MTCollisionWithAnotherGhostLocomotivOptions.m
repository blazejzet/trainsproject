
//
//  MTCollisionWithAnotherGhostLocomotivOptions.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 30.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCollisionWithAnotherGhostLocomotivOptions.h"
#import "MTCollisionWithAnotherGhostLocomotivGhostIconNode.h"
#import "MTCollisionWithAnotherGhostLocomotivTrainNode.h"
#import "MTCollisionWithAnotherGhostLocomotivTrackNode.h"
#import "MTViewController.h"
#import "MTCategoryBarNode.h"
#import "MTGhostIconNode.h"
#import "MTGhostsBarNode.h"
#import "MTStorage.h"
#import "MTSubTrain.h"
#import "MTTrain.h"
@implementation MTCollisionWithAnotherGhostLocomotivOptions
-(id) initWithLocomotiv:(MTCollisionWithAnotherGhostLocomotiv *)loc
{
    self.myLocomotiv = loc;
    self.selectedIconGhostNumber = -1;
    self.prevPositionWhenGhostBarIsOpenningAgain = CGPointMake(0, 0);
    
    //[self prepareOptions];
    return self;
}

-(void) prepareOptions
{
    NSArray *ghosts = [[MTStorage getInstance] getAllGhosts];
    self.ghostIcons = [[NSMutableArray alloc] init];

    for(int i = 0; i < ghosts.count; i++)
    {
        MTGhost *icon = (MTGhost* )ghosts[i];
        MTCollisionWithAnotherGhostLocomotivGhostIconNode *optionIcon = [[MTCollisionWithAnotherGhostLocomotivGhostIconNode alloc] initWithImageNamed:icon.costumeName];
        
        [optionIcon setGhostFromGhostBar:icon];
        [optionIcon setMyOptions:self];
        [optionIcon setSize: CGSizeMake(75, 75)];
        [optionIcon setTime: 0.15];
        
        
        int x = i/5;
        int y = i%5;
        
            [optionIcon setPosition:CGPointMake(140+80*y, 720-((x)*80))];
            
            if(i == self.selectedIconGhostNumber)
            {
                
                self.prevPositionWhenGhostBarIsOpenningAgain = CGPointMake(140+80*y, 720-((x)*80));
            }
        
        
        
        optionIcon.oldPosition=optionIcon.position;
        optionIcon.myNumber = i;
        [self.ghostIcons addObject:optionIcon];
        optionIcon.allIcons = self.ghostIcons;
    }
}

-(void) showOptions
{
    MTCategoryBarNode *categoryBarNode = (MTCategoryBarNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
    
    if (categoryBarNode.someOptionsOpened == false)
    {
        [self prepareOptions];
        self.tracks = [[NSMutableArray alloc] init];
        
        self.isAnimationRuning = false;
        
        MTCategoryBarNode *categoryBarNode = (MTCategoryBarNode *)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
        self.trainNode = [[MTCollisionWithAnotherGhostLocomotivTrainNode alloc] initWithPosition:CGPointMake(300, 100)];
        
        self.trainNode.zPosition = 1;
        /*for (int i = 0 ; i<7 ; i++)
        {
            MTCollisionWithAnotherGhostLocomotivTrackNode *track = [[MTCollisionWithAnotherGhostLocomotivTrackNode  alloc] init];
            track.position = CGPointMake(300, i*100 + 210);
            track.zPosition = 0;
            [categoryBarNode addChild:track];
            [self.tracks addObject:track];
        }
        */
        self.centerIcon = [[MTSpriteNode alloc] init];
        self.centerIcon.texture = [MTGhostIconNode getSelectedIconNode].texture;
        self.centerIcon.position = CGPointMake(300, 40);
        self.centerIcon.size = CGSizeMake(65, 65);
        self.centerIcon.zPosition = 2;
        
        [categoryBarNode addChild: self.trainNode];
        [categoryBarNode addChild: self.centerIcon];

        //przypinanie ikonek do categoryBar
        for(int i = 0; i < self.ghostIcons.count; i++)
        {
            MTCollisionWithAnotherGhostLocomotivGhostIconNode* ghostIcon =((MTCollisionWithAnotherGhostLocomotivGhostIconNode *)self.ghostIcons[i]);
            if(ghostIcon.parent == nil)
            {
                if(ghostIcon.myNumber == self.selectedIconGhostNumber)
                {
                    ghostIcon.position = CGPointMake(300, 260);
                }
                [categoryBarNode addChild: self.ghostIcons[i]];
            }
        }
        
        [categoryBarNode openBlocksArea];
        
        categoryBarNode.someOptionsOpened = true;
    }
}

-(void) hideOptions
{
    MTCategoryBarNode *categoryBarNode = (MTCategoryBarNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
    
    for(int i = 0; i < self.ghostIcons.count; i++)
    {
        [self.ghostIcons[i] removeFromParent];
    }
    
    for(int i = 0; i < self.tracks.count; i++)
    {
        [self.tracks[i] removeFromParent];
    }
    
    [self.trainNode removeFromParent];
    [self.centerIcon removeFromParent];
    
    categoryBarNode.someOptionsOpened = false;
}

-(void) savePrevPosition:(CGPoint )prevPosition WithSelectedIcon:(MTCollisionWithAnotherGhostLocomotivGhostIconNode *)selectedIconGhost
{
    if (selectedIconGhost != nil)
    {
        self.selectedIconGhostNumber = selectedIconGhost.myNumber;
        self.prevPositionFromSelctedGhost = prevPosition;
        self.currentSelectedGhostIcon = selectedIconGhost;
        self.isAnimationRuning = false;
    }
}
///--------------------------------------------------------------------------///
// Serializacja                                                               //
///--------------------------------------------------------------------------///

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    self.selectedIconGhostNumber = [aDecoder decodeIntegerForKey: @"selectedIconGhostNumber"];
    [self prepareOptions];
    // Jeżeli nie ma zaznaczonego duszka
    if (self.selectedIconGhostNumber >= 0)
    {
        [self savePrevPosition: CGPointMake ( 140, 720 - (self.selectedIconGhostNumber % 5) * 80 )
          WithSelectedIcon: self.ghostIcons [self.selectedIconGhostNumber] ];
    }
    self.prevPositionWhenGhostBarIsOpenningAgain = CGPointMake(0, 0);
    
    self.myLocomotiv.selectedGhost = [[MTStorage getInstance] getGhostAt: self.selectedIconGhostNumber];
    

    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger: self.selectedIconGhostNumber forKey:@"selectedIconGhostNumber"];
    [aCoder encodeObject: self.myLocomotiv forKey:@"myLocomotiv"];
}
@end
