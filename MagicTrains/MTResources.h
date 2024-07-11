//
//  MTResources.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 14.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTCart.h"



@interface MTResources : NSObject

@property NSMutableDictionary* carts;

//Poczebne do zachowania kolejnosci w category bar
@property NSMutableArray* keys;

-(MTCart *) getCartOfType:(NSString *)key;

+(MTResources* ) getInstance;
+(MTResources* ) getInstance:(NSArray*)lista;
@end
