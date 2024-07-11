//
//  MTWaitBallView.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 21.02.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import "MTWaitBallView.h"

@interface MTWaitBallView ()
@property UIImageView* waitball1;
@property UIImageView* waitball2;
@property BOOL isready;
@property UIImageView* waitball3;
@end
@implementation MTWaitBallView

@synthesize waitball1;
@synthesize waitball2;
@synthesize isready;
@synthesize waitball3;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0,0,90,30)];
    if (self) {
        waitball1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_bg_red"]];
        waitball1.frame= CGRectMake(5,5,20,20);
        waitball1.alpha=0.0;
        self.isready=false;
        [self addSubview:waitball1];
        
        waitball2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_bg_red"]];
        waitball2.frame= CGRectMake(35,5,20,20);
        waitball2.alpha=0.0;
        [self addSubview:waitball2];
        
        waitball3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_bg_red"]];
        waitball3.frame= CGRectMake(65,5,20,20);
        waitball3.alpha=0.0;
        [self addSubview:waitball3];
        waitball1.contentMode=UIViewContentModeScaleAspectFit;
                waitball2.contentMode=UIViewContentModeScaleAspectFit;
                waitball3.contentMode=UIViewContentModeScaleAspectFit;
        
    }
    return self;
}

-(void)animate{
    [self waiting];
}
-(void)disappear{
    [self ready];
}

-(void)waitAnim:(UIImageView*)wb{
    [UIView animateWithDuration:0.3 animations:^{
        wb.alpha=1.0;
    }];
    [self performSelector:@selector(ani:) withObject:wb afterDelay:0.3];
}
-(void)waiting{
   [self performSelector:@selector(waitAnim:) withObject:waitball1 afterDelay:0.0];
    [self performSelector:@selector(waitAnim:) withObject:waitball2 afterDelay:0.25];
   [self performSelector:@selector(waitAnim:) withObject:waitball3 afterDelay:0.5];
}
-(void)ani:(UIImageView*)wb{
    if(! self.isready){
    if(wb.alpha<0.5){
    }else{
        if(wb.alpha>0.8){
            [UIView animateWithDuration:0.3 animations:^{
                wb.alpha=0.6;
                wb.bounds=CGRectMake(0, 0, 20, 20);
            }];
            [self performSelector:@selector(ani:) withObject:wb afterDelay:0.5];
        }else {
            [UIView animateWithDuration:0.3 animations:^{
                wb.alpha=1.0;
                wb.bounds=CGRectMake(0, 0, 25, 25);
                       }];
            [self performSelector:@selector(ani:) withObject:wb afterDelay:0.5];
        }
        
    }
    }
}

-(void)ready{
    self.isready=true;
    [UIView animateWithDuration:1 animations:^{
        waitball1.alpha=0.0;
        waitball2.alpha=0.0;
        waitball3.alpha=0.0;
    } completion:^(BOOL c){
        if(waitball1.superview!=nil)[waitball1 removeFromSuperview];
        if(waitball2.superview!=nil)[waitball2 removeFromSuperview];
        if(waitball3.superview!=nil)[waitball3 removeFromSuperview];
        waitball1=nil;
        waitball2=nil;
        waitball3=nil;
        
    }];
}


@end
