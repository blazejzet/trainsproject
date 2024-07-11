//  MTPauseCart.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.

#import "MTPauseCart.h"
#import "MTPauseCart.h"
#import "MTGhostRepresentationNode.h"
#import "MTPauseCartOptions.h"
#import "MTGlobalVar.h"
#import "MTWheelPanel.h"
#import "MTGUI.h"

@interface MTPauseCart()
@property CGFloat value;
@end

@implementation MTPauseCart

static NSString* myType = @"MTPauseCart";

- (id) initWithSubTrain: (MTSubTrain *) t
{
    if(self = [super initWithSubTrain: t])
    {
        self.isInstantCart = false;
        self.options = [[MTPauseCartOptions alloc] init];
    }
    return self;
}

+(NSString*)DoGetMyType{
    return myType;
}

-(NSString*)getImageName
{
    return @"pause.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTCart *new = [[MTPauseCart alloc] initWithSubTrain:train];
    new.optionsOpen = false;
    return new;
}

-(int)getCategory
{
    return MTCategoryControl;
}

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    NSInteger i = [(NSNumber *)[self getVariableWithName:@"i" Class:[NSNumber class] FromGhostRepNode:ghostRepNode] integerValue];
    
    if (i == 0)
    {
        self.value = [self.options.timePanel getMySelectedValueWithGhostRepNode:ghostRepNode];
    }
        
    if (self.value < 0)
    {
        self.value = 0;
        
        return true;
    }

    i++;
    
    if (i * FRAME_TIME <= self.value)
    {
        [self setVariable:[NSNumber numberWithInteger:i] WithName:@"i" FromGhostRepNode:ghostRepNode];
        return false;
    }
    else
    {
        i = 0;
        [self setVariable:[NSNumber numberWithInteger:i] WithName:@"i" FromGhostRepNode:ghostRepNode];
        return true;
    }
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
