//
//  MTLabelNode.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 23.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTLabelNode.h"

@implementation MTLabelNode

-(void)tapGesture:(UIGestureRecognizer *)g
{
    //////NSLog (@"%@",self.name);

}

-(void) panGesture:(UIGestureRecognizer *) g :(UIView *) v
{
    //////NSLog (@"Pan na %@",self.name);
}
-(void) pinchGesture:(UIGestureRecognizer *) g :(UIView *) v
{
   // ////NSLog (@"Pinch na %@",self.name);
}
-(void) rotateGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    //////NSLog (@"Rotate na %@",self.name);
}

-(void) swipe:(UISwipeGestureRecognizer *)g :(UIView *)v
{
    //////NSLog (@"Swipe na %@",self.name);
}

-(void) hold:(UIGestureRecognizer *)g :(UIView *)v
{
    //////NSLog (@"Hold na %@",self.name);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}
@end
