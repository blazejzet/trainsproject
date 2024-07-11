//
//  MTAudioPlayer.m
//  MagicTrains
//
//  Created by Blazej Zyglarski on 24.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTAudioPlayer.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "MTBackgroundPlayer.h"
#import "MTHelpPlayer.h"


@interface MTAudioPlayer()
@property BOOL nvd;
@property MTHelpPlayer* help;
@property NSString* next;
@property (weak) id<MTTalkProtocol> delegate;

@end

@implementation MTAudioPlayer

@synthesize help;
@synthesize next;

static NSMutableArray* ghostSounds;
static NSMutableDictionary* bgSounds;
static MTAudioPlayer* inst;
static BOOL sound=true;

+(MTAudioPlayer*)instanceMTAudioPlayer{
    if(inst){
        return inst;
    }else{
        inst = [[MTAudioPlayer alloc]init];
        return inst;
    }
}



-(void)playStartInfo{
    [inst playHelp:31 witDelegate:nil];
}
-(void)setNextViewDisplayed{
    self.nvd=true;
}


-(void)turnOffSound{
    sound=false;
    for (NSString* ckey in [bgSounds allKeys]){
            [(MTBackgroundPlayer*)[bgSounds objectForKey:ckey] silent];
    }
    
}
-(void)turnOnSound{
    sound=true;
    for (NSString* ckey in [bgSounds allKeys]){
        [(MTBackgroundPlayer*)[bgSounds objectForKey:ckey] normal];
    }
}

-(id)init{
    
    self=[super init];
    self.help = [[MTHelpPlayer alloc]init];
    bgSounds = [NSMutableDictionary dictionary];
    ghostSounds = [NSMutableArray array];
    
    
    [bgSounds setObject:[[MTBackgroundPlayer alloc] initWithSound:@"start_3" andLoop:@"bgloop" alwaysbegins:FALSE] forKey:@"background_start"];
    
    //[bgSounds setObject:[[MTBackgroundPlayer alloc]initWithLoop:@"NOWY_BG_CODE" ] forKey:@"background_code"];
    [bgSounds setObject:[[MTBackgroundPlayer alloc] initWithSound:@"P3bg" andLoop:@"P3bgloop"] forKey:@"background_code"];
    [bgSounds setObject:[[MTBackgroundPlayer alloc] initWithLoop:@"P3bgloop"] forKey:@"background_codeloop"];
    
    //[bgSounds setObject:[[MTBackgroundPlayer alloc]initWithLoop:@"bghelp" ] forKey:@"background_simulation"];
    [bgSounds setObject:[[MTBackgroundPlayer alloc] initWithSound:@"programming_in1" andLoop:@"programming_loop1"] forKey:@"background_simulation"];
    
    [bgSounds setObject:[[MTBackgroundPlayer alloc]initWithLoop:@"bgloop" ] forKey:@"background_startloop"];
    
    
    [bgSounds setObject:[[MTBackgroundPlayer alloc]initWithSound:@"happy" ] forKey:@"background_simulation_win"];
    
    [bgSounds setObject:[[MTBackgroundPlayer alloc]initWithSound:@"failcrowd" ] forKey:@"background_simulation_fail"];
    
    for(int i =1;i<=9;i++){
        [ghostSounds addObject:[[MTBackgroundPlayer alloc] initWithSound:[NSString stringWithFormat:@"D_%d",i]]];
    }
    
    return self;
}
-(void)playHelpwitDelegate:(id<MTTalkProtocol> )d{
    [self playHelp:1 witDelegate:d];
}
-(void)stopHelp{
    
    [help stopHelpX];
}
-(void)playHelp:(int)nr witDelegate:(id<MTTalkProtocol> )d{
    
    ////NSLog(@"playing help: [%d]",nr);
    [help playHelp:nr withDelegate:d];
   
    
}

-(BOOL)isHelpPlaying{
    BOOL b =  (self.help!=nil && [self.help isPlaying]
            );
    
    ////NSLog(@"isHelpPlayiong: %d",b);
    return b;
}
-(void)playGhost:(int)ghost{
    if (ghost<=9){
        [(MTBackgroundPlayer*)[ghostSounds objectAtIndex:ghost-1] playNow];
    }
}


-(void)playSilent:(NSString*)key{
    for (NSString* ckey in [bgSounds allKeys]){
        if (![key isEqual: ckey]){
            [(MTBackgroundPlayer*)[bgSounds objectForKey:ckey] stopFadingDown];
        }
    }
    [(MTBackgroundPlayer*)[bgSounds objectForKey:key] playSilentNow];
}
-(void)play:(NSString*)key{
    if(sound){
    for (NSString* ckey in [bgSounds allKeys]){
        if (![key isEqual: ckey]){
            [(MTBackgroundPlayer*)[bgSounds objectForKey:ckey] stopFadingDown];
        }
    }
    [(MTBackgroundPlayer*)[bgSounds objectForKey:key] playNow];
    [self stopHelp];
    }
}

-(void) cb{
    if(self.next!=nil){
        [self play:self.next];
        self.next=nil;
    }
}
-(void)play:(NSString*)key next:(NSString*)k2{
    self.next = k2;
    for (NSString* ckey in [bgSounds allKeys]){
        if (![key isEqual: ckey]){
            [(MTBackgroundPlayer*)[bgSounds objectForKey:ckey] stopFadingDown];
        }
    }
    MTBackgroundPlayer* b = (MTBackgroundPlayer*)[bgSounds objectForKey:key];
    b.del = self;
    [b playNow];
    [self stopHelp];
}

@end
