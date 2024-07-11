//
//  MTIfCart.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 14.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTIfCart.h"
#import "MTSubTrain.h"
#import "MTIfCartOptions.h"
#import "MTGlobalVar.h"
#import "MTGUI.h"

@implementation MTIfCart

-(id) initWithSubTrain: (MTSubTrain *) t
{
    if(self = [super initWithSubTrain: t])
    {
        self.options = [[MTIfCartOptions alloc] init];
        self.isInstantCart = true;
    }
    return self;
}

-(void) addCart:(MTCart*) cart
{
    [self.subTrain addCart:cart];
}
+(NSString*) DoGetMyType
{
    return  @"MTIfCart";
}
-(NSString*) getImageName
{
    return @"ifOn.png";
}
-(NSString*) getSecondImageName
{
    return @"ifOff.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTSubTrainCart * val = [[MTIfCart alloc] initWithSubTrain:train];
    val.optionsOpen = false;
    return val;
}

-(int) getCategory
{
    return MTCategoryLoop;
}

-(bool)If:(CGFloat)a LowerThan:(CGFloat)b
{
    return  a < b ;
}

-(bool)If:(CGFloat)a Equals:(CGFloat)b
{
    //if ()
    return  a == b ;
}

-(bool)If:(CGFloat)a NotEquals:(CGFloat)b
{
    //return ![self If: a Equals: b];
    return a != b;
}

-(bool)If:(CGFloat)a GreaterThan:(CGFloat)b
{
    return  a > b ;
}

-(bool)If:(CGFloat)a LowerOrEquals:(CGFloat)b
{
    // return  [self If: a LowerThan: b] || [self If: a Equals: b];
    return a <= b;
}

-(bool)If:(CGFloat)a GreaterOrEquals:(CGFloat)b
{
    //return  [self If: a GreaterThan: b] || [self If: a Equals: b];
    return a >= b;
}

-(bool) checkProperCondition :(MTGhostRepresentationNode*) ghostRepNode
{
    bool result = FALSE;
    CGFloat x = [self.options.xPanel getMySelectedValueWithGhostRepNode:ghostRepNode];
    CGFloat y = [self.options.yPanel getMySelectedValueWithGhostRepNode:ghostRepNode];
    
    NSString *condition = [self.options getCondition];
    if ([condition isEqualToString: @"<"])
        result = [self If:x LowerThan:y];
    else if ([condition  isEqualToString: @"<="])
        result = [self If:x LowerOrEquals:y];
    else if ([condition isEqualToString: @"="])
        result = [self   If:x Equals:y];
    else if ([condition  isEqualToString: @"=>"])
        result = [self If:x GreaterOrEquals:y];
    else if ([condition  isEqualToString: @">"])
        result = [self If:x GreaterThan:y];
    else if ([condition isEqualToString: @"<>"])
        result = [self If:x NotEquals:y];
    
    return result;
}
//TODO Przemek Zmienić komentarz
/**
 *
 * Jesli warunek jest spelniony metoda wywoluje przetwazanie podpociągu.
 * W przeciwnym wypadku wagonik zostaje wykonany i mozna przejsc dalej
 *
 *
 */
-(bool) runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    /// Sprawdzam warunek
    if (![self checkProperCondition:ghostRepNode])
    {
        // zmieniam iterator pociągu
        [self setTrainVariable:[NSNumber numberWithInteger:self.numberInCodeArray + self.lenghtOfLoopInCode + 1] WithName:@"main" FromGhostRepNode:ghostRepNode];
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