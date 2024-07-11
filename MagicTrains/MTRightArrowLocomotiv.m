//
//  MTRightArrowLocomotiv.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 28.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTRightArrowLocomotiv.h"

@implementation MTRightArrowLocomotiv
static NSString* myType = @"MTRightArrowLocomotiv";

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
    return @"locomotiveRightJoystick.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    return [[MTRightArrowLocomotiv alloc] initWithSubTrain:train];
}
-(int)getCategory
{
    return MTCategoryLocomotive;
}
@end
