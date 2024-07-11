//
//  MTStrategyOfSimultanousPinchRotateGestures.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 11.04.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTStrategyOfSimultanousPinchRotateGestures.h"

@implementation MTStrategyOfSimultanousPinchRotateGestures
static MTStrategyOfSimultanousPinchRotateGestures* myInstanceMTSOANNPRG;

+(void)clear
{
    myInstanceMTSOANNPRG = nil;
}
+ (id) getInstance
{
    if (myInstanceMTSOANNPRG == nil)
    {
        myInstanceMTSOANNPRG = [[self alloc] init];
    }
    return myInstanceMTSOANNPRG;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if  (
         (
          ([gestureRecognizer        isKindOfClass: [UIRotationGestureRecognizer class]])||
          ([gestureRecognizer        isKindOfClass: [UIPinchGestureRecognizer class]])
          )
         &&
         (
          ([otherGestureRecognizer   isKindOfClass: [UIRotationGestureRecognizer class]])||
          ([otherGestureRecognizer   isKindOfClass: [UIPinchGestureRecognizer class]])
          )
         )
        return true;
    return false;
}
@end
