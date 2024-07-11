//
//  MTButtonsDelegate.h
//  TrainsProject
//
//  Created by Blazej Zyglarski on 09.10.2015.
//  Copyright © 2015 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTButtonsDelegate <NSObject>
@optional
-(void)download:(NSDictionary*)tdg withCallback:(void(^)(void))cb;
-(void)download:(NSDictionary*)tdg;
-(void)upload:(NSDictionary*)tdg;
-(void)delete:(NSDictionary*)tdg;
-(void)play:(NSDictionary*)tdg;
-(void)share:(NSDictionary*)tdg;


@end
