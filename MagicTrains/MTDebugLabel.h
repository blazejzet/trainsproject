//
//  MTDebugLabel.h
//  MagicTrains
//
//  Created by Mateusz Wieczorkowski on 29.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTLabelNode.h"

@interface MTDebugLabel : MTLabelNode

//@property CGFloat *reference;
@property NSString *string;
@property NSTimer *timer;
//numer zmiennej globalnej
@property uint numberGlobalVar;

-(id) initWithPosition: (CGPoint)position numberGlobalVar: (uint)numberGlobalVar andString: (NSString*)string;
-(id) initXWithPosition: (CGPoint)position;
-(id) initYWithPosition: (CGPoint)position;
-(id) initHPWithPosition: (CGPoint)position;
-(id) initMASSWithPosition: (CGPoint)position;

-(void) refreshTextWithReference;
-(void) refreshTextXPosition;
-(void) refreshTextYPosition;
-(void) refreshTextHPPosition;
-(void) refreshTextMASSPosition;
-(void) stopRefreshText;

@end
