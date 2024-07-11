//
//  MTRotationCart.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 14.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTLeftRotationCart.h"
#import "MTTrain.h"
#import "MTGhost.h"
#import "MTGhostRepresentationNode.h"
#import "MTRotationCartOptions.h"
#import "MTGlobalVar.h"

@interface MTLeftRotationCart()

@property CGFloat zRotationValue;
@property CGFloat zRotationForFrame;

@end

@implementation MTLeftRotationCart

static NSString* myType = @"MTLeftRotationCart";


+(NSString*)DoGetMyType{
    return  myType;
}

-(NSString*)getImageName
{
    return @"rotateLeft.png";
}

-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTCart *new = [[MTLeftRotationCart alloc] initWithSubTrain:train];
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
    //NSLog(@"Chcę obr: %f",self.zRotationForFrame);
    CGFloat suma = ghostRepNode.zRotation + self.zRotationForFrame;
    //NSLog(@"Chcę suma: %f",suma);
    
    [ghostRepNode setRotation: suma];
    
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
