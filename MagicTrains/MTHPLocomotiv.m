//
//  MTGyroscopeRightLocomotiv.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 28.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTHPLocomotiv.h"

@implementation MTHPLocomotiv
static NSString* myType = @"MTHPLocomotiv";
-(NSString*)getImageName
{
    return @"locomotivHP.png";
}
-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode *)ghostRepNode
{
    return true;
}
+(NSString*)DoGetMyType{
    return myType;
}

-(NSString*) getMyType
{
    return myType;
}

-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    return [[MTHPLocomotiv alloc] initWithSubTrain:train];
}
-(int)getCategory
{
    return MTCategoryLocomotive;
}
@end
