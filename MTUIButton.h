//
//  MTUIButton.h
//  MagicTrains
//
//  Created by Blazej Zyglarski on 14.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTNewMenuUptadePositionProtocol.h"
@interface MTUIButton : UIButton
@property NSString* stag;
@property (weak) id<MTNewMenuUptadePositionProtocol> p;

@end
