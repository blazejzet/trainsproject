//
//  MTgON.m
//  MagicTrains
//
//  Created by Blazej Zyglarski on 17.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTendDraw.h"
#import "MTGhostRepresentationNode.h"
#import "MTSceneAreaNode.h"
#import "MTGUI.h"

@implementation MTendDraw


static NSString* myType = @"MTendDraw";

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
    return @"endDraw";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    
    return [[MTendDraw alloc] initWithSubTrain:train];
}

-(int)getCategory
{
    return MTCategoryMove;
}

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
   // [ghostRepNode startDrawing: true];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"DrawingEnded" object:self];
    return true;
}
@end
