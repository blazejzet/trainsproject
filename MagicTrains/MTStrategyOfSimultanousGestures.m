//
//  MTStrategyOfSimultanousGestures.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 11.04.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTStrategyOfSimultanousGestures.h"

@implementation MTStrategyOfSimultanousGestures
+ (id) getInstance
{
    return nil;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    //to jest potrzebne, żeby oba długie wciśnięcia były aktywne.
    if ([gestureRecognizer isKindOfClass: UILongPressGestureRecognizer.class]
        ||
        [otherGestureRecognizer isKindOfClass: UILongPressGestureRecognizer.class]
        ) {
        return true;
    }
    return false;
    
}
@end
