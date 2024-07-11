//
//  MTBButtonLocomotiv.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 28.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTBButtonLocomotiv.h"

@implementation MTBButtonLocomotiv
static NSString* myType = @"MTBButtonLocomotiv";

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode *)ghostRepNode
{
    
#if DEBUG_NSLog
    ////NSLog(@"lokomotywa wcisniecia przycisku B\n");
#endif
    
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
    return @"locomotiveBJoystick.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    return [[MTBButtonLocomotiv alloc] initWithSubTrain:train];
}
-(int)getCategory
{
    return MTCategoryLocomotive;
}
@end
