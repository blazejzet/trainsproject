//
//  MTgON.m
//  MagicTrains
//
//  Created by Blazej Zyglarski on 17.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTgONmMy.h"
#import "MTGhostRepresentationNode.h"
#import "MTSceneAreaNode.h"
#import "MTGUI.h"

@implementation MTgONmMy


static NSString* myType = @"MTgONmMy";

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
    return @"gmONMy.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    
    return [[MTgONmMy alloc] initWithSubTrain:train];
}

-(int)getCategory
{
    return MTCategoryGhost;
}

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    [ghostRepNode setGravitationMy:true];
    return true;
}
@end
