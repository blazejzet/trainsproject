//
//  MTRotationCart.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 14.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTReAlphaCart.h"
#import "MTTrain.h"
#import "MTGhost.h"
#import "MTGUI.h"

#import "MTGhostRepresentationNode.h"
#import "MTReAlphaCartOptions.h"
#import "MTGlobalVar.h"

@interface MTReAlphaCart()

@property CGFloat zRotationValue;
@property CGFloat zRotationForFrame;

@end

@implementation MTReAlphaCart

static NSString* myType = @"MTReAlphaCart";


+(NSString*)DoGetMyType{
    return  myType;
}

-(NSString*)getImageName
{
    return @"reAlphaCart.png";
}

-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTCart *new = [[MTReAlphaCart alloc] initWithSubTrain:train];
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
    
    ////NSLog(@"ALPHA PER FRAME %ld: %f",(long)i,  self.zRotationForFrame);
    ghostRepNode.alpha=ghostRepNode.alpha+self.zRotationForFrame;
    
    if(self.zRotationForFrame != 0 && ((self.zRotationForFrame <0 && ghostRepNode.alpha >= self.zRotationValue)||(self.zRotationForFrame >0 && ghostRepNode.alpha <= self.zRotationValue)) && ghostRepNode.alpha>=0.0 && ghostRepNode.alpha<=1.0)
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


-(CGFloat) getRotationForFrameWithRepNode: (MTGhostRepresentationNode*)ghostRepNode
{
    //predkosc z jaka musi poruszac sie duszek
    CGFloat time = [self getSelectedValueTimeWithGhostRep:ghostRepNode];
    CGFloat docelowa = [self getSelectedValueRotationWithGhostRep:ghostRepNode];
    CGFloat rotationForFrame;
    
    CGFloat aktualna = ghostRepNode.alpha;
    CGFloat rotation = docelowa-aktualna;
    
    if( time <= 0.0 )
    {
        rotationForFrame = rotation;
        
    }
    else
    {
        CGFloat speed = rotation / time;
        rotationForFrame = speed * FRAME_TIME;
    }
    
    return rotationForFrame;
}

@end
