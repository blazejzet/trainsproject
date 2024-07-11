//
//  MTGoRightCart.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 26.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTGoRightCart.h"
#import "MTGhostRepresentationNode.h"
#import "MTMoveCartsOptions.h"
#import "MTGUI.h"

@interface  MTGoRightCart()

@property CGFloat distance;
@property CGFloat distanceForFrame;
@property CGFloat fi;

@end

@implementation MTGoRightCart

static NSString* myType = @"MTGoRightCart";

+(NSString*)DoGetMyType{
    return myType;
}
-(NSString*)getImageName
{
    return @"goRight.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTCart *new = [[MTGoRightCart alloc] initWithSubTrain:train];
    new.optionsOpen = false;
    return new;
}

-(BOOL)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    NSInteger i = [(NSNumber *)[self getVariableWithName:@"i" Class:[NSNumber class] FromGhostRepNode:ghostRepNode] integerValue];
    
    //jezeli po raz pierwszy odpala sie run Me to przypisujemy wartosci;
    if (i == 0)
    {
        self.distance = [self getSelectedDirectionWithRepNode:ghostRepNode];
        self.distanceForFrame = [self getDistanceForFrameWithRepNode:ghostRepNode];
    }
    
    i++;
    
    self.fi = ghostRepNode.zRotation;
    CGVector Vec = [self calculateValidVectorWith:self.distanceForFrame Rotation:self.fi GhostRepresentation:ghostRepNode];
    [ghostRepNode setPos:CGPointMake(ghostRepNode.position.x + Vec.dx, ghostRepNode.position.y + Vec.dy)];
    
    if(self.distanceForFrame > 0.0 && self.distanceForFrame * (i+1) <= self.distance)
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
