//
//  TestView.h
//  MagicTrains
//
//  Created by Blazej Zyglarski on 28.02.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTAutoHelpProtocol.h"

@interface TestView : UIView
@property int percent;
@property (weak)id<MTAutoHelpProtocol> g;

-(void)startCountdown;
-(void)show;
-(void)hide;
- (id)initClear;
- (id)initWH;

-(void)updatePercent:(int)p;
-(void)setRedColor;

-(void)setGreenColor;
-(void)setGrayColor;
@end
