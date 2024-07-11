//
//  MTNewMenuButtobBlackBubble.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 21.06.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTNewMenuButtobBlackBubble.h"

@implementation MTNewMenuButtobBlackBubble
-(id)initWithPoint:(CGPoint)p{
    
    self = [super initWithImage:[UIImage imageNamed:@"menu_bg_black.png"]];
    self.center=p;
    self.bounds=CGRectMake(0, 0, 50, 50);
    self.alpha=0.5;
    return self;
    
    
}
@end
