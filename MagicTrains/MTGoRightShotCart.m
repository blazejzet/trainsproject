//
//  MTGoRightCart.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 26.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTGoRightShotCart.h"
#import "MTGhostRepresentationNode.h"
#import "MTShotCartsOptions.h"
#import "MTGUI.h"

@interface  MTGoRightShotCart()

@property CGFloat distance;
@property CGFloat distanceForFrame;
@property CGFloat fi;

@end

@implementation MTGoRightShotCart

static NSString* myType = @"MTGoRightShotCart";

+(NSString*)DoGetMyType{
    return myType;
}
-(NSString*)getImageName
{
    return @"goRightShot.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTCart *new = [[MTGoRightShotCart alloc] initWithSubTrain:train];
    new.optionsOpen = false;
    return new;
}

-(BOOL)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    
    /*NSInteger i = [(NSNumber *)[self getVariableWithName:@"i" Class:[NSNumber class] FromGhostRepNode:ghostRepNode] integerValue];
    
    //jezeli po raz pierwszy odpala sie run Me to przy pisujemy wartosci
    if (i == 0)
    {
        self.distance = [self getSelectedDirectionWithRepNode:ghostRepNode];
        self.fi = ghostRepNode.zRotation;
       
        CGVector Vec = [self calculateValidImpulseVectorWith:self.distance*1 Rotation:self.fi GhostRepresentation:ghostRepNode];
        ////NSLog(@"XXX> %f Vecx:%f, Vecy:%f", self.distance*1, Vec.dx, Vec.dy);
        
        [ghostRepNode.physicsBody applyImpulse:Vec];
        i++;
        [self setVariable:[NSNumber numberWithInteger:i] WithName:@"i" FromGhostRepNode:ghostRepNode];
    }*/
    self.distance = [self getSelectedDirectionWithRepNode:ghostRepNode];
    self.fi = ghostRepNode.zRotation ;
    CGVector Vec = [self calculateValidImpulseVectorWith:self.distance*1 Rotation:self.fi GhostRepresentation:ghostRepNode];
    [ghostRepNode.physicsBody setVelocity:CGVectorMake(0,0)];
    [ghostRepNode.physicsBody applyImpulse:Vec];

    return true;
    
}

@end
