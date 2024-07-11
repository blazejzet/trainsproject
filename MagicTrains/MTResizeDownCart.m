//
//  MTRotationCart.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 14.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTResizeDownCart.h"
#import "MTTrain.h"
#import "MTGhost.h"
#import "MTGhostRepresentationNode.h"
#import "MTResizeCartOptions.h"
#import "MTGlobalVar.h"

@interface MTResizeDownCart()

@property CGFloat zRotationValue;
@property CGFloat zRotationForFrame;

@end

@implementation MTResizeDownCart

static NSString* myType = @"MTResizeDownCart";


+(NSString*)DoGetMyType{
    return  myType;
}

-(NSString*)getImageName
{
    return @"resizeDown.png";
}

-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTCart *new = [[MTResizeDownCart alloc] initWithSubTrain:train];
    //new.options = [[MTResizeCartOptions alloc] init];
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
    
    if(ghostRepNode.xScale>0.5){
        ghostRepNode.xScale *=(1- self.zRotationForFrame);
        ghostRepNode.yScale *=(1- self.zRotationForFrame);
        // ghostRepNode.xScale -= self.zRotationForFrame;
       // ghostRepNode.yScale -= self.zRotationForFrame;
    }else{
        ghostRepNode.xScale=0.5;
        ghostRepNode.yScale=0.5;
    }
    if(ghostRepNode.xScale<0.5){
        ghostRepNode.xScale=0.5;
        ghostRepNode.yScale=0.5;
    }
    
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
