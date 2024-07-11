//
//  MTStrategyOfAvailabilityAllGestures.h
//  MagicTrains
//
//  Created by Mateusz Wieczorkowski on 24.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTStrategyOfAvailabilityGestures.h"

@interface MTStrategyOfAvailabilityAllGestures : MTStrategyOfAvailabilityGestures

+(id) getInstance;
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

+(void)clear;
@end
