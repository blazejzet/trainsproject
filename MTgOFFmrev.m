//
//  MTgOFFmrev.m
//  TrainsProject
//
//  Created by Przemysław Porbadnik on 19.06.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import "MTgOFFmrev.h"
#import "MTTrain.h"
#import "MTSceneAreaNode.h"
#import "MTGUI.h"

@implementation MTgOFFmrev
static NSString* myType = @"MTgOFFmrev";

- (id) initWithSubTrain: (MTTrain *) t
{
    if(self = [super init])
    {
        self.optionsOpen = true;
        self.isInstantCart = true;
    }
    return self;
}

+(NSString*)DoGetMyType{
    return myType;
}

-(NSString*)getImageName
{
    return @"reverseGravityOFF.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    
    return [[MTgOFFmrev alloc] initWithSubTrain:train];
}

-(int)getCategory
{
    return MTCategoryGhost;
}

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    [ghostRepNode setReversedGravity:false];
    return true;
}
@end
