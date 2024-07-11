//
//  MTGestureDelegate.h
//  testNodow
//
//  Created by Dawid Skrzypczyński on 19.12.2013.
//  Copyright (c) 2013 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTGestureDelegate <NSObject>

/* Interfejs obslugi gestow */
-(void) tapGesture:(UIGestureRecognizer *)g;
-(void) panGesture:(UIGestureRecognizer *) g :(UIView *) v ;
-(void) pinchGesture:(UIGestureRecognizer *) g :(UIView *) v;
-(void) rotateGesture:(UIGestureRecognizer *) g :(UIView *) v;
-(void) swipe:(UISwipeGestureRecognizer *) g :(UIView *) v;
-(void) hold:(UIGestureRecognizer *)g :(UIView*) v;

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

@end
