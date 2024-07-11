//
//  MTCartFactory.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 08.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTCartFactory.h"
#import "MTLocomotive.h"

@implementation MTCartFactory

+( MTCart *) createCartWithName:(enum MTCartType) number
{
    MTResources* Res = [MTResources getInstance];
    
    return [[Res getCartAt:number] getNew];
    
}

@end
