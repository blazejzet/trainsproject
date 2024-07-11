//
//  MTRotateToAngleCart.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 02.05.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTRotateToAngleCart.h"
#import "MTTrain.h"
#import "MTGhost.h"
#import "MTGhostRepresentationNode.h"
#import "MTRotationCartOptions.h"
#import "MTGUI.h"

@interface MTRotateToAngleCart()
@property CGFloat time;
@property CGFloat rotation;
@property CGFloat rotationForFrame;
@end

@implementation MTRotateToAngleCart

static NSString* myType = @"MTRotateToAngleCart";


+(NSString*)DoGetMyType{
    return  myType;
}

-(NSString*)getImageName
{
    return @"rotateToAngle.png";
}

-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTCart *new = [[MTRotateToAngleCart alloc] initWithSubTrain:train];
    new.optionsOpen = false;
    return new;
}

-(BOOL)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
 

    NSInteger i = [(NSNumber *)[self getVariableWithName:@"i" Class:[NSNumber class] FromGhostRepNode:ghostRepNode] integerValue];
    if (i == 0)
    {
        self.time = [self getSelectedValueTimeWithGhostRep:ghostRepNode];
        self.rotation = [self getSelectedValueRotationWithGhostRep:ghostRepNode] - ghostRepNode.zRotation;
        
        if( self.time <= 0.0 )
        {
            self.rotationForFrame = self.rotation;
        }
        else
        {
            //predkosc z jaka musi poruszac sie duszek
            CGFloat speed = self.rotation / self.time;
            //ilosc posuniec na klatke
            self.rotationForFrame = speed * FRAME_TIME;
        }
    }
    
    i++;
    [ghostRepNode setRotation:(ghostRepNode.zRotation + self.rotationForFrame) ];
    
    if(fabsf(self.rotationForFrame) > 0.0 && (fabsf(self.rotationForFrame) * (i+1)) <= fabsf(self.rotation))
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
