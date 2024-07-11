//
//  MTRightRotationCart.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 30.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//
#import "MTRightRotationCart.h"
#import "MTTrain.h"
#import "MTGhost.h"
#import "MTGhostRepresentationNode.h"
#import "MTRotationCartOptions.h"

@interface MTRightRotationCart()

@property CGFloat zRotationValue;
@property CGFloat zRotationForFrame;

@end

@implementation MTRightRotationCart

static NSString* myType = @"MTRightRotationCart";

+(NSString*)DoGetMyType{
    return  myType;
}

-(NSString*)getImageName
{
    return @"rotateRight.png";
}

-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTCart *new = [[MTRightRotationCart alloc] initWithSubTrain:train];
    new.optionsOpen = false;
    return new;
}

-(BOOL)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    NSInteger i = [(NSNumber *)[self getVariableWithName:@"i" Class:[NSNumber class] FromGhostRepNode:ghostRepNode] integerValue];
    
    if (i == 0)
    {
        self.zRotationValue = [self getSelectedValueRotationWithGhostRep:ghostRepNode];
        self.zRotationForFrame = [self getRotationForFrameWithRepNode:ghostRepNode];
    }
    
    i++;
    [ghostRepNode setRotation:(ghostRepNode.zRotation - self.zRotationForFrame) ];
    
    if(self.zRotationForFrame > 0 && self.zRotationForFrame * (i+1) <= self.zRotationValue)
    {
        [self setVariable:[NSNumber numberWithInteger:i] WithName:@"i" FromGhostRepNode:ghostRepNode];
        
        return false;
    }
    else
    {
        i = 0;
        [self setVariable:[NSNumber numberWithInteger:i] WithName:@"i" FromGhostRepNode:ghostRepNode];
        
        return true;
    }
}



@end
