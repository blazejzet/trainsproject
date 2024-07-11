//
//  MTEndLoopCart.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 11.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTEndLoopCart.h"
#import "MTGhostRepresentationNode.h"
@implementation MTEndLoopCart

- (id)initWithLoopCart:(MTCart*) cart
{
    self.beginCart = cart;
    self.isInstantCart = true;
    self.mySubTrain = cart.mySubTrain;
    return self;
}

- (bool)runMeWithGhostRepNode:(MTGhostRepresentationNode *)ghostRepNode
{
    [self setTrainVariable:[NSNumber numberWithInteger:self.beginCart.numberInCodeArray] WithName:@"main" FromGhostRepNode:ghostRepNode];
    return true;
}

@end
