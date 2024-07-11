//
//  MTCollisionWithTopWallLocomotiv.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 30.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCollisionWithTopWallLocomotiv.h"

@implementation MTCollisionWithTopWallLocomotiv
static NSString* myType = @"MTCollisionWithTopWallLocomotiv";

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode *)ghostRepNode
{
    return true;
}
+(NSString*)DoGetMyType{
    return myType;
}
-(NSString*)getImageName
{
    return @"locomotiveCollisionWithTopWall.png";
}

-(NSString*) getMyType
{
    return myType;
}

-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    return [[MTCollisionWithTopWallLocomotiv alloc] initWithSubTrain:train];
}
-(int)getCategory
{
    return MTCategoryLocomotive;
}
@end
