//
//  MTGhostMenuCloneRemoveButtonNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 16.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTGhostMenuCloneRemoveButtonNode.h"
#import "MTGhostMenuNode.h"

@implementation MTGhostMenuCloneRemoveButtonNode
-(id) init {
    if ((self = [super initWithImageNamed:@"deleteAll.png"]))
    {
        self.name = @"MTGhostMenuCloneRemoveButtonNode";
    }
    return self;
}

-(void)tapGesture:(UIGestureRecognizer *)g
{
    [(MTGhostMenuNode *) self.parent deleteAllInstances];
}

-(void)pinchGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    [((MTGhostMenuNode*)self.parent) pinchGesture:g :v];
}

@end
