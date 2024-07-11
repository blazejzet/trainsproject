//
//  MTGlobalVarMultiplyThrowVariable.h
//  MagicTrains
//
//  Created by Kamil Tomasiak on 28.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//
#import "MTSubTrain.h"
#import "MTGlobalVarAction.h"
@class MTGlobalVariableCartsOptions;
@class MTGhostRepresentationNode;

@interface MTGlobalVarMultiplyThrowVariable : MTGlobalVarAction

@property MTGlobalVariableCartsOptions * options;

@property bool optionsOpen;

-(BOOL)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode;
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train;
-(NSString*)getImageName;

+(NSString*)DoGetMyType;

@end