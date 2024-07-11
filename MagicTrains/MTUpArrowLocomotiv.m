//
//  MTUpArrowLocomotiv.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 28.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTUpArrowLocomotiv.h"

@implementation MTUpArrowLocomotiv
static NSString* myType = @"MTUpArrowLocomotiv";

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode *)ghostRepNode
{
    return true;
}
+(NSString*)DoGetMyType{
    return myType;
}

-(NSString*) getMyType{
    return myType;
}

-(NSString*)getImageName
{
    return @"locomotiveTopJoystick.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    return [[MTUpArrowLocomotiv alloc] initWithSubTrain:train];
}
-(int)getCategory
{
    return MTCategoryLocomotive;
}
@end
