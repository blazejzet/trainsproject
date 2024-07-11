//
//  MTLeftArrowLocomotiv.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 27.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTLeftArrowLocomotiv.h"

@implementation MTLeftArrowLocomotiv
static NSString* myType = @"MTLeftArrowLocomotiv";

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
    return @"locomotiveLeftJoystick.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    return [[MTLeftArrowLocomotiv alloc] initWithSubTrain:train];
}
-(int)getCategory
{
    return MTCategoryLocomotive;
}
@end
