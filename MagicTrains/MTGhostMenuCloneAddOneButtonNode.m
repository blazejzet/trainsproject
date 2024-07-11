//
//  MTGhostMenuCloneAddOneButtonNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 16.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTGhostMenuCloneAddOneButtonNode.h"
#import "MTGhostMenuNode.h"

@implementation MTGhostMenuCloneAddOneButtonNode
-(id) init {
    if ((self = [super initWithImageNamed:@"cloneOne.png"]))
    {
        self.anchorPoint = CGPointMake(0, 1);
        self.name = @"MTGhostMenuCloneAddOneButtonNode";
    }
    return self;
}

-(void) tapGesture:(UIGestureRecognizer *)g
{
    [(MTGhostMenuNode *)self.parent addOneInstance];
}

-(void)pinchGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    [((MTGhostMenuNode*)self.parent) pinchGesture:g :v];
}

@end
