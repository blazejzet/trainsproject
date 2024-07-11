//
//  MTHelpView.h
//  MagicTrains
//
//  Created by Blazej Zyglarski on 20.02.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//



#import <SpriteKit/SpriteKit.h>
#import "MTTalkProtocol.h"
#import "MTAutoHelpProtocol.h"

@interface MTObjectiveView : SKView<MTTalkProtocol>
@property (weak) id<MTAutoHelpProtocol> delegate;
-(void) showMainScreenHelp;
+ (SKAction *)jumpWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint height:(CGFloat)height ;

+ (int) helpScreen;
+ (void) setHelpScreen:(int)val;
+ (void) revert;
- (void) setImage:(NSString*)name;
@end
