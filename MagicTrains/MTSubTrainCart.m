//
//  MTSubTrainCart.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 04.04.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTSubTrainCart.h"
#import "MTSubTrain.h"
#import "MTLeftRotationCart.h"
#import "MTGoLeftCart.h"
#import "MTGoRightCart.h"
#import "MTPauseCart.h"
#import "MTGhostRepresentationNode.h"
#import "MTExecutor.h"
@implementation MTSubTrainCart


-(id) initWithSubTrain: (MTSubTrain *) t
{
    if(self = [super initWithSubTrain:t])
    {
        self.isMySubTrainVisible = false;
        self.subTrain = [[MTSubTrain alloc] initWithTrain:t.myTrain];
        self.subTrain.myParentSubTrain = t;
        self.subTrain.myCartInParent = self;
    }
    return self;
}
-(void)addCart:(MTCart*) cart
{
    [self.subTrain addCart:cart];
}
+(NSString*)DoGetMyType
{
    return  @"MTSubTrainCart";
}
-(NSString*)getImageName
{
    return @"PAP@2x.png";
}
-(NSString*)getSecondImageName
{
    return @"PAP@2x.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    MTSubTrainCart * val = [[MTSubTrainCart alloc] initWithSubTrain:train];
    val.optionsOpen = false;
    return val;
}
-(int)getCategory
{
    return MTCategoryLoop;
}
-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
   // while ([MTExecutor getInstance].simulationStarted)
    [self.subTrain runMeWithGhostRep:ghostRepNode];
    return false;
}
///-----------------------------------------------------
///    Serializacja
///-----------------------------------------------------
-(void)encodeWithCoder:(NSCoder *)encoder
 {
     [super encodeWithCoder: encoder];
     [encoder encodeObject:[self subTrain]   forKey:@"subTrain"];
 }
 
 -(id)initWithCoder:(NSCoder *)decoder
 {
     self = [super initWithCoder:decoder];
     [self setSubTrain:  [decoder decodeObjectForKey:@"subTrain"]];
     [[self subTrain] setMyCartInParent:self];
     
     return self;
 }
@end
