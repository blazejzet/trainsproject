//
//  MTEverytimeLocomotiv.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 30.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTAlwaysLocomotiv.h"

@implementation MTAlwaysLocomotiv

static NSString* myType = @"MTAlwaysLocomotiv";
-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode *)ghostRepNode
{
    //////NSLog(@"alwayslokom\n");
    return true;
}
+(NSString*)DoGetMyType{
    return myType;
}
-(NSString*)getImageName
{
    return @"locomotiveWhile.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    return [[MTAlwaysLocomotiv alloc] initWithSubTrain:train];
}
@end
