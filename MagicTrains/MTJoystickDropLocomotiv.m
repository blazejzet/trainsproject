//
//  MTJoystickDropLocomotiv.m
//  MagicTrains
//
//  Created by Blazej Zyglarski on 17.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTJoystickDropLocomotiv.h"
#import "MTGhostRepresentationNode.h"
@implementation MTJoystickDropLocomotiv
@synthesize force;
static NSString* myType = @"MTJoystickDropLocomotiv";

-(bool)runMeWithGhostRepNode:( MTGhostRepresentationNode*)ghostRepNode
{
    //TODO - nie wiem czzemu przy FALSE reaguje z opóźnieniem.
    if(ghostRepNode.affectByJoystick==true){
        force=[ghostRepNode.myFlags getJoystickDropForce];
        CGVector i = CGVectorMake(-force.x*100, -force.y*100);
        [ghostRepNode.physicsBody applyImpulse:i];
        [ghostRepNode.myFlags unSetJoystickDropForce];
    }else{
        [ghostRepNode.myFlags unSetJoystickDropForce];
        [ghostRepNode.myFlags unSetJoystickDropFlag];
        
    }
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
    return @"locomotiveDropJoystick.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    return [[MTJoystickDropLocomotiv alloc] initWithSubTrain:train];
}
-(int)getCategory
{
    return MTCategoryLocomotive;
}

@end
