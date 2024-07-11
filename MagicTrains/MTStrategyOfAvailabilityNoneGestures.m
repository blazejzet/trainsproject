//
//  MTStrategyOfAvailabilityNoneGestures.m
//  MagicTrains
//
//  Created by Mateusz Wieczorkowski on 24.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTStrategyOfAvailabilityNoneGestures.h"

@implementation MTStrategyOfAvailabilityNoneGestures

static MTStrategyOfAvailabilityNoneGestures *myInstanceMTSOANG;

+(void)clear
{
    myInstanceMTSOANG = nil;
}
+ (id) getInstance
{
    if (myInstanceMTSOANG == nil)
    {
        myInstanceMTSOANG = [[self alloc] init];
    }
    return myInstanceMTSOANG;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return NO; // no... :(
}
@end
