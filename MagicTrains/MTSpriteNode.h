//
//  MTSpriteNode.h
//  testNodow
//
//  Created by Dawid Skrzypczyński on 19.12.2013.
//  Copyright (c) 2013 UMK. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MTGestureDelegate.h"

@interface MTSpriteNode : SKSpriteNode <MTGestureDelegate>
@property NSMutableArray * costumeVisuals;
@property BOOL selected;

-(void)holdGesture:(UIGestureRecognizer *)g  :(UIView *)v;
-(void)animateTap;

- (CGPoint)newPositionWithGesture:(UIGestureRecognizer *)g inView:(UIView *)v inReferenceTo:(SKNode *)refPoint;

- (CGPoint)newPositionHorizontallyWithGesture:(UIGestureRecognizer *)g inView:(UIView *)v inReferenceTo:(SKNode *)refPoint;

- (CGPoint)newPositionVerticallyWithGesture:(UIGestureRecognizer *)g
                                     inView:(UIView *)v
                              inReferenceTo:(SKNode *)refPoint;

-(void)rotateGesture1:(UIGestureRecognizer *)g inView:(UIView *)v inReferenceTo:(SKNode *)refPoint;
-(void) fitSizeIntoSprite:(SKSpriteNode *) sprite;
@end
