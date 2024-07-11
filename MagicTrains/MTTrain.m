//
//  MTTrain.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 09.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTTrain.h"
#import "MTAlwaysLocomotiv.h"
#import "MTGhost.h"
#import "MTCart.h"
#import "MTSubTrain.h"
#import "MTSubTrainCart.h"
#import "MTGhostRepresentationNode.h"
#import "MTJoystickDropLocomotivProtocol.h"
#import "MTEndLoopCart.h"
#import "MTIfCart.h"
#import "MTCodeTabTypeEnum.h"
#import "MTStorage.h"
@interface MTTrain ()

@end

@implementation MTTrain

-(id)initWithTabNr:(uint)nr
             ghost:(MTGhost *) ghost
          position:(CGPoint) pos
{
    self.mainSubTrain = [[MTSubTrain alloc]initWithTrain:self];
    self.tabNr = nr;
    self.myGhost = ghost;
    self.positionInCodeArea = pos;
    return self;
}

/// ---------------------------------------
/// Kompilacja kodu
/// ---------------------------------------

-(void) consolidateCode
{
    self.code = [[NSMutableArray alloc] init];
    
    [self.code addObjectsFromArray:[self consolidateSubTrain:self.mainSubTrain]];
    
    for (int i = 0 ;i < self.code.count;i++)
    {
#if DEBUG_NSLog
        ////NSLog(@"%i\t%@",i,self.code[i]);
#endif
    }
}

-(NSMutableArray *) consolidateSubTrain: (MTSubTrain*) subTrain
{
    NSMutableArray *code = [[NSMutableArray alloc]init];
    
    for (int i = 0; i< subTrain.Carts.count; i++)
    {
        MTCart* cart = subTrain.Carts[i];
        [code addObject:cart];
        if ([cart isKindOfClass: [MTSubTrainCart class]]) ///JEzeli wagonik ma podpociąg
        {
            MTSubTrainCart *STCart = (MTSubTrainCart *) cart;
            //tablica wagonow podpociagu
            NSMutableArray *subTrainCarts = [self consolidateSubTrain: STCart.subTrain];
#if DEBUG_NSLog
            ////NSLog(@"Subtrain ma %i elementow", subTrainCarts.count);
#endif
            /// Jezeli STCart nie jest typu MTIfCart to dodaj "wagonik powrotu na poczatek petli" na koniec petli
            if (![STCart isKindOfClass: [MTIfCart class]])
                [subTrainCarts addObject: [[MTEndLoopCart alloc] initWithLoopCart:STCart]];
            
            STCart.lenghtOfLoopInCode = subTrainCarts.count;
            //NSRange range = NSMakeRange( i+1 , arr.count );
            [code addObjectsFromArray:subTrainCarts];
            //[code insertObjects:arr atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        }
    }
    
    return code;
}

-(void) prepareMeBeforeSimulation
{
    [self.mainSubTrain setCompletion: FALSE];
    
    [self consolidateCode];
    
    for (int i = 0 ; i < self.code.count ; i++)
    {
        [(MTCart *)self.code[i] compileMeForTrain:self];
    }
}

-(bool) runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode// InTime: ];
{
    
    @try{
    NSInteger cart_index = [(NSNumber*)[ghostRepNode getVariableWithName:@"main" Class:[NSNumber class] ForCartNo:-1 TrainNo:[self myNumber]]  integerValue];
    
#if DEBUG_NSLog
    ////NSLog(@"[%i] teraz mam: %i",self.myNumber,cart_index);
#endif
    
    bool lastCartWasFisnished;
    bool ret;
    bool lastCartWasInstant;
    ret = false;
    
    do {
        if (cart_index < self.code.count)
        {
            lastCartWasFisnished =
                [(MTCart *)self.code[cart_index] runMeWithGhostRepNode:ghostRepNode];
    
#if DEBUG_NSLog
            ////NSLog(@"[%i] wykonalem: %i",self.myNumber,cart_index);
#endif
            
            lastCartWasInstant =
                [(MTCart *)self.code[cart_index] isInstantCart];
            if (lastCartWasFisnished)
            {
                NSInteger c = [(NSNumber*)[ghostRepNode getVariableWithName:@"main" Class:[NSNumber class] ForCartNo:-1 TrainNo: self.myNumber] integerValue];
                
                if (c == cart_index)
                {
                    cart_index ++;
#if DEBUG_NSLog
                    ////NSLog(@"[%i] Zwiekszam indeks",self.myNumber);
#endif
                    [ghostRepNode setVariable:[[NSNumber alloc]initWithInteger:cart_index] WithName:@"main" ForCartNo:-1 TrainNo:[self myNumber]];
                }else
                {
#if DEBUG_NSLog
                    ////NSLog(@"[%i] Przepisuje indeks",self.myNumber);
#endif
                    cart_index = c;
                }
            }
            
#if DEBUG_NSLog
            ////NSLog(@"[%i] nastepny bedzie: %i",self.myNumber,cart_index);
#endif
            
        }
        else //zakonczenie pociagu
        {
            //zerowanie zeby pociagi ktore reaguja na zderzenia mogly wykonac wielokrotnie kod
            cart_index = 0;
            [ghostRepNode setVariable:[[NSNumber alloc]initWithInteger:cart_index] WithName:@"main" ForCartNo:-1 TrainNo:[self myNumber]];
#if DEBUG_NSLog
            ////NSLog(@"[%i] koniec dzialania",self.myNumber);
#endif
            
            ret = true;
            break;
        }
    }while (lastCartWasInstant);
    
    
    [ghostRepNode setVariable:[[NSNumber alloc]initWithInteger:cart_index] WithName:@"main" ForCartNo:-1 TrainNo:[self myNumber]];
    return ret;
    }@catch(NSException* e){
        ////NSLog(@"%@",e);
        return false;
    }
}

-(bool) insertCart: (MTCart *) newCart AtIndex:(int) index
{
    if([newCart getCategory] != 1 && self.mainSubTrain.Carts.count == 0)
    {
        return false;
    }
    else
    {
        [self.mainSubTrain insertCart:newCart AtIndex:index];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Train Changed" object:self];
    }
    return true;
}

-(bool) addCart: (MTCart *) newCart
{
    if([newCart getCategory] != 1 && self.mainSubTrain.Carts.count == 0)
    {
        return false;
    }
    else
    {
        [self.mainSubTrain addCart:newCart];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Train Changed" object:self];
    }
    return true;
}
///------------------
/// Numeracja
///------------------
-(void)updateMyNumber
{
    self.myNumber = [self.myGhost.trains indexOfObject:self];
}

-(uint) getTabNumber
{
    return self.tabNr;
}

-(bool) isTabBlocked
{
    return [[MTStorage getInstance] getCodeTabTypeAt:[self getTabNumber]] == MTCodeTabProjectTypeBlocked;
}
///--------------------------------------------------------------------------\\\
// Serializacja                                                               \\
///--------------------------------------------------------------------------\\\

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeFloat:[self positionInCodeArea].x forKey:@"positionInCodeArea_x"];
    [encoder encodeFloat:[self positionInCodeArea].y forKey:@"positionInCodeArea_y"];
    [encoder encodeObject:[self mainSubTrain] forKey:@"mainSubTrain"];
    [encoder encodeInteger:[self tabNr] forKey: @"tabNr"];
    
    [encoder encodeObject:[self myGhost] forKey:@"myGhost"];
    [encoder encodeInteger:[self myNumber] forKey:@"myTrainNumber"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    [self setPositionInCodeArea: CGPointMake(
                  [decoder decodeFloatForKey: @"positionInCodeArea_x"],
                  [decoder decodeFloatForKey: @"positionInCodeArea_y"])];
    
    [self setTabNr:[decoder decodeIntegerForKey:@"tabNr"]];
    [self setMyGhost: [decoder decodeObjectForKey:@"myGhost"]];
    [self setMyNumber: [decoder decodeIntegerForKey:@"myTrainNumber"]];
    [[self myGhost]addTrain:self];
    [self setMainSubTrain:[decoder decodeObjectForKey:@"mainSubTrain"]];
    
    return self;
}

-(MTCart* ) getFirstCart
{
   return self.mainSubTrain.Carts[0];
}


@end
