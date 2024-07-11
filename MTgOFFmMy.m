//
//  MTgON.m
//  MagicTrains
//
//  Created by Blazej Zyglarski on 17.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTgOFFmMy.h"
#import "MTGhostRepresentationNode.h"
#import "MTSceneAreaNode.h"
#import "MTGUI.h"

@implementation MTgOFFmMy


static NSString* myType = @"MTgOFFmMy";

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
    return @"gmOFFMy.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    
    return [[MTgOFFmMy alloc] initWithSubTrain:train];
}

-(int)getCategory
{
    return MTCategoryGhost;
}

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    [ghostRepNode setGravitationMy:false];
    return true;
}
@end
