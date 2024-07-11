//
//  MTGoCart.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTGoShotCart.h"
#import "MTGhostRepresentationNode.h"
#import "MTShotCartsOptions.h"
#import "MTGUI.h"
#import "MTGlobalVar.h"

@implementation MTGoShotCart
-(id) initWithSubTrain: (MTSubTrain *) t
{
    if(self = [super initWithSubTrain: t])
    {
        self.isInstantCart = false;
        self.options = [[MTShotCartsOptions alloc] init];
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

/**
 * Obliczanie dystansu jaki musi przebyc duszek w czasie jednej klatki
 */
-(CGVector)calculateValidImpulseVectorWith:(CGFloat) distance Rotation:(CGFloat)fi GhostRepresentation:(MTGhostRepresentationNode *)ghostRepNode{
    CGVector T = CGVectorMake(cosf(fi) * distance * distance ,
                              sinf(fi) * distance* distance  );
    return T;
    
}
-(CGVector)calculateValidVectorWith:(CGFloat) distance Rotation:(CGFloat)fi GhostRepresentation:(MTGhostRepresentationNode *)ghostRepNode
{
    
    //NS
    CGVector T = CGVectorMake(cosf(fi) * distance,
                              sinf(fi) * distance);
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
