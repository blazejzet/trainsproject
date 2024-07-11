//
//  MTParamView.h
//  MagicTrains
//
//  Created by Blazej Zyglarski on 01.02.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTParamView : UIImageView
-(void)setV:(int)nv;
-(id)init:(int)type;
-(int)getV;
-(id)init:(int)type :(int)def;
-(void)setTarget:(id)s withSelector:(SEL) selector;
@end
