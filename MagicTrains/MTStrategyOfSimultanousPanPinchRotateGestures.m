//
//  MTStrategyOfSimultanousPanPinchRotateGestures.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 11.04.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTStrategyOfSimultanousPanPinchRotateGestures.h"

@implementation MTStrategyOfSimultanousPanPinchRotateGestures
static MTStrategyOfSimultanousPanPinchRotateGestures* myInstanceMTSOANNRG;

+(void)clear
{
    myInstanceMTSOANNRG = nil;
}
+ (id) getInstance
{
    if (myInstanceMTSOANNRG == nil)
    {
        myInstanceMTSOANNRG = [[self alloc] init];
    }
    return myInstanceMTSOANNRG;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if  (
         (
          ([gestureRecognizer        isKindOfClass: [UIPanGestureRecognizer class]])||
          ([gestureRecognizer        isKindOfClass: [UIRotationGestureRecognizer class]])||
          ([gestureRecognizer        isKindOfClass: [UIPinchGestureRecognizer class]])
         )
         &&
         (
          ([otherGestureRecognizer   isKindOfClass: [UIPanGestureRecognizer class]])||
          ([otherGestureRecognizer   isKindOfClass: [UIRotationGestureRecognizer class]])||
          ([otherGestureRecognizer   isKindOfClass: [UIPinchGestureRecognizer class]])
         )
        )
        return true;
    return false;
}
@end
