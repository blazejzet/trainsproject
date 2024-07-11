//
//  MTGyroscopeLocomotiv.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 28.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTGyroscopeLeftLocomotiv.h"

@implementation MTGyroscopeLeftLocomotiv
static NSString* myType = @"MTGyroscopeLeftLocomotiv";
-(NSString*)getImageName
{
    return @"locomotiveGyroLeft.png";
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
    return [[MTGyroscopeLeftLocomotiv alloc] initWithSubTrain:train];
}
-(int)getCategory
{
    return MTCategoryLocomotive;
}
@end
