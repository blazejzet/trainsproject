//
//  MTGhostMenuView.h
//  MagicTrains
//
//  Created by Blazej Zyglarski on 03.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTGhost.h"
#import "MTGhostIconNodeProtocol.h"

@interface MTGhostMenuView : UIVisualEffectView
-(id)initWithGhost:(MTGhost*)g :(id<MTGhostIconNodeProtocol>)selectedIcon;
- (void)show;
- (void)showSmall;

-(BOOL)isShown;
-(void)removeFromParent;
@end
