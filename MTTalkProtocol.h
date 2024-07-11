//
//  MTTalkProtocol.h
//  MagicTrains
//
//  Created by Blazej Zyglarski on 26.02.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTTalkProtocol <NSObject>
-(void)update:(CGFloat)v;
-(void)endTalk;
@end
