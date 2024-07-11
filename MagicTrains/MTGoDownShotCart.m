//
//  MTGoDownCart.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 26.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTGoDownShotCart.h"
#import "MTGhostRepresentationNode.h"
#import "MTMoveCartsOptions.h"
#import "MTGUI.h"

@interface  MTGoDownShotCart()

@property CGFloat distance;
@property CGFloat distanceForFrame;
@property CGFloat fi;

@end

@implementation MTGoDownShotCart

static NSString* myType = @"MTGoDownShotCart";
//rSKAction act;


+(NSString*)DoGetMyType{
    return myType;
}
-(NSString*)getImageName
{
    return @"goDownShot.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTCart *new = [[MTGoDownShotCart alloc] initWithSubTrain:train];
    new.optionsOpen = false;
    return new;
}

-(BOOL)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    /*NSInteger i = [(NSNumber *)[self getVariableWithName:@"i" Class:[NSNumber class] FromGhostRepNode:ghostRepNode] integerValue];
    
    //jezeli po raz pierwszy odpala sie run Me to przypisujemy wartosci
    if (i == 0)
    {
        self.distance = [self getSelectedDirectionWithRepNode:ghostRepNode];
        
        self.fi = ghostRepNode.zRotation - M_PI/2;
        CGVector Vec = [self calculateValidImpulseVectorWith:self.distance*1 Rotation:self.fi GhostRepresentation:ghostRepNode];
        ////NSLog(@"XXX> %f Vecx:%f, Vecy:%f", self.distance*1, Vec.dx, Vec.dy);
        ////NSLog(@"YYY> %@",ghostRepNode.physicsBody);
        ////NSLog(@"YY %f",ghostRepNode.physicsBody.mass);
        ////NSLog(@"YY %d",ghostRepNode.physicsBody.dynamic);
        
        [ghostRepNode.physicsBody applyImpulse:Vec];
        i++;
        [self setVariable:[NSNumber numberWithInteger:i] WithName:@"i" FromGhostRepNode:ghostRepNode];
    }
    */
    self.distance = [self getSelectedDirectionWithRepNode:ghostRepNode];
    self.fi = ghostRepNode.zRotation - M_PI/2 ;
    CGVector Vec = [self calculateValidImpulseVectorWith:self.distance*1 Rotation:self.fi GhostRepresentation:ghostRepNode];
    [ghostRepNode.physicsBody setVelocity:CGVectorMake(0,0)];
    [ghostRepNode.physicsBody applyImpulse:Vec];

    
    
    return true;
}

@end
