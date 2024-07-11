//
//  MTgON.m
//  MagicTrains
//
//  Created by Blazej Zyglarski on 17.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTgGlobalON.h"
#import "MTGhostRepresentationNode.h"
#import "MTSceneAreaNode.h"
#import "MTGUI.h"
#import "MTViewController.h"

@implementation MTgGlobalON


static NSString* myType = @"MTgGlobalON";

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
    return @"gglobalONCart.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    
    return [[MTgGlobalON alloc] initWithSubTrain:train];
}

-(int)getCategory
{
    return MTCategoryControl;
}

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    SKNode * scene = [[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
    scene.scene.physicsWorld.gravity=CGVectorMake(0, -5);
    SKFieldNode * skf = [MTViewController getInstance].skf;
    skf.direction = vector_float(vector3(0, 10, 0));
    
    return true;
}
@end
