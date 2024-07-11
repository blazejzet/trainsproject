//
//  MTGlobalVarDivideThrowVariable.h
//  MagicTrains
//
//  Created by Kamil Tomasiak on 28.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//
#import "MTGlobalVarAction.h"
#import "MTSubTrain.h"

@class MTGlobalVariableCartsOptions;
@class MTGhostRepresentationNode;
@interface MTGlobalVarDivideThrowVariable : MTGlobalVarAction

@property MTGlobalVariableCartsOptions * options;

@property bool optionsOpen;

-(BOOL)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode;
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train;
-(NSString*)getImageName;

+(NSString*)DoGetMyType;

@end