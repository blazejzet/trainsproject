//
//  MTRecieveBlueSignalLocomotiv.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 30.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTRecieveBlueSignalLocomotiv.h"

#import "MTGhostRepresentationNode.h"

@implementation MTRecieveBlueSignalLocomotiv
static NSString* myType = @"MTRecieveBlueSignalLocomotiv";
-(NSString*)getImageName
{
    return @"recieveBlueSignalLoco.png";
}
-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode *)ghostRepNode
{
    [ghostRepNode receiveSignal:@"BLUE"];
    return true;
}
-(NSString*)getSignalColor
{
    return @"Blue";
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
    return [[MTRecieveBlueSignalLocomotiv alloc] initWithSubTrain:train];
}
-(int)getCategory
{
    return MTCategoryLocomotive;
}
@end
