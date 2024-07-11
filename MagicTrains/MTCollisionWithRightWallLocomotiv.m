//
//  MTCollisionWithWallLocomotiv.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 13.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCollisionWithRightWallLocomotiv.h"

@implementation MTCollisionWithRightWallLocomotiv

static NSString* myType = @"MTCollisionWithRightWallLocomotiv";

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode *)ghostRepNode
{
    return true;
}
+(NSString*)DoGetMyType{
    return myType;
}
-(NSString*)getImageName
{
    return @"locomotiveCollisionWithRightWall.png";
}

-(NSString*) getMyType
{
    return myType;
}

-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    return [[MTCollisionWithRightWallLocomotiv alloc] initWithSubTrain:train];
}
-(int)getCategory
{
    return MTCategoryLocomotive;
}
@end
