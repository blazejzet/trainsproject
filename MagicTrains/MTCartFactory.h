//
//  MTCartFactory.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 08.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTCart.h"
#import "MTResources.h"
@interface MTCartFactory : NSObject

+( MTCart *) createCartWithName:(enum MTCartType) number;

@end
