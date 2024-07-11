//
//  MTStarView.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 06.10.2015.
//  Copyright © 2015 UMK. All rights reserved.
//

#import "MTStarView.h"
@interface MTStarView()
@property (atomic, strong) void (^scb)(int);

@end

@implementation MTStarView
@synthesize scb;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithMyStars:(int)my worldStars:(int)world starCallback:(void (^)(int))scb_{
    self= [super initWithFrame:CGRectMake(0,0,150,100)];
    if(self) {
        [self setUserInteractionEnabled:YES];
        scb=scb_;
        if(my>0 || scb_==nil){
        for (int i =0; i<5;i++){
            if (i<world){
                UIImageView * star = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"star_red"]];
                [self addSubview:star];
                star.center=CGPointMake(30*i, 50);
            }else{
                UIImageView * star = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"star_white"]];
                [self addSubview:star];
                star.center=CGPointMake(30*i, 50);
                
            }
        }}else{
            for (int i =0; i<5;i++){
                if (i<world){
                    UIImageView * star = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"star_red"]];
                    [self addSubview:star];
                    star.alpha = 0.5;
                    star.center=CGPointMake(30*i, 50);
                }else{
                    UIImageView * star = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"star_white"]];
                    [self addSubview:star];
                    star.alpha = 0.5;
                    star.center=CGPointMake(30*i, 50);
                    
                }
                UIImageView * starempty = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"star_empty"]];
                [self addSubview:starempty];
                starempty.tag=i+1;
                starempty.alpha = 1.0;
                starempty.center=CGPointMake(30*i, 50);
                [starempty addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
                 [starempty setUserInteractionEnabled:YES];
            }
        }
    }
    return self;
    
}

-(void)tap:(UITapGestureRecognizer*)tapge{
    int i = tapge.view.tag;
    if (scb != nil){
        for(UIView * v in self.subviews){
            if (v.tag>0 && v.tag<=i){
                ((UIImageView*)v).image = [UIImage imageNamed:@"star_red"];
            }
            if (v.tag>0 && v.tag>i){
                ((UIImageView*)v).image = [UIImage imageNamed:@"star_empty"];
            }
        }
        scb(i);
    }
}
@end
