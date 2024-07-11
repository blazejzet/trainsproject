//
//  MTGlobalVarMinusVariable.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 28.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTGlobalVarMinusVariable.h"
#import "MTGlobalVariableCartsOptions.h"
#import "MTGhostRepresentationNode.h"
#import "MTStorage.h"
#import "MTGlobalVar.h"

@implementation MTGlobalVarMinusVariable

static NSString* myType = @"MTGlobalVarMinusVariable";


+(NSString*)DoGetMyType{
    return  myType;
}

-(NSString*)getImageName
{
    return @"minusCart.png";
}

-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTCart *new = [[MTGlobalVarMinusVariable alloc] initWithSubTrain:train];
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
    uint selectedVariable = self.options.choicePanel.numberSelectedVariableForSet;
    
    MTGlobalVar * globalVar = [MTGlobalVar getInstance];
    
    CGFloat valueForSet = [self checkRange:[globalVar getGlobalValueWithNumber:selectedVariable] - value];
    [globalVar setGlobalValueWithNumber:selectedVariable valueForSet: valueForSet];
    
    return true;
}

@end