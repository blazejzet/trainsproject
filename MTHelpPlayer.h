//
//  MTHelpPlayer.h
//  TrainsProject
//
//  Created by Blazej Zyglarski on 06.03.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MTTalkProtocol.h"

@interface MTHelpPlayer : NSObject
-(void)playHelp:(int)x withDelegate:(id<MTTalkProtocol>)d;
-(void)stopHelp;
-(void)stopHelpX;

-(BOOL)isPlaying;
@end
