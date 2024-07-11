//
//  MTGyroscopeRightLocomotiv.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 28.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTGyroscopeRightLocomotiv.h"

@implementation MTGyroscopeRightLocomotiv
static NSString* myType = @"MTGyroscopeRightLocomotiv";
-(NSString*)getImageName
{
    return @"locomotiveGyroRight.png";
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
    return [[MTGyroscopeRightLocomotiv alloc] initWithSubTrain:train];
}
-(int)getCategory
{
    return MTCategoryLocomotive;
}
@end
