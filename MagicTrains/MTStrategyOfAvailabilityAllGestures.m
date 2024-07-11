//
//  MTStrategyOfAvailabilityAllGestures.m
//  MagicTrains
//
//  Created by Mateusz Wieczorkowski on 24.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTStrategyOfAvailabilityAllGestures.h"

@implementation MTStrategyOfAvailabilityAllGestures

static MTStrategyOfAvailabilityAllGestures *myInstanceMTSOAAG;

+(void)clear
{
    myInstanceMTSOAAG = nil;
}
+ (id) getInstance
{
    if (myInstanceMTSOAAG == nil)
    {
        myInstanceMTSOAAG = [[self alloc] init];
    }
    return myInstanceMTSOAAG;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}
@end
