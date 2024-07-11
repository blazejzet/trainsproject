//
//  MTAudioPlayer.h
//  MagicTrains
//
//  Created by Blazej Zyglarski on 24.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MTTalkProtocol.h"

@interface MTAudioPlayer : NSObject <AVAudioPlayerDelegate>

-(void)playHelp:(int)nr witDelegate:(id<MTTalkProtocol> )d;
-(void)stopHelp;
-(BOOL)isHelpPlaying;
-(void)playHelpwitDelegate:(id<MTTalkProtocol> )d;
-(void)playGhost:(int)ghost;

-(void)play:(NSString*)key;
-(void)play:(NSString*)key next:(NSString*)k2;

-(void)playSilent:(NSString*)key;

+(MTAudioPlayer*)instanceMTAudioPlayer;

-(void)turnOffSound;
-(void)turnOnSound;

-(void)playStartInfo;
@end
