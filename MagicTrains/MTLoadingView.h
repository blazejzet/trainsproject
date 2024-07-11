//
//  MTLoadingView.h
//  TrainsProject
//
//  Created by Blazej Zyglarski on 21.02.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTWaitBallView.h"

@interface MTLoadingView : UIImageView
@property MTWaitBallView * bv;
-(void)clear;
@end
