//
//  MTRotationCart.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 14.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTResizeUpCart.h"
#import "MTTrain.h"
#import "MTGhost.h"
#import "MTGhostRepresentationNode.h"
#import "MTResizeCartOptions.h"
#import "MTGlobalVar.h"

@interface MTResizeUpCart()

@property CGFloat zRotationValue;
@property CGFloat zRotationForFrame;

@end

@implementation MTResizeUpCart

static NSString* myType = @"MTResizeUpCart";


+(NSString*)DoGetMyType{
    return  myType;
}

-(NSString*)getImageName
{
    return @"resizeUp.png";
}

-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTCart *new = [[MTResizeUpCart alloc] initWithSubTrain:train];
 //   new.options = [[MTResizeCartOptions alloc] init];
    
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
    if(ghostRepNode.xScale<2.0){
        ghostRepNode.xScale *=(1+ self.zRotationForFrame);
        ghostRepNode.yScale *=(1+self.zRotationForFrame);
    }else{
        ghostRepNode.xScale =2.0;
        ghostRepNode.yScale =2.0;
    }
    if(ghostRepNode.xScale>2.0){
       
        ghostRepNode.xScale =2.0;
        ghostRepNode.yScale =2.0;
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
