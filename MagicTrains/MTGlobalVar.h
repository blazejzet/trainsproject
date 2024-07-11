//
//  MTGlobalVar.h
//  MagicTrains
//
//  Created by Kamil Tomasiak on 05.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTGlobalVar : NSObject

@property CGFloat userVar1;
@property CGFloat userVar2;
@property CGFloat userVar3;
@property CGFloat userVar4;
@property CGFloat userVar5;

+(MTGlobalVar *) getInstance ;
-(CGFloat) getGlobalValueWithNumber : (uint)variableNumber;
-(void) setGlobalValueWithNumber : (uint)variableNumber valueForSet: (CGFloat)value;
-(CGFloat) getGlobalValue5WithRangeFrom: (CGFloat)startNumber to: (CGFloat)endNumber;
-(void) setVariableTo0;

+(void)clear;
@end
