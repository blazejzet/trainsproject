//
//  MTgONmrev.m
//  TrainsProject
//
//  Created by Przemysław Porbadnik on 19.06.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import "MTgONmrev.h"

@implementation MTgONmrev

static NSString* myType = @"MTgONmrev";

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
    return @"reverseGravityON.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    
    return [[MTgONmrev alloc] initWithSubTrain:train];
}

-(int)getCategory
{
    return MTCategoryGhost;
}

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    [ghostRepNode setReversedGravity:true];
    return true;
}

@end
