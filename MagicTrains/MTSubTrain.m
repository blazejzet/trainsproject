//
//  MTSubTrain.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 31.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTSubTrain.h"
#import "MTCart.h"
#import "MTRecieveSignalLocomotiv.h"
#import "MTTrain.h"
#import "MTGhost.h"
#import "MTLocomotive.h"
#import "MTExecutor.h"
#import "MTStorage.h"
#import "MTGhostRepresentationNode.h"
#import "MTSubTrainCart.h"
@implementation MTSubTrain

-(id)initWithTrain: (MTTrain *) train
{
    self.myTrain = train;
    /*[self.myTrain.subTrains addObject:self];
     self.myNumber = [self.myTrain.subTrains indexOfObject:self];*/
    self.nrOfNextCart = 0;
    self.Carts = [[NSMutableArray alloc] init];
    return self;
}
-(MTCart*)getCartAt:(uint)n
{
    
    return self.Carts[n];
}

-(bool) addCart: (MTCart *) newCart
{
    if (newCart)
    {
        [self.Carts addObject:newCart];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SubTrain Changed" object:self.myTrain];
        [self.myTrain updateMyNumber];
        return true;
    }
    return false;
}
-(bool) insertCart: (MTCart *) cart AtIndex: (NSUInteger) i
{
    if (i > [self.Carts count])
    {
        i =[self.Carts count];
    }
    if (cart.getCategory != MTCategoryLocomotive)
    {
        if([cart isKindOfClass: [MTSubTrainCart class]]){
            MTSubTrainCart * crt = ((MTSubTrainCart*) cart);
            crt.subTrain.myTrain = self.myTrain;
            crt.subTrain.myParentSubTrain = self;
        }
        [self.Carts insertObject:cart atIndex:i];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SubTrain Changed" object:self.myTrain];
        [self.myTrain updateMyNumber];
        return true;
    }
    return false;
}

-(uint) calculateDepth
{
    uint depth = 0;
    MTSubTrain *currST = self;
    
    while (currST != self.myTrain.mainSubTrain) {
        depth++;
        currST = currST.myParentSubTrain;
    }
    return depth;
}

-(void) prepareForSimulation
{
    self.myDepth = [self calculateDepth];
}

-(bool) runMeWithGhostRep:(MTGhostRepresentationNode*) ghostRepNode// InTime:
{
    
#if DEBUG_NSLog
    if (self == self.myTrain.mainSubTrain)
    {
        ////NSLog(@"MainSubTrain:%i",_nrOfNextCart);
    }
    else
        ////NSLog(@"SubTrain:%i",_nrOfNextCart);
#endif
        
        if(![MTExecutor getInstance].simulationStarted || ghostRepNode.deleted)
        {
            return true;
        }
    
    //Jezeli nie przeszedlem wszystkich wagonikow
    if (!self.completion)
    {
        //Jezeli kod w wagoniku się wykonal
        if( [[self getCartAt: self.nrOfNextCart] runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode] // InTime:];
           )
        {
            self.nrOfNextCart++;
        }
        
        ///Jeżeli przeszedłem już wszystkie wagoniki
        if (self.nrOfNextCart >= self.Carts.count)
        {
            self.nrOfNextCart = 0;
            return true;
        }
    }
    return false;
}
/*
 *
 *  Usuwanie Wagonika z pociągu
 *
 */
-(bool) removeCart: (MTCart *) cart
{
    if(self.Carts.count > 1  &&                      // z PodPociągu który ma więcej niż jeden wagonik
       cart == [self getCartAt:0] &&                 // gdy mam usunąć pierwszy wagonik
       
       //[[self getCartAt:1] getCategory] != MTCategoryLocomotive &&  // a następny wagonik nie jest lokomotywką
       self.myTrain.mainSubTrain == self)            // i jest głównym PodPociągiem w MTTrain
    {
        return false;
    }
    [self.Carts removeObject:cart];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Cart Removed" object:self.myTrain];
    if (self.Carts.count == 0)
    {
        if (self.myParentSubTrain == nil)
        {
            [self.myTrain.myGhost removeTrain: self.myTrain];
        }
    }
    
    return true;
}

-(bool) removeAllCarts{
    [self.Carts removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubTrain Changed" object:self.myTrain];
    if (self.Carts.count == 0)
    {
        if (self.myParentSubTrain == nil)
        {
            [self.myTrain.myGhost removeTrain: self.myTrain];
        }
    }
    return true;
}

///-----------------------------------------------------------------
/// Serializacja ---------------------------------------------------
///-----------------------------------------------------------------
- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject: self.Carts forKey:@"Carts"];
    [encoder encodeObject: self.myTrain forKey:@"myTrain"];
    [encoder encodeObject: self.myParentSubTrain forKey:@"myParentSubTrain"];
    
}
- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [self initWithTrain:[decoder decodeObjectForKey:@"myTrain"]];
    self.myParentSubTrain = [decoder decodeObjectForKey:@"myParentSubTrain"];
    self.Carts = [decoder decodeObjectForKey:@"Carts"];
    
    [self setNrOfNextCart: 0];
    return self;
}

@end