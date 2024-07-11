//
//  MTOfflineData.m
//  TrainsProject
//
//  Created by Dawid Skrzypczyński on 04.10.2015.
//  Copyright © 2015 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTOfflineData.h"


@implementation MTOfflineData

static MTOfflineData *myInstanceMOD;


+(void)clear
{
    myInstanceMOD = nil;
}

-(id) init {
    if(!myInstanceMOD) {
        self = [super init];
        return self;
    }
    
    return myInstanceMOD;
}

+(id) getInstance {
    if(!myInstanceMOD) {
        myInstanceMOD = [[MTOfflineData alloc] init];
    }
    
    return myInstanceMOD;
}

@end