//
//  MTINMenuView.h
//  MagicTrains
//
//  Created by Blazej Zyglarski on 18.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTINMenuViewDelegate.h"

@interface MTINMenuView : UIView
@property (weak) id<MTINMenuViewDelegate> delegate;
@property bool isMenuShowed;
-(void)hideMenuAnimated:(BOOL)animated;
-(void)hideFullMenuAnimated:(BOOL)animated;
-(id)initWithScene:(NSDictionary*)scene;
@end
