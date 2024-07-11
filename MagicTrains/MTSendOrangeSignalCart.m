//
//  MTSendOrangeSignalCart.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 30.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTSendOrangeSignalCart.h"
#import "MTSignalNotificationNames.h"

#import "MTGhostRepresentationNode.h"

@implementation MTSendOrangeSignalCart
static NSString* myType = @"MTSendOrangeSignalCart";

+(NSString*)DoGetMyType{
    return myType;
}
-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode *)ghostRepNode
{
    self.signalColor = @"Orange";

#if DEBUG_NSLog
    ////NSLog(@"wysylam %@ wiadomosc z %@\n %@",self.signalColor,self,[NSNotificationCenter defaultCenter]);
#endif
    
    [[NSNotificationCenter defaultCenter] postNotificationName:N_Send_Orange_Signal object: self];
    [ghostRepNode sendSignal:@"ORANGE"];
    
    return true;
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    return [[MTSendOrangeSignalCart alloc] initWithSubTrain:train];
    
}
-(NSString*)getImageName
{
    return @"sendOrangeSignal.png";
}
@end