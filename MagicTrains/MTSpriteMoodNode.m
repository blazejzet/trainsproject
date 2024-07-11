//
//  MTSpriteMoodNode.m
//  MagicTrains
//
//  Created by Blazej Zyglarski on 02.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTSpriteMoodNode.h"
#import "MTSpriteNode.h"
#import "MTMainScene.h"

@implementation MTSpriteMoodNode
-(void)tapGesture:(UIGestureRecognizer *)g
{
    [(MTSpriteNode*)self.parent tapGesture:g ];
    
}

-(void)animateTap{
    //[(MTSpriteNode*)self.parent animateTap];
}

-(void) panGesture:(UIGestureRecognizer *) g :(UIView *) v
{
    [(MTSpriteNode*)self.parent panGesture:g :v];
}
-(void) pinchGesture:(UIGestureRecognizer *) g :(UIView *) v
{
    [(MTSpriteNode*)self.parent pinchGesture:g :v];
}
-(void) rotateGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    [(MTSpriteNode*)self.parent rotateGesture:g :v];
}

-(void) swipe:(UISwipeGestureRecognizer *)g :(UIView *)v
{
    [(MTSpriteNode*)self.parent swipe:g :v];
}

-(void) hold:(UIGestureRecognizer *)g :(UIView *)v
{
    [(MTSpriteNode*)self.parent hold:g :v];
}

-(void) holdGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    [(MTSpriteNode*)self.parent holdGesture:g :v];
}

@end
