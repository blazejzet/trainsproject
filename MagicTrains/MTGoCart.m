//
//  MTGoCart.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTGoCart.h"
#import "MTGhostRepresentationNode.h"
#import "MTMoveCartsOptions.h"
#import "MTGUI.h"
#import "MTGlobalVar.h"

@implementation MTGoCart
-(id) initWithSubTrain: (MTSubTrain *) t
{
    if(self = [super initWithSubTrain: t])
    {
        self.isInstantCart = false;
        self.options = [[MTMoveCartsOptions alloc] init];
    }
    return self;
}
-(int)getCategory
{
    return MTCategoryMove;
}

-(void)showOptions
{
    [self.options showOptions];
    self.optionsOpen = true;
}

-(void) hideOptions
{
    [self.options hideOptions];
    self.optionsOpen = false;
}
-(CGFloat) getSelectedDirectionWithRepNode:(MTGhostRepresentationNode*)ghostRepNode
{
    CGFloat distance = [self.options.distancePanel getMySelectedValueWithGhostRepNode:ghostRepNode];
    
    if (distance < 0.0)
    {
        distance = 0.0;
    }
    
    return distance;
}
-(CGFloat) getSelectedTimeWithRepNode:(MTGhostRepresentationNode*)ghostRepNode
{
    CGFloat time = [self.options.timePanel getMySelectedValueWithGhostRepNode:ghostRepNode];
    
    time = time / TIME_DIVISOR;
    
    if (time < 0.0)
    {
        time = 0.0;
    }
    
    return time;
}

/**
 * Obliczanie dystansu jaki musi przebyc duszek w czasie jednej klatki
 */
-(CGFloat) getDistanceForFrameWithRepNode: (MTGhostRepresentationNode*)ghostRepNode
{
    //predkosc z jaka musi poruszac sie duszek
    CGFloat time = [self getSelectedTimeWithRepNode:ghostRepNode];
    CGFloat distance = [self getSelectedDirectionWithRepNode:ghostRepNode];
    CGFloat distanceForFrame;
    
    if( time < 0.1 )
    {
        distanceForFrame = distance;
    }
    else
    {
        CGFloat speed = distance / time;
        distanceForFrame = speed * FRAME_TIME;
    }
        
    return distanceForFrame;
}
-(CGVector)calculateValidImpulseVectorWith:(CGFloat) distance Rotation:(CGFloat)fi GhostRepresentation:(MTGhostRepresentationNode *)ghostRepNode{
    CGVector T = CGVectorMake(cosf(fi) * distance * ghostRepNode.xScale,
                              sinf(fi) * distance * ghostRepNode.xScale);
    return T;
    
}
-(CGVector)calculateValidVectorWith:(CGFloat) distance Rotation:(CGFloat)fi GhostRepresentation:(MTGhostRepresentationNode *)ghostRepNode
{
    CGVector T = CGVectorMake(cosf(fi) * distance,
                              sinf(fi) * distance);
    
    return T;
    /*
    //////NSLog(@"\n\t T = (%f,%f)",T.dx,T.dy);
    
    CGFloat a = ghostRepNode.size.height;
    //////NSLog(@"\n\t a = %f",a);
    
    CGPoint d = CGPointMake(0.0, 0.0);
    if (T.dx > 0.0)
    {
        d.x =  (WIDTH - a)/2 - ghostRepNode.position.x;
    }else if (T.dx < 0)
    {
        d.x = -(WIDTH - a)/2 - ghostRepNode.position.x;
        
    }else
    {
        d.x = 0;
    }
    if (T.dy > 0.0)
    {
        d.y =  (HEIGHT - a)/2 - ghostRepNode.position.y;
    }else if (T.dy < 0)
    {
        d.y = -(HEIGHT - a)/2 - ghostRepNode.position.y;
        
    }else
    {
        d.y = 0;
    }
    //////NSLog(@"\n\t d  = (%f,%f)",d.x,d.y);
    
    CGPoint e = CGPointMake(fabsf(T.dx) -  fabsf(d.x), fabsf(T.dy) - fabsf(d.y));
    CGFloat E = fmaxf(e.x, e.y);
    //////NSLog(@"\n\t e  = (%f,%f) E = %f",e.x,e.y,E);
    if (E>0.0)
    {
        if (e.x > e.y)
        {
            T.dy *= (d.x / T.dx);
            T.dx = d.x;
        }else
        {
            
            T.dx *= d.y / T.dy;
            T.dy = d.y;
        }
    }
    
    //////NSLog(@"\n\t T' = (%f,%f)",T.dx,T.dy);
    /*if (-0.5 < T.dx && T.dx < 0.5)
    {
        T = CGVectorMake(0.0 , T.dy);
    }
    if (-0.5 < T.dy && T.dy < 0.5)
    {
        T = CGVectorMake(T.dx , 0.0);
    }*/
    //////NSLog(@"\n\t T' = (%f,%f)",T.dx,T.dy);
    return T;
    
}
@end
