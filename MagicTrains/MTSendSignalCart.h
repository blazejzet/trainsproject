//
//  MTSendSignalCart.h
//  MagicTrains
//
//  Created by Kamil Tomasiak on 18.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCart.h"

@interface MTSendSignalCart : MTCart

@property NSString* signalColor;

-(id) initWithSubTrain:(MTSubTrain *)t;

@end
