//
//  MTHelpPlayer.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 06.03.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import "MTHelpPlayer.h"
#import "MTWebApi.h"
#import "MTBackgroundPlayer.h"

@interface MTHelpPlayer()
@property NSArray * help;
@property MTBackgroundPlayer* player;
@end
@implementation MTHelpPlayer
@synthesize player;
@synthesize help;

-(id)init{
    self = [super init];
    self.help = @[
                       @"main-menu",    //0
                       @"help_1",    //1
                       @"help_2",    //2
                       @"help_3",    //3
                       @"help_4",    //4
                       
                       @"cars1",     //5             xx             ok
                       @"cars2",     //6             xx
                       @"cars3",     //7x            xx
                       @"cars4",     //8             xx
                       @"cars5",     //9             xx
                       @"cars6",     //10            xx
                       @"cars7",     //11            xx
                       
                       @"cloud-others",      //12
                       @"others-stars",      //13
                       @"desktop-empty",     //14    xx             ok
                       @"desktop-nonempty",  //15    xx             ok
                       
                       @"characters",        //16
                       @"left-more",         //17
                       @"loc_collision",     //18
                       @"main-scene",        //19
                       @"main-menu",         //20                   ok
                       
                       @"rating-stars",      //21
                       
                       @"set_costume",       //22
                       @"set_critter_costume", //23
                       @"set_exact_move",    //24
                       @"set_math",          //25
                       @"set_movement",      //26
                       @"set_pause",         //27
                       @"set_rotation",      //28
                       
                       @"simulation",        //29
                       @"tasks",             //30
                       @"welcome",           //31                   ok
                       
                       
                       
                       ];
    
    return self;
}
-(void)stopHelp{
    if(self.player!=nil){
        [(MTBackgroundPlayer*)self.player stopFadingDown];
    }
}
-(void)stopHelpX{
    if(self.player!=nil){
        [(MTBackgroundPlayer*)self.player stopFadingDownX];
    }
}
-(BOOL)isPlaying{
    if(self.player!=nil){
       return [(MTBackgroundPlayer*)self.player isPlaying];
    }
    return false;
}
-(void)playHelp:(int)x withDelegate:(id<MTTalkProtocol>)d{
    NSString * lang = [MTWebApi getLang];
    NSString * file = [NSString stringWithFormat:@"%@_%@",[self.help objectAtIndex:x],lang];
    if(self.player!=nil){
        [(MTBackgroundPlayer*)self.player stopFadingDown];
    }
    self.player = [[MTBackgroundPlayer alloc] initWithSound:file andDelegate:d];
    [self.player playNow];
}
-(void)playHelp:(int)x{
    [self playHelp:x withDelegate:nil];
}
@end
