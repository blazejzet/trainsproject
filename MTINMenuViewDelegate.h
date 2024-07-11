//
//  MTINMenuViewDelegate.h
//  MagicTrains
//
//  Created by Blazej Zyglarski on 18.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTINMenuViewDelegate <NSObject>
-(void)exit;
-(void)help;
-(void)about;
@end
