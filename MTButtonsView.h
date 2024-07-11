//
//  MTButtonsView.h
//  MagicTrains
//
//  Created by Blazej Zyglarski on 06.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTMainMenuProtocol.h"
#import "MTNewMenuUptadePositionProtocol.h"
@interface MTButtonsView : UIView
@property id<MTMainMenuProtocol> delegate;
@property (weak) id<MTNewMenuUptadePositionProtocol> p;
@property NSMutableArray* a;
@property NSMutableArray* btt;
-(void)show;
-(void)tap:(UIGestureRecognizer*)g;
-(void)hide;
@end
