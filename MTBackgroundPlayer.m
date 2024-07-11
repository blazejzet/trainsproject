//
//  MTBackgroundPlayer.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 06.03.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import "MTBackgroundPlayer.h"
#import "MTWebApi.h"

@interface MTBackgroundPlayer()
@property AVAudioPlayer* mainPlayer;
@property AVAudioPlayer* loopPlayer;
@property BOOL ab;
@property double level;
@property double prev;
@property NSTimer* timer;


@end

@implementation MTBackgroundPlayer
@synthesize mainPlayer;
@synthesize loopPlayer;
@synthesize ab;
@synthesize del;
@synthesize sounddel;
@synthesize timer;

@synthesize level;
@synthesize prev;

-(id)initWithSound:(NSString*)sound andLoop:(NSString*)loop alwaysbegins:(BOOL)ab{
    self.ab=ab;
    self.mainPlayer = [[AVAudioPlayer alloc]
                       initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]  pathForResource:sound ofType:@"aif"]] error:nil];
    [self.mainPlayer prepareToPlay];
    self.mainPlayer.numberOfLoops=0;
    self.mainPlayer.delegate=self;
    
    self.loopPlayer = [[AVAudioPlayer alloc]
                       initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]  pathForResource:loop ofType:@"aif"]] error:nil];
    [self.loopPlayer prepareToPlay];
    self.loopPlayer.numberOfLoops=-1;
    //self.loopPlayer.delegate=self;
    
    return self;
}
-(id)initWithSound:(NSString*)sound andLoop:(NSString*)loop{
    self.mainPlayer = [[AVAudioPlayer alloc]
                       initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]  pathForResource:sound ofType:@"aif"]] error:nil];
    [self.mainPlayer prepareToPlay];
    self.mainPlayer.numberOfLoops=0;
    self.mainPlayer.delegate=self;
    
    self.loopPlayer = [[AVAudioPlayer alloc]
                       initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]  pathForResource:loop ofType:@"aif"]] error:nil];
    [self.loopPlayer prepareToPlay];
    self.loopPlayer.numberOfLoops=-1;
    //self.loopPlayer.delegate=self;
    
    return self;
    
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
        if(self.loopPlayer != nil){
            if(![self.loopPlayer isPlaying]){
                [self.loopPlayer play];
            }
        }
        [self.mainPlayer stop];
        if (self.del != nil){
            if([self.del respondsToSelector:@selector(cb)])
            [self.del performSelector:@selector(cb) withObject:nil];
        }
    if (!self.ab){
        self.mainPlayer = nil;
    }
    if(self.sounddel!=nil){
        [self.timer invalidate];
        self.timer = nil;
        [self.sounddel endTalk];
    }
    
    
}

-(id)initWithLoop:(NSString*)loop{
    self.loopPlayer = [[AVAudioPlayer alloc]
                       initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]  pathForResource:loop ofType:@"aif"]] error:nil];
    [self.loopPlayer prepareToPlay];
    self.loopPlayer.numberOfLoops=-1;
    return self;
}

-(id)initWithSound:(NSString*)sound andDelegate:(id<MTTalkProtocol>)d{
    NSString * path = [[NSBundle mainBundle]  pathForResource:sound ofType:@"aif"];
    if(path!=nil){
    self.ab = true;
    self.sounddel=d;
    self.mainPlayer = [[AVAudioPlayer alloc]
                       initWithContentsOfURL:[NSURL fileURLWithPath:path ] error:nil];
    [self.mainPlayer prepareToPlay];
    self.mainPlayer.delegate=self;
    self.mainPlayer.numberOfLoops=0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1/11 target:self selector:@selector(checkAudioLevels:) userInfo:nil repeats:YES];
    }
    return self;
                       

}





- (void)checkAudioLevels:(id)sender {
    if (![self.mainPlayer isPlaying]) {
        return;
    }
    self.mainPlayer.meteringEnabled = YES;
    [self.mainPlayer updateMeters];
    //[self.audioLevelsView setNumberOfChannels:self.audioPlayer.numberOfChannels];
    if(self.sounddel!=nil){
        for (int c=0; c<self.mainPlayer.numberOfChannels; c++) {
            float level = [self.mainPlayer averagePowerForChannel:c];
            if(ABS(level-prev)>2.0){
                if(self.sounddel){
                    [self.sounddel update:level];
                }
                prev=level;
                
            }
        }
        // 0    LOUD
        // -160 SILENT
        //[self.audioLevelsView setLevel:level forChannel:c];
    }
}


-(id)initWithSound:(NSString*)sound{
    self.ab = true;
    self.mainPlayer = [[AVAudioPlayer alloc]
            initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]  pathForResource:sound ofType:@"aif"]] error:nil];
    [self.mainPlayer prepareToPlay];
    //self.mainPlayer.delegate=self;
    self.mainPlayer.numberOfLoops=0;
    return self;
}
-(void)stopFadingDownX{
    [self doVolumeFade];
}
-(void)stopFadingDown{
    [self doVolumeFade];
    if(self.sounddel!=nil){
        [self.timer invalidate];
        self.timer = nil;
        [self.sounddel endTalk];
    }
}

-(void)playNow{
    if(![MTWebApi getSchool]){
        
    if(self.mainPlayer != nil){
        //[self.mainPlayer prepareToPlay];
        self.mainPlayer.delegate=self;
        [self.mainPlayer play];
    }else{
        if(self.loopPlayer!=nil){
            [self.loopPlayer play];
        }
    }
    }
}


-(void)silent{
    if(self.mainPlayer != nil){
        self.mainPlayer.volume=0.0;
    }
    if(self.loopPlayer != nil){
        self.loopPlayer.volume=0.0;
    }
}

-(void)normal{
    if(self.mainPlayer != nil){
        self.mainPlayer.volume=1.0;
    }
    if(self.loopPlayer != nil){
        self.loopPlayer.volume=1.0;
    }
}
-(BOOL)isPlaying{

    return (self.mainPlayer != nil && self.mainPlayer.isPlaying) || (self.loopPlayer != nil && self.loopPlayer.isPlaying);
}
-(void)playSilentNow{
    if(![MTWebApi getSchool]){
    if(self.mainPlayer != nil){
        [self.mainPlayer play];
        self.mainPlayer.volume=0.5;
    }else{
        if(self.loopPlayer!=nil){
            [self.loopPlayer play];
            self.loopPlayer.volume=0.5;
        }
    }
    }
}

-(void)doVolumeFade:(AVAudioPlayer*)player{
    if(player.isPlaying){
      if (player.volume > 0.05) {
     player.volume = player.volume / 2;
          [self performSelector:@selector(doVolumeFade:) withObject:player afterDelay:0.1];
     } else {
         [player stop];
         player.currentTime = 0;
         [player prepareToPlay];
         player.volume = 1.0;
     }
    }
}

-(void)doVolumeFade{
    if(self.mainPlayer != nil){[self doVolumeFade:self.mainPlayer];}
    if(self.loopPlayer != nil){[self doVolumeFade:self.loopPlayer];}

}
@end
