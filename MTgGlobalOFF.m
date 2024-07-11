//
//  MTgON.m
//  MagicTrains
//
//  Created by Blazej Zyglarski on 17.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTgGlobalOFF.h"
#import "MTGhostRepresentationNode.h"
#import "MTSceneAreaNode.h"
#import "MTGUI.h"
#import "MTViewController.h"

@implementation MTgGlobalOFF


static NSString* myType = @"MTgGlobalOFF";

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
    return @"gglobalOFFCart.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    
    return [[MTgGlobalOFF alloc] initWithSubTrain:train];
}

-(int)getCategory
{
    return MTCategoryControl;
}

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    SKNode * scene = [[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
    scene.scene.physicsWorld.gravity=CGVectorMake(0, 0);

    
    SKFieldNode * skf = [MTViewController getInstance].skf;
    skf.direction = vector_float(vector3(0, 0, 0));
    
    return true;
}
@end
