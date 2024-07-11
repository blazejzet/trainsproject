//
//  MTHelpView.h
//  MagicTrains
//
//  Created by Blazej Zyglarski on 20.02.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//
#define hs_help_1    1
#define hs_help_2    2
#define hs_help_3    3
#define hs_help_4    4

#define hs_cars1     5
#define hs_cars2     6
#define hs_cars3     7
#define hs_cars4     8
#define hs_cars5     9
#define hs_cars6     10
#define hs_cars7     11

#define hs_cloud_others      12
#define hs_others_stars      13
#define hs_desktop_empty     14
#define hs_desktop_notempty  15

#define hs_characters        16
#define hs_left_more         17
#define hs_loc_collision     18
#define hs_main_scene        19
#define hs_main_menu         20

#define hs_rating_stars      21

#define hs_set_costume       22
#define hs_set_critter_costume 23
#define hs_set_exact_move    24
#define hs_set_math          25
#define hs_set_movement      26
#define hs_set_pause         27
#define hs_set_rotation      28

#define hs_simulation        29
#define hs_tasks             30
#define hs_welcome           31





#import <SpriteKit/SpriteKit.h>
#import "MTTalkProtocol.h"
#import "MTAutoHelpProtocol.h"

@interface MTHelpView : SKView<MTTalkProtocol>
@property (weak) id<MTAutoHelpProtocol> delegate;

-(void) showMainScreenHelp;
+ (SKAction *)jumpWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint height:(CGFloat)height ;

+ (BOOL) isHelpAllowed;
+ (void) setHelpAllowed:(BOOL)val;
+ (int) helpScreen;
+ (void) setHelpScreen:(int)val;
+ (void) revert;

+ (void) showInstantHelp:(NSString*)name icon:(NSString*)icon scenePosition:(CGPoint)p node:(SKSpriteNode *)s;

+ (void) revertHelpAllowed;
@end
