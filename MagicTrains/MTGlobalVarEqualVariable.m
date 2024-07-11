//
//  MTGlobalVarEqualVariable.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 28.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//
#import "MTGlobalVarEqualVariable.h"
#import "MTGlobalVariableCartsOptions.h"
#import "MTGhostRepresentationNode.h"
#import "MTStorage.h"
#import "MTGlobalVar.h"

@implementation MTGlobalVarEqualVariable

static NSString* myType = @"MTGlobalVarEqualVariable";


+(NSString*)DoGetMyType{
    return  myType;
}

-(NSString*)getImageName
{
    return @"equalCart.png";
}

-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTCart *new = [[MTGlobalVarEqualVariable alloc] initWithSubTrain:train];
    new.optionsOpen = false;
    return new;
}

-(int)getCategory
{
    return MTCategoryLogic;
}

-(BOOL)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    CGFloat value = [self getSelectedValue: ghostRepNode];
    
    //numer zaznaczonej zmiennej
    uint selectedVariable = [self.options.choicePanel numberSelectedVariableForSet];
    
    MTGlobalVar * globalVar = [MTGlobalVar getInstance];
    
    [globalVar setGlobalValueWithNumber:selectedVariable valueForSet: value];
    
    return true;
}

@end