//
//  MTGoTopCart.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 26.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTGoTopCart.h"
#import "MTGoTopCart.h"
#import "MTGhostRepresentationNode.h"
#import "MTMoveCartsOptions.h"
#import "MTGUI.h"
#import "MTExecutor.h"
@interface  MTGoTopCart()

@property CGFloat distance;
@property CGFloat distanceForFrame;
@property CGFloat fi;
@property NSNumber* obj;
@property NSUInteger indexOfI;
@end

@implementation MTGoTopCart

static NSString* myType = @"MTGoTopCart";

+(NSString*)DoGetMyType{
    return myType;
}

-(NSString*)getImageName
{
    return @"goUp.png";
}

-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTCart *new = [[MTGoTopCart alloc] initWithSubTrain:train];
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
    
    //NSMutableArray* variablesArray = [[MTExecutor getInstance] variablesArray];
    
    NSInteger i = [(NSNumber *)[self getVariableWithName:@"i" Class:[NSNumber class] FromGhostRepNode:ghostRepNode] integerValue];
    //[(NSNumber *)variablesArray[self.indexOfI] integerValue];
    
    //jezeli po raz pierwszy odpala sie run Me to przypisujemy wartosci
    if(i == 0)
    {
        self.distance = [self getSelectedDirectionWithRepNode:ghostRepNode];
        self.distanceForFrame = [self getDistanceForFrameWithRepNode:ghostRepNode];
    }
    
    i++;
    
#if DEBUG_NSLog
    ////NSLog(@"[%i] strzalka w gore wykonuje sie %i raz.", self.numberInCodeArray,i);
#endif
    self.fi = ghostRepNode.zRotation + M_PI /2;
    CGVector Vec = [self calculateValidVectorWith:self.distanceForFrame Rotation:self.fi GhostRepresentation:ghostRepNode];
    [ghostRepNode setPos:CGPointMake(ghostRepNode.position.x + Vec.dx, ghostRepNode.position.y + Vec.dy)];
    
   
    if(self.distanceForFrame > 0.0 && self.distanceForFrame * (i+1) <= self.distance)
    {
        //variablesArray[self.indexOfI] = [NSNumber numberWithInteger:i];
        [self setVariable:[NSNumber numberWithInteger:i] WithName:@"i" FromGhostRepNode:ghostRepNode];
        return false;
    }
    else
    {
        i = 0;
         //variablesArray[self.indexOfI] = [NSNumber numberWithInteger:i];
        [self setVariable:[NSNumber numberWithInteger:i] WithName:@"i" FromGhostRepNode:ghostRepNode];
        
        return true;
    }
}

@end
