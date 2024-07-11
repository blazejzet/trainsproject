//
//  MTAutoHelpProtocol.h
//  MagicTrains
//
//  Created by Blazej Zyglarski on 28.02.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTAutoHelpProtocol <NSObject>
-(void)startHelp;
-(void)resetHelpTimerCounter;
@end
