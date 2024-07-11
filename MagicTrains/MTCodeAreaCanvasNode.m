//
//  MTCodeAreaCanvasNode.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 26.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCodeAreaCanvasNode.h"

@implementation MTCodeAreaCanvasNode

-(id)initWithTexture:(SKTexture *) texture Size:(CGSize) size
{
    if (self = [super init])
    {
        [self setSize: size];
        [self setTexture: texture];
        [self setAnchorPoint:CGPointMake(0,0)];
        [self setName:@"MTCodeAreaNode"];
    }
    return self;
}
-(void)panGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    [((MTSpriteNode *)self.parent) panGesture:g :v ];
}
-(void)blockDrop:(MTBlockNode*)block
{
    [((MTCodeAreaCanvasNode *)self.parent) blockDrop:block];
}
@end
