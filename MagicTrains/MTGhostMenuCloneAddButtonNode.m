//
//  MTGhostMenuCloneButtonNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 16.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTGhostMenuCloneAddButtonNode.h"
#import "MTGhostMenuNode.h"
#import "MTGUI.h"
#import "MTViewController.h"
#import "MTSceneAreaNode.h"


@implementation MTGhostMenuCloneAddButtonNode
-(id) init {
    if ((self = [super initWithImageNamed:@"cloneIcon.png"]))
    {
        self.name = @"MTGhostMenuCloneAddButtonNode";
    }
    return self;
}

-(void)tapGesture:(UIGestureRecognizer *)g
{
    MTSceneAreaNode *scene = (MTSceneAreaNode*)self.parent.parent;
    
    if(scene.ghostsRepresentations.count < MAX_REAL_GHOST_REP)
    {
        [(MTGhostMenuNode *) self.parent addInstanceOptions];
    }
}

-(void)pinchGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    [((MTGhostMenuNode*)self.parent) pinchGesture:g :v];
}

@end
