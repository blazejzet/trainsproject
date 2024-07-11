//
//  MTForLoopCart.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 13.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCart.h"
#import "MTSubTrain.h"
#import "MTForLoopCart.h"
#import "MTSubTrainCart.h"
#import "MTForLoopCartOptions.h"
#import "MTGlobalVar.h"
#import "MTWheelPanel.h"
#import "MTGUI.h"

@interface MTForLoopCart()
@property int loopValue;
@end

@interface MTForLoopCart ()
@property int i;
@end
@implementation MTForLoopCart

-(id) initWithSubTrain: (MTSubTrain *) t
{
    if(self = [super initWithSubTrain: t])
    {
        CGFloat a =0;
        self.value = &a;
        self.i = 0;
        self.isInstantCart = true;
        self.options = [[MTForLoopCartOptions alloc] init];
    }
    return self;
}
-(void)addCart:(MTCart*) cart
{
    [[self subTrain] addCart:cart];
}
+(NSString*)DoGetMyType
{
    return  @"MTForLoopCart";
}
-(NSString*)getImageName
{
    return @"forOn.png";
}
-(NSString*)getSecondImageName
{
    return @"forOff.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTForLoopCart * val = [MTForLoopCart alloc];
    val = [val initWithSubTrain:train];
    val.optionsOpen = false;
    
    return val;
}
-(int)getCategory
{
    return MTCategoryLoop;
}
-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
     NSInteger i = [(NSNumber *)[self getVariableWithName:@"fori" Class:[NSNumber class] FromGhostRepNode:ghostRepNode] integerValue];
    
    //tylko za pierwszym razem odczytuje wartosc
    if (i == 0)
    {
        self.loopValue = [self.options.loopValuePanel getMySelectedValueWithGhostRepNode:ghostRepNode];
        
        if (self.loopValue < 0)
        {
            self.loopValue = 0;
        }
    }

#if DEBUG_NSLog
    ////NSLog(@"odpalam %@ (nr %li) przy i = %li",self,(long)self.numberInCodeArray,(long)i);
#endif
    
    if (i < self.loopValue)
    {
        i++;
        [self setVariable:[NSNumber  numberWithInteger:i] WithName:@"fori" FromGhostRepNode:ghostRepNode];
        
    }else
    {
        i = 0;
        [self setVariable:[NSNumber numberWithInteger:i] WithName:@"fori" FromGhostRepNode:ghostRepNode];
        [self setTrainVariable:[NSNumber numberWithInteger:self.lenghtOfLoopInCode + self.numberInCodeArray + 1] WithName:@"main" FromGhostRepNode:ghostRepNode];
    }
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
