//
//  MTGlobalVar.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 05.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//
// OPIS:
// Zmienne globalne maja numery od 1 do 5,
// zmienna 5 jest zmienna losowa ktora ma za kazdym razem kiedy jest pobierana inna wartosc
// -> Zmienne numer 1-5 : zmienne globalne
// -> numer 6 - zmienna zawierajaca ilosc zycia
// -> numer 7,8 - zmienne zawierajace pozycje X,Y duszka

#import "MTGlobalVar.h"
#define ARC4RANDOM_MAX      0x100000000

@implementation MTGlobalVar

static MTGlobalVar * myInstanceGV;


+(void)clear
{
    myInstanceGV = nil;
}

+(MTGlobalVar *) getInstance
{
    if (!myInstanceGV)
    {
        myInstanceGV = [[MTGlobalVar alloc] init];
    }
    
    return myInstanceGV;
}

-(id) init {
    
    [self setVariableTo0];
    
    return self;
}

-(void) setVariableTo0
{
    self.userVar1 = 0;
    self.userVar2 = 0;
    self.userVar3 = 0;
    self.userVar4 = 0;
    self.userVar5 = 0;
}


-(CGFloat) getGlobalValueWithNumber : (uint)variableNumber {
    switch (variableNumber){
        case 1:
            return  self.userVar1;
            break;
            
        case 2:
            return self.userVar2;
            break;
            
        case 3:
            return self.userVar3;
            break;
            
        case 4:
            return self.userVar4;
            break;
            
        default:
            return 0;
            break;
    }
}

/**
 * Metoda zwraca wylosowana wartosc z podanego przedzialu dla zmiennej losowej (numer 5).
 */
-(CGFloat) getGlobalValue5WithRangeFrom: (CGFloat)startNumber to: (CGFloat)endNumber
{
    float range = endNumber - startNumber;
    float val = ((CGFloat)arc4random() / ARC4RANDOM_MAX) * range + startNumber;

    return val;
}

-(void) setGlobalValueWithNumber : (uint)variableNumber valueForSet: (CGFloat)value
{
    switch (variableNumber){
        case 1:
            self.userVar1 = value;
            break;
            
        case 2:
            self.userVar2 = value;
            break;
            
        case 3:
            self.userVar3 = value;
            break;
            
        case 4:
            self.userVar4 = value;
            break;
    }
}

@end
