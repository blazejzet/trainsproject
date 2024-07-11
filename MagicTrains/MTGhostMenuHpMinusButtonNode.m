//
//  MTGhostMenuHpMinusButtonNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 19.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTGhostMenuHpMinusButtonNode.h"
#import "MTGhostIconNode.h"
#import "MTGhost.h"
#import "MTGhostMenuHpButtonNode.h"
#import "MTGhostMenuNode.h"
#import "MTGhostMenuHpBarNode.h"

@implementation MTGhostMenuHpMinusButtonNode
-(id) init {
    if ((self = [super initWithImageNamed:@"heartMinus.png"]))
    {
        self.name = @"MTGhostMenuHpMinusButtonNode";
    }
    
    return self;
}

-(void)tapGesture:(UIGestureRecognizer *)g
{
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
    
    if(currentGhost.hp > 0)
    {
        currentGhost.hp -= 1.0;
        [(MTGhostMenuHpBarNode *)[((MTGhostMenuHpButtonNode *) self.parent) childNodeWithName:@"MTGhostMenuHpBarNode"] refreshBar];
    }
}

-(void)pinchGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    [((MTGhostMenuNode*)self.parent) pinchGesture:g :v];
}

@end
