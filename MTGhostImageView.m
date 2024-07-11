//
//  MTGhostImageView.m
//  MagicTrains
//
//  Created by Blazej Zyglarski on 23.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTGhostImageView.h"

@implementation MTGhostImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)animate:(int)i{
    [UIView animateWithDuration:0.4 animations:^{
        self.transform=CGAffineTransformMakeRotation(10*i*3.14/180);
    }completion:^(BOOL Y){
        [self animate:i+(-1*2*i)];
    }];
}

@end
