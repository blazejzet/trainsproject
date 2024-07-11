//
//  MTNewMenuPoziomDisplay_contest.h
//  TrainsProject
//
//  Created by Blazej Zyglarski on 21.06.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTNewMenuPoziomDisplay.h"

@interface MTNewMenuPoziomDisplay_contest : MTNewMenuPoziomDisplay
-(void)download:(NSDictionary*)tdg withCallback:(void(^)(void))cb;
@end
