//
//  MTStrategyOfAvailabilityGestures.m
//  MagicTrains
//
//  Created by Mateusz Wieczorkowski on 24.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTStrategyOfAvailabilityGestures.h"

@implementation MTStrategyOfAvailabilityGestures
+ (id) getInstance
{
    return nil;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}
@end
