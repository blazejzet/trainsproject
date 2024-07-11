//
//  MTHpReduceValueCart.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 27.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTHpReduceValueCart.h"
#import "MTGhostRepresentationNode.h"

@implementation MTHpReduceValueCart

static NSString* myType = @"MTHpReduceValueCart";

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
    return @"hartMinusCart.png";
}

-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    return [[MTHpReduceValueCart alloc] initWithSubTrain:train];
}

-(int)getCategory
{
    return MTCategoryGhost;
}

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    if (ghostRepNode.hp > 0)
    {
        [ghostRepNode decreaseHP];
    }
    return true;
}

@end
