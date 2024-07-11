//
//  MTGhostDefaults.h
//  MagicTrains
//
//  Created by Blazej Zyglarski on 01.02.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTGhostDefaults : NSObject
@property int defaultMass;
@property BOOL isSimple;

-(double)getScaledMass:(int)m;
-(double)getScaledMass;
+(MTGhostDefaults*) defaults:(int) m :(BOOL)y;
+(MTGhostDefaults*) defaults;

@end
