//
//  MTLabelValueForWheel.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 30.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTLabelTextNode.h"
#import "MTWheelNode.h"

@implementation MTLabelTextNode

-(id) init
{
    if ((self = [super init]))
    {
        self.name = @"MTLabelValueForWheel";
        self.position = CGPointMake(0, 0);
        self.fontSize = 20;
        self.fontColor = [UIColor colorWithWhite:0.3 alpha:1.0];
        self.fontName = @"Chalkduster";
        self.verticalAlignmentMode = 1;
    }

    return self;
}


-(void)tapGesture:(UIGestureRecognizer *)g
{
    //////NSLog (@"%@",self.name);
    [(MTWheelNode*)self.parent tapGesture:g];
}

-(void) panGesture:(UIGestureRecognizer *) g :(UIView *) v
{
    //////NSLog (@"Pan na %@",self.name);
    [(MTWheelNode*)self.parent panGesture:g :v];
}
-(void) pinchGesture:(UIGestureRecognizer *) g :(UIView *) v
{
    //////NSLog (@"Pinch na %@",self.name);
    [(MTWheelNode*)self.parent pinchGesture:g :v];
}
-(void) rotateGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    //////NSLog (@"Rotate na %@",self.name);
    [(MTWheelNode*)self.parent rotateGesture:g :v];
}

-(void) hold:(UIGestureRecognizer *)g :(UIView *)v
{
    //////NSLog (@"Hold na %@",self.name);
    [(MTWheelNode*)self.parent hold:g :v];
}

@end
