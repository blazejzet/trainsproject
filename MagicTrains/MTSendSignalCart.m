//
//  MTSendMessageCart.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTExecutor.h"
#import "MTSendSignalCart.h"
#import "MTSignalNotificationNames.h"
#import "MTGhostRepresentationNode.h"

@implementation MTSendSignalCart
static NSString* myType = @"MTSendSignalCart";

-(id) initWithSubTrain:(MTSubTrain *)t
{
    self.isInstantCart = false;
    self.mySubTrain = t;
    self.optionsOpen = true;
    
    return self;
}

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode *)ghostRepNode
{
    self.signalColor = @"Purple";
    
#if DEBUG_NSLog
    ////NSLog(@"wysylam %@ wiadomosc z %@\n %@",self.signalColor,self,[NSNotificationCenter defaultCenter]);
#endif
    
    [[NSNotificationCenter defaultCenter] postNotificationName:N_Send_Purple_Signal object:self];
    [ghostRepNode sendSignal:@"PURPLE"];
    
    return true;
}
+(NSString*)DoGetMyType{
    return myType;
}
-(NSString*)getImageName
{
    return @"sendPurpleSignal.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    return [[MTSendSignalCart alloc] initWithSubTrain:train];
}
-(int)getCategory
{
    return MTCategoryControl;
}
@end