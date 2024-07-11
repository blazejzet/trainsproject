//
//  MTGhostMenuPickerElementNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 26.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTGhostMenuPickerElementNode.h"
#import "MTGhostMenuPickerNode.h"
#import "MTGhostMenuNode.h"

@implementation MTGhostMenuPickerElementNode
-(id) initWithPosition: (CGPoint)p AndCostume:(NSString *)costume AndNumber:(int)number {
    if ((self = [super initWithImageNamed:costume]))
    {
        self.name = @"MTGhostMenuPickerElementNode";
        self.imgName = costume;
        self.anchorPoint = CGPointMake(0, 1);
        self.size = CGSizeMake(100, 100);
        self.position = p;
        self.myNumber = number;
    }
    
    return self;
}
-(void)panGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    [(MTGhostMenuPickerNode *)self.parent panGesture:g :v];
}

-(void)tapGesture:(UIGestureRecognizer *)g
{
    [(MTGhostMenuPickerNode *)self.parent changeGhostFromTapGesture:self];
}

-(void)pinchGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    [((MTGhostMenuNode*)self.parent.parent) pinchGesture:g :v];
}

@end
