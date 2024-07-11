//
//  MTRecieveSignalLocomotiv.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTRecieveSignalLocomotiv.h"
#import "MTGhostRepresentationNode.h"

@implementation MTRecieveSignalLocomotiv
static NSString* myType = @"MTRecieveSignalLocomotiv";
-(NSString*)getImageName
{
    return @"recieveSignalLoco.png";
}
-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode *)ghostRepNode
{
    [ghostRepNode receiveSignal:@"PURPLE"];
    return true;
}
-(NSString*)getSignalColor
{
    return @"Purple";
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
    return [[MTRecieveSignalLocomotiv alloc] initWithSubTrain:train];
}
-(int)getCategory
{
    return MTCategoryLocomotive;
}
///-----------------------------------------------------
///    Serializacja
///-----------------------------------------------------
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    return self;
}
@end
