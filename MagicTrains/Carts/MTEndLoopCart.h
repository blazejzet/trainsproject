//
//  MTEndLoopCart.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 11.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCart.h"

@interface MTEndLoopCart : MTCart

- (id)initWithLoopCart:(MTCart*) cart;
@property MTCart* beginCart;

@end
