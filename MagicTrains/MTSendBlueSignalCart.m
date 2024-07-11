//
//  MTSendBlueSignalCart.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 30.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTSendBlueSignalCart.h"
#import "MTSignalNotificationNames.h"

#import "MTGhostRepresentationNode.h"

@implementation MTSendBlueSignalCart
static NSString* myType = @"MTSendBlueSignalCart";

+(NSString*)DoGetMyType{
    return myType;
}
-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode *)ghostRepNode
{
    self.signalColor = @"Blue";

#if DEBUG_NSLog
    ////NSLog(@"wysylam %@ wiadomosc z %@\n %@",self.signalColor,self,[NSNotificationCenter defaultCenter]);
#endif
    
    [[NSNotificationCenter defaultCenter] postNotificationName:N_Send_Blue_Signal object: self];
    [ghostRepNode sendSignal:@"BLUE"];
    return true;
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    return [[MTSendBlueSignalCart alloc] initWithSubTrain:train];
    
}
-(NSString*)getImageName
{
    return @"sendBlueSignal.png";
}
@end