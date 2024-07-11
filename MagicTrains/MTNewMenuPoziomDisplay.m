//
//  MTNewMenuPoziomDisplay.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 19.06.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTNewMenuPoziomDisplay.h"
#import "MTButtonsView.h"
#import "MTNewMenuButton.h"
#import "MTWaitBallView.h"
#import "MTGUI.h"

@interface MTNewMenuPoziomDisplay ()
@property UIImageView * bg;
@property MTWaitBallView * waitball1;

@end

@implementation MTNewMenuPoziomDisplay
@synthesize delegate;
@synthesize przyciski;
@synthesize menuDisplay;
@synthesize subtype;
@synthesize bg;
@synthesize waiting_flag;
@synthesize waitball1;
@synthesize enabled;

@synthesize xbl;

-(void)prepare:(CGPoint)p{
    

    self.alpha=0;
    UIImageView * dings = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_dings.png"]];
    bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_selection.png"]];
    menuDisplay = [[UIView alloc]initWithFrame:CGRectMake(0, dings.frame.size.height, WIDTH,  HEIGHT-dings.frame.size.height)];
    
    [menuDisplay setUserInteractionEnabled:YES];
    [self setUserInteractionEnabled:YES];
    
    [self addSubview:dings];
    [self addSubview:bg];
    [self addSubview:menuDisplay];
    
    bg.frame= CGRectMake(0, dings.frame.size.height, WIDTH,  HEIGHT-dings.frame.size.height);
    dings.center = CGPointMake(p.x, dings.frame.size.height/2);

    waitball1 = [[MTWaitBallView alloc]init];
    [bg addSubview:waitball1];
    waitball1.center=CGPointMake(200, 80);
    //[waitball1 animate];

}
-(id)init{
    self = [super initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.enabled=true;
        self.waiting_flag=false;
    return self;
}
-(id)initWithPoint:(CGPoint)p{
    self = [super initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    
    if (self){
            self.waiting_flag=false;
        [self prepare:p];
        self.enabled=true;
        
    }
    
    return self;
}

-(void)appear{
    ////NSLog(@"APPEAR");

    [self.superview bringSubviewToFront:self];
     self.frame=CGRectMake(self.frame.origin.x, 50, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=1;
        self.frame=CGRectMake(self.frame.origin.x, 120, self.frame.size.width, self.frame.size.height);
    }];
}
-(void)show:(NSString*)type{
    
    //////NSLog(@".>>>>>>> >>> > > > > %@",type);
    
    [self clear];
    
    [self performSelector:@selector(appear) withObject:nil afterDelay:0.3];
    
    
    //elementy menu glownego
    [self showElements];
    //wybor elementow podmenu
    
}
-(void)clear{
    for (UIView * v in menuDisplay.subviews){
        [UIView animateWithDuration:0.1 animations:^{
            v.alpha=0;
        } completion:^(BOOL B){
            [v removeFromSuperview];
        }];
    }
}
-(void)hide{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha=0;
    } completion:^(BOOL f){
        //NSLog(@"Hiding finished: %d",f);
        //[self removeFromSuperview];
    }];
}

-(BOOL)waiting{
    
    [self.waitball1 animate];
    BOOL t = self.waiting_flag;
    self.waiting_flag=true;
    //NSLog(@"ustawiam flagę CZEKANIA na true.");
    return t;
}
-(void)ani{
    
}

-(void)ready{
    self.waiting_flag=false;
    [self.waitball1 disappear];
    //NSLog(@"ustawiam flagę CZEKANIA na false.");
}

-(void)showElements{
    
}
-(void)refresh{
    ////NSLog(@"Refresh is not implemented in this kind of menu %@", self);
}
-(void)showUploadedElements{
    ////NSLog(@"xxx");
}
-(void)showCloudElements{
    
}
-(void)displayElements{
    
    float i = -((przyciski.count-1)*1.0/2.0);
    for(MTNewMenuButton* b in przyciski){
        [self.menuDisplay addSubview:b];
        b.p=self.p;
        CGPoint p  = CGPointMake(self.menuDisplay.frame.size.width/2+b.frame.size.width*1.5*5/przyciski.count*i, 50);
        b.center = p;
        
        //MTNewMenuPoziomDisplay * mtpoziom = [[MTNewMenuPoziomDisplay alloc]initWithPoint:p];
        MTNewMenuPoziomDisplay * mtpoziom = [[NSClassFromString([NSString stringWithFormat:@"MTNewMenuPoziomDisplay_%@",b.type]) alloc] init];
        
        [mtpoziom prepare:p];
        mtpoziom.subtype=b.subtype;

        [self.menuDisplay addSubview:mtpoziom];
        [self.menuDisplay setUserInteractionEnabled:YES];
        [mtpoziom setUserInteractionEnabled:YES];
        mtpoziom.p=self.p;
        mtpoziom.delegate= self.delegate;
        b.refDisplay= mtpoziom;
        
        
        b.othersCollection = przyciski;
        float atime = 0.1 * (arc4random()%10)+1.0;
        [b performSelector:@selector(show) withObject:nil afterDelay:atime];
        i++;
    }

}



-(void)setEnabled{
    self.enabled=true;
    for(MTNewMenuButton* b in przyciski){
        [b setEnabled];
    }
    if(self.xbl!=nil){
        [xbl setEnabled];
    }
}
-(void)setDisabled{
    self.enabled=false;
    for(MTNewMenuButton* b in przyciski){
        [b setDisabled];
    }
    if(self.xbl!=nil){
        [xbl setDisabled];
    }
}



@end
