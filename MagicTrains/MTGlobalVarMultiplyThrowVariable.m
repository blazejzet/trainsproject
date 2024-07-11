//
//  MTGlobalVarMultiplyThrowVariable.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 28.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//
#import "MTGlobalVarMultiplyThrowVariable.h"
#import "MTGlobalVariableCartsOptions.h"
#import "MTGhostRepresentationNode.h"
#import "MTStorage.h"
#import "MTGlobalVar.h"

@implementation MTGlobalVarMultiplyThrowVariable

static NSString* myType = @"MTGlobalVarMultiplyThrowVariable";

+(NSString*)DoGetMyType{
    return  myType;
}

-(NSString*)getImageName
{
    return @"multiplyCart.png";
}

-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTCart *new = [[MTGlobalVarMultiplyThrowVariable alloc] initWithSubTrain:train];
    new.optionsOpen = false;
    return new;
}

-(BOOL)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    CGFloat value = [self getSelectedValue: ghostRepNode];
    
    MTGlobalVar * globalVar = [MTGlobalVar getInstance];
    
    uint selectedVariable = [self.options.choicePanel numberSelectedVariableForSet];
    
    CGFloat valueForSet = [self checkRange:[globalVar getGlobalValueWithNumber:selectedVariable] * value];
    [globalVar setGlobalValueWithNumber:selectedVariable valueForSet: valueForSet];
    
    return true;
}

@end