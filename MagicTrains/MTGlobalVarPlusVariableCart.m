//
//  MTGlobalVarPlusVariable.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 28.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTGlobalVarPlusVariableCart.h"
#import "MTGlobalVariableCartsOptions.h"
#import "MTGhostRepresentationNode.h"
#import "MTStorage.h"
#import "MTGlobalVar.h"

@implementation MTGlobalVarPlusVariableCart

static NSString* myType = @"MTGlobalVarPlusVariableCart";

+(NSString*)DoGetMyType{
    return  myType;
}

-(NSString*)getImageName
{
    return @"plusCart.png";
}

-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTCart *new = [[MTGlobalVarPlusVariableCart alloc] initWithSubTrain:train];
    new.optionsOpen = false;
    return new;
}

-(BOOL)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    CGFloat value = [self getSelectedValue: ghostRepNode];
    
    //numer zaznaczonej zmiennej
    uint selectedVariable = self.options.choicePanel.numberSelectedVariableForSet;
    
    MTGlobalVar * globalVar = [MTGlobalVar getInstance];
    
    CGFloat valueForSet = [self checkRange:[globalVar getGlobalValueWithNumber:selectedVariable] + value];
    [globalVar setGlobalValueWithNumber:selectedVariable valueForSet: valueForSet];

    return true;
}

@end
