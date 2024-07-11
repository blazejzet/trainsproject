//
//  MTHpIncreaseValueCart.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 27.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTHpIncreaseValueCart.h"
#import "MTGhostRepresentationNode.h"

@implementation MTHpIncreaseValueCart

static NSString* myType = @"MTHpIncreaseValueCart";

-(id) initWithSubTrain: (MTTrain *) t
{
    if(self = [super init])
    {
        self.optionsOpen = true;
        self.isInstantCart = true;
    }
    return self;
}


+(NSString*)DoGetMyType{
    return  myType;
}

-(NSString*)getImageName
{
    return @"hartPlusCart.png";
}

-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    return [[MTHpIncreaseValueCart alloc] initWithSubTrain:train];
}

-(int)getCategory
{
    return MTCategoryGhost;
}

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    if (ghostRepNode.hp != 10)
    {
        [ghostRepNode increaseHP];
        
    }
    return true;
}


@end
