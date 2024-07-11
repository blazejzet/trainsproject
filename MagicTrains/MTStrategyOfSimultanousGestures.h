//
//  MTStrategyOfSimultanousGestures.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 11.04.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTStrategyOfSimultanousGestures : NSObject
+ (id) getInstance;
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
@end
