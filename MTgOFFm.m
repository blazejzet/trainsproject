//
//  MTgON.m
//  MagicTrains
//
//  Created by Blazej Zyglarski on 17.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTgOFFm.h"
#import "MTGhostRepresentationNode.h"
#import "MTSceneAreaNode.h"
#import "MTGUI.h"

@implementation MTgOFFm


static NSString* myType = @"MTgOFFm";

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
    return @"gmOFF.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    
    return [[MTgOFFm alloc] initWithSubTrain:train];
}

-(int)getCategory
{
    return MTCategoryGhost;
}

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    [ghostRepNode setGravitation:false];
    return true;
}
@end
