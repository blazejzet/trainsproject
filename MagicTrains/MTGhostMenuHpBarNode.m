//
//  MTGhostMenuHpBarNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 19.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTGhostMenuHpBarNode.h"
#import "MTGhostIconNode.h"
#import "MTGhostMenuNode.h"
#import "MTGhost.h"
@implementation MTGhostMenuHpBarNode
-(id) init {
    if ((self = [super init]))
    {
        self.name = @"MTGhostMenuHpBarNode";
        //[self refreshBar];
    }
    
    return self;
}

-(void) refreshBar
{
    [self removeAllChildren];
    
    bool half = false;
    int i;
    MTGhostMenuNode *menu = (MTGhostMenuNode*)self.parent.parent;
    MTGhost *currentGhost;
    if(menu == nil)
    {
        currentGhost = [MTGhostIconNode getSelectedIconNode].myGhost;
    }
    else
    {
        currentGhost = menu.currentGhost;
    }
    //MTGhost *currentGhost = menu.currentGhost;
    
    int hpFill = (int)currentGhost.hp;
    
    for(i=0; i < hpFill/2; i++)
    {
        MTSpriteNode *hp = [[MTSpriteNode alloc] initWithImageNamed:@"heartFull.png"];
        hp.size = CGSizeMake(50, 50);
        hp.anchorPoint = CGPointMake(0, 1);
        hp.position = CGPointMake(42*i+15, -25);
        [self addChild:hp];
    }
    
    if(hpFill%2 != 0)
    {
        MTSpriteNode *hp = [[MTSpriteNode alloc] initWithImageNamed:@"heartHalf.png"];
        hp.size = CGSizeMake(50, 50);
        hp.anchorPoint = CGPointMake(0, 1);
        hp.position = CGPointMake(42*i+15, -25);
        [self addChild:hp];
        half = true;
        i++;
    }
    
    for(int j=i; j < 5; j++)
    {
        MTSpriteNode *hp = [[MTSpriteNode alloc] initWithImageNamed:@"heartEmpty.png"];
        hp.size = CGSizeMake(50, 50);
        hp.anchorPoint = CGPointMake(0, 1);
        hp.position = CGPointMake(42*j+15, -25);
        [self addChild:hp];
    }
}

-(void)pinchGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    [((MTGhostMenuNode*)self.parent) pinchGesture:g :v];
}
@end
