//
//  MTRotateCart.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 14.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTRotateCart.h"
#import "MTRotationCartOptions.h"
#import "MTGlobalVar.h"
#import "MTGUI.h"

@implementation MTRotateCart

-(id) initWithSubTrain: (MTSubTrain *) t
{
    if(self = [super initWithSubTrain:t])
    {
        self.isInstantCart = false;
        self.options = [[MTRotationCartOptions alloc] init];
    }
    return self;
}

-(int)getCategory
{
    return MTCategoryMove;
}

-(CGFloat) getSelectedValueRotationWithGhostRep: (MTGhostRepresentationNode *) ghostRepNode
{
    CGFloat zRotationValue = [self.options.anglePanel getMySelectedValueWithGhostRepNode:ghostRepNode];
     
    zRotationValue = (zRotationValue/360.0)*6.28;
    
    return zRotationValue;
}

-(CGFloat) getSelectedValueTimeWithGhostRep: (MTGhostRepresentationNode *) ghostRepNode
{
    CGFloat time = [self.options.timePanel getMySelectedValueWithGhostRepNode:ghostRepNode] / TIME_DIVISOR;
    
    return time;
}

/**
 * Obliczanie dystansu jaki musi przebyc duszek w czasie jednej klatki
 */
-(CGFloat) getRotationForFrameWithRepNode: (MTGhostRepresentationNode*)ghostRepNode
{
    //predkosc z jaka musi poruszac sie duszek
    CGFloat time = [self getSelectedValueTimeWithGhostRep:ghostRepNode];
    CGFloat rotation = [self getSelectedValueRotationWithGhostRep:ghostRepNode];
    CGFloat rotationForFrame;
    
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

-(void)showOptions
{
    [self.options showOptions];
}

-(void) hideOptions
{
    [self.options hideOptions];
}

@end
