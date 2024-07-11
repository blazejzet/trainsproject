//
//  MTLoadingView.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 21.02.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import "MTLoadingView.h"
#import "MTGUI.h"

@implementation MTLoadingView
@synthesize bv;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)init
{
    self = [super initWithImage:[UIImage imageNamed:@"loading"]];
    if (self) {
        bv = [[MTWaitBallView alloc]init];
        [bv animate];
        self.contentMode=UIViewContentModeCenter;
        [self addSubview:bv];
        bv.center = CGPointMake(WIDTH/2, HEIGHT/2);
    }
    return self;
}
-(void)clear{
    //[bv disappear];
    //[bv removeFromSuperview];
    [self removeFromSuperview];
}
@end
