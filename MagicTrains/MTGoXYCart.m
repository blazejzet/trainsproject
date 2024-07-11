//
//  MTGoRightCart.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 26.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTGoXYCart.h"
#import "MTGhostRepresentationNode.h"
#import "MTGoXYCartOptions.h"
#import "MTWheelPanel.h"
#import "MTGUI.h"

@implementation MTGoXYCart

static NSString* myType = @"MTGoXYCart";

-(id) initWithSubTrain: (MTSubTrain *) t
{
    if(self = [super initWithSubTrain: t])
    {
        self.options = [[MTGoXYCartOptions alloc] init];
        self.isInstantCart = true;
    }
    return self;
}

+(NSString*)DoGetMyType{
    return myType;
}
-(NSString*)getImageName
{
    return @"goXY.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTCart *new = [[MTGoXYCart alloc] initWithSubTrain:train];
    new.optionsOpen = false;
    return new;
}
-(int)getCategory
{
    return MTCategoryMove;
    
}

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    CGFloat x = [self.options.xPanel getMySelectedValueWithGhostRepNode:ghostRepNode];
    CGFloat y = [self.options.yPanel getMySelectedValueWithGhostRepNode:ghostRepNode];
    
         if (x < (- WIDTH + ghostRepNode.size.height) /2)
             x = (- WIDTH + ghostRepNode.size.height) /2;
    else if ( (WIDTH - ghostRepNode.size.height)  /2 < x)
             x = (  WIDTH - ghostRepNode.size.height) /2;
    
         if (y < (- HEIGHT + ghostRepNode.size.height) /2)
             y = (- HEIGHT + ghostRepNode.size.height) /2;
    else if ( (HEIGHT - ghostRepNode.size.height) /2 < y)
             y = (  HEIGHT - ghostRepNode.size.height) /2;
    
    ghostRepNode.position = CGPointMake(x, y);
    
    return true;
}

-(void)showOptions
{
    [self.options showOptions];
}

-(void) hideOptions
{
    [self.options hideOptions];
}

@end
