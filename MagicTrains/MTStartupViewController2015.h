//
//  MTStartupViewController.h
//  MagicTrains
//
//  Created by Blazej Zyglarski on 05.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTMainMenuProtocol.h"
#import "MTAutoHelpProtocol.h"
#import "MTNewMenuPoziomDisplay.h"
#import "MTNewMenuUptadePositionProtocol.h"

@interface MTStartupViewController2015 : UIViewController<MTNewMenuUptadePositionProtocol,MTMainMenuProtocol,MTAutoHelpProtocol,NSURLConnectionDownloadDelegate, NSURLConnectionDelegate>

@end
