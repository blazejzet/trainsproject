//
//  MTNewMenuButtonBubble.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 19.06.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTNewMenuButtonBubble.h"

@implementation MTNewMenuButtonBubble

-(id)initWithPoint:(CGPoint)p{
    
    self = [super initWithImage:[UIImage imageNamed:@"menu_bg"]];
    self.center=p;
    self.bounds=CGRectMake(0, 0, 50, 50);
    self.alpha=0.5;
   
    return self;
    

    
}

-(void)goaway{
    if (self.alpha>0){
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha-=0.05;
        float x = (arc4random()%30)-15;
        float y = (arc4random()%30)-15;
        self.center= CGPointMake(self.center.x+x, self.center.y+y);
        self.bounds=CGRectMake(0,0,self.bounds.size.width*0.9,self.bounds.size.height*0.9);
    }completion:^(BOOL b){
        [self goaway];
    }];
    }
    else{
        [self removeFromSuperview];
    }
}

@end
