//
//  MTRecieveOrangeSignalLocomotiv.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 30.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTRecieveOrangeSignalLocomotiv.h"

#import "MTGhostRepresentationNode.h"

@implementation MTRecieveOrangeSignalLocomotiv
static NSString* myType = @"MTRecieveOrangeSignalLocomotiv";
-(NSString*)getImageName
{
    return @"recieveOrangeSignalLoco.png";
}
-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode *)ghostRepNode
{
    [ghostRepNode receiveSignal:@"ORANGE"];
    return true;
}
-(NSString*)getSignalColor
{
    return @"Orange";
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
    return [[MTRecieveOrangeSignalLocomotiv alloc] initWithSubTrain:train];
}
-(int)getCategory
{
    return MTCategoryLocomotive;
}
@end
