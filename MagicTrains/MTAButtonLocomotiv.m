//
//  MTAButtonLocomotiv.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 28.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTAButtonLocomotiv.h"

@implementation MTAButtonLocomotiv
static NSString* myType = @"MTAButtonLocomotiv";

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode *)ghostRepNode
{
    //////NSLog(@"lokomotywa wcisniecia przycisku A. \n");
    return true;
}
+(NSString*)DoGetMyType{
    return myType;
}

-(NSString*)getMyType{
    return myType;
}
-(NSString*)getImageName
{
    return @"locomotiveAJoystick.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    return [[MTAButtonLocomotiv alloc] initWithSubTrain:train];
}
-(int)getCategory
{
    return MTCategoryLocomotive;
}
@end
