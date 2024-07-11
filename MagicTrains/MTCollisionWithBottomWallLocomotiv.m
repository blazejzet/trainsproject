//
//  MTCollisionWithBottomWallLocomotiv.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 30.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCollisionWithBottomWallLocomotiv.h"

@implementation MTCollisionWithBottomWallLocomotiv
static NSString* myType = @"MTCollisionWithBottomWallLocomotiv";

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode *)ghostRepNode
{
    
#if DEBUG_NSLog
    ////NSLog(@"lokomotywa zderzenia duszka z dolna sciana\n");
#endif
    
    return true;
}
+(NSString*)DoGetMyType{
    return myType;
}
-(NSString*)getImageName
{
    return @"locomotiveCollisionWithBottomWall.png";
}

-(NSString*) getMyType
{
    return myType;
}

-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    return [[MTCollisionWithBottomWallLocomotiv alloc] initWithSubTrain:train];
}
-(int)getCategory
{
    return MTCategoryLocomotive;
}
@end
