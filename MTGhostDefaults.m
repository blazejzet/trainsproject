//
//  MTGhostDefaults.m
//  MagicTrains
//
//  Created by Blazej Zyglarski on 01.02.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTGhostDefaults.h"

@implementation MTGhostDefaults
@synthesize isSimple;
@synthesize defaultMass;

-(id)initWithMass:(int)m andSimple:(BOOL)y{
    self = [super init];
    self.isSimple=y;
    self.defaultMass=m;
    return self;
}

-(double)getScaledMass{
    return [self getScaledMass:self.defaultMass];
}

-(double)getScaledMass:(int)m{
    return pow(2,m);
}

+(MTGhostDefaults*) defaults:(int) m :(BOOL)y{
    MTGhostDefaults* mm = [[MTGhostDefaults alloc]initWithMass:m andSimple:y];
    return mm;
}

+(MTGhostDefaults*) defaults{
    MTGhostDefaults* mm = [[MTGhostDefaults alloc]initWithMass:1 andSimple:false];
    return mm;
}

@end
