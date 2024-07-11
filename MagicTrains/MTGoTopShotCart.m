//
//  MTGoTopCart.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 26.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTGoTopShotCart.h"
#import "MTGhostRepresentationNode.h"
#import "MTShotCartsOptions.h"
#import "MTGUI.h"
#import "MTExecutor.h"
@interface  MTGoTopShotCart()

@property CGFloat distance;
@property CGFloat distanceForFrame;
@property CGFloat fi;
@property NSNumber* obj;
@property NSUInteger indexOfI;
@end

@implementation MTGoTopShotCart

static NSString* myType = @"MTGoTopShotCart";

+(NSString*)DoGetMyType{
    return myType;
}

-(NSString*)getImageName
{
    return @"goTopShot.png";
}

-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTCart *new = [[MTGoTopShotCart alloc] initWithSubTrain:train];
    new.optionsOpen = false;
    return new;
}

-(void)compileMeForTrain:(MTTrain *)myTrain
{
    [super compileMeForTrain:myTrain];
    self.obj = [NSNumber numberWithInt: 0];
    [[[MTExecutor getInstance] variablesArray]addObject: self.obj];
    
    self.indexOfI = [[[MTExecutor getInstance] variablesArray]indexOfObject: self.obj];
}

-(BOOL)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    
    //NSInteger i = [(NSNumber *)[self getVariableWithName:@"i" Class:[NSNumber class] FromGhostRepNode:ghostRepNode] integerValue];
    
    //jezeli po raz pierwszy odpala sie run Me to przy pisujemy wartosci
    //Odpalenie jest RAZ//
    //if (i == 0)
    //{
        self.distance = [self getSelectedDirectionWithRepNode:ghostRepNode];
        self.fi = ghostRepNode.zRotation + M_PI /2;
        CGVector Vec = [self calculateValidImpulseVectorWith:self.distance*1 Rotation:self.fi GhostRepresentation:ghostRepNode];
        [ghostRepNode.physicsBody setVelocity:CGVectorMake(0,0)];
        [ghostRepNode.physicsBody applyImpulse:Vec];
      //  i++;
      //  [self setVariable:[NSNumber numberWithInteger:i] WithName:@"i" FromGhostRepNode:ghostRepNode];
        // }
    return true;
    
}

@end
