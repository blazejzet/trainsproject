//
//  MTGameOverView.h
//  MagicTrains
//
//  Created by Blazej Zyglarski on 20.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTViewControllerGameOverScreenDelegate.h"
#import "MTAudioPlayer.h"
@interface MTGameOverView : UIImageView
@property (weak) id<MTViewControllerGameOverScreenDelegate> delegate;
- (instancetype)initWithWin:(BOOL)win;
- (instancetype)initWithWin:(BOOL)win andGhost:(NSString*)ghostName;
-(void)show;
@end
