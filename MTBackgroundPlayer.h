//
//  MTBackgroundPlayer.h
//  TrainsProject
//
//  Created by Blazej Zyglarski on 06.03.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MTTalkProtocol.h"

@interface MTBackgroundPlayer : NSObject<AVAudioPlayerDelegate>
@property (weak) id del;
@property (weak) id<MTTalkProtocol> sounddel;

-(void)stopFadingDown;
-(void)stopFadingDownX;
-(void)playNow;
-(void)playSilentNow;
-(void)silent;
-(void)normal;
-(BOOL)isPlaying;

-(id)initWithSound:(NSString*)sound;
-(id)initWithSound:(NSString*)sound andDelegate:(id<MTTalkProtocol>)d;
-(id)initWithLoop:(NSString*)loop;
-(id)initWithSound:(NSString*)sound andLoop:(NSString*)loop;
-(id)initWithSound:(NSString*)sound andLoop:(NSString*)loop alwaysbegins:(BOOL)ab;
@end
