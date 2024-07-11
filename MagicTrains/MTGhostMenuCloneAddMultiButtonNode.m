//
//  MTGhostMenuCloneAddMultiButtonNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 16.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTGhostMenuCloneAddMultiButtonNode.h"
#import "MTGhostMenuNode.h"

@implementation MTGhostMenuCloneAddMultiButtonNode
-(id) init {
    if ((self = [super initWithImageNamed:@"cloneInfinity.png"]))
    {
        self.color = [UIColor blueColor];
        self.anchorPoint = CGPointMake(0,1);
        self.name = @"MTGhostMenuCloneAddMultiButtonNode";
    }
    return self;
}

-(void) tapGesture:(UIGestureRecognizer *)g
{
    [(MTGhostMenuNode *)self.parent addMultiInstace];
}

-(void)pinchGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    [((MTGhostMenuNode*)self.parent) pinchGesture:g :v];
}

@end
