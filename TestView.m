//
//  TestView.m
//  MagicTrains
//
//  Created by Blazej Zyglarski on 28.02.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "TestView.h"

@interface TestView () {
    CGFloat startAngle;
    CGFloat endAngle;
}
@property NSTimer *m_timer;
@property UIImageView* face;
@property int radius;
@property UIColor * color;
@end

@implementation TestView
@synthesize g;
@synthesize color;
@synthesize face;
@synthesize radius;

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 140, 140)];
    if (self) {
        // Initialization code
        self.radius=42;
        self.color = [UIColor redColor];
        self.backgroundColor = [UIColor clearColor];
        startAngle = M_PI * 1.5;
        endAngle = startAngle + (M_PI * 2);
        
        self.userInteractionEnabled=YES;
        UISwipeGestureRecognizer * r = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        r.direction=UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:r];
        
        UITapGestureRecognizer * t = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(play)];
        //r.direction=UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:t];
        self.alpha=1;
        
        
    }
    return self;
}



- (id)initWH
{
    self = [super initWithFrame:CGRectMake(0, 0, 140, 140)];
    if (self) {
        // Initialization code
        self.radius=42;
        self.color = [UIColor redColor];
        self.backgroundColor = [UIColor clearColor];
        face = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"help_button"]];
        // Determine our start and stop angles for the arc (in radians)
        [self addSubview:face];
        face.center=CGPointMake(71, 71);
        startAngle = M_PI * 1.5;
        endAngle = startAngle + (M_PI * 2);
        
        self.userInteractionEnabled=YES;
        UISwipeGestureRecognizer * r = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        r.direction=UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:r];
        
        UITapGestureRecognizer * t = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(play)];
        //r.direction=UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:t];
        self.alpha=1;
        
        
    }
    return self;
}


- (id)initClear
{
    self = [super initWithFrame:CGRectMake(0, 0, 150, 150)];
    if (self) {
        // Initialization code
        self.radius=39;
        self.color = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        //face = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"help.png"]];
        // Determine our start and stop angles for the arc (in radians)
        //[self addSubview:face];
        //face.center=CGPointMake(71, 71);
        startAngle = M_PI * 1.5;
        endAngle = startAngle + (M_PI * 2);
        
        self.userInteractionEnabled=YES;
        UISwipeGestureRecognizer * r = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        r.direction=UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:r];
        
        UITapGestureRecognizer * t = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(play)];
        //r.direction=UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:t];
        self.alpha=0;
        
    }
    return self;
}
-(void)setRedColor{
    self.color = [UIColor orangeColor];
    
}
-(void)setGreenColor{
    self.color = [UIColor brownColor];
    
}
-(void)setGrayColor{
    self.color = [UIColor redColor];
    
}
-(void)hide{
    [self.m_timer invalidate];
    [UIView animateWithDuration:.3 animations:^{
        self.alpha=0;
    } completion:^(BOOL b){[self removeFromSuperview];}];
}
-(void)play{
    [self.m_timer invalidate];
    [UIView animateWithDuration:.1 animations:^{
        [face setBounds:CGRectMake(0, 0, 120, 120)];
        
    } completion:^(BOOL b)
     {
         [UIView animateWithDuration:.3 animations:^{
             self.alpha=0;
             [face setBounds:CGRectMake(0, 0, 70, 70)];
         } completion:^(BOOL b){[self removeFromSuperview];}];
     }];
    if(g)
    [self.g startHelp];
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
    // Create our arc, with the correct angles
    [bezierPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:radius
                      startAngle:startAngle
                        endAngle:(endAngle - startAngle) * (_percent / 100.0) + startAngle
                       clockwise:YES];
    
    // Set the display for the path, and stroke it
    bezierPath.lineWidth = 10;
    [self.color setStroke];
    [bezierPath stroke];
    
}

-(void)startCountdown{
   self.percent = 100;
    self.m_timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(decrementSpin) userInfo:nil repeats:YES];
}
-(void)show{
    self.percent=0;
    [face setBounds:CGRectMake(0, 0, 70, 70)];
    [UIView animateWithDuration:.3 animations:^{
        self.alpha=1;
        [face setBounds:CGRectMake(0, 0, 120, 120)];
        face.center=self.center;
        face.alpha=1;
    }];
    
}

-(void)updatePercent:(int)p{
    self.percent = p;
    
    [self setNeedsDisplay];

}

- (void)decrementSpin
{
    ////NSLog(@"DECR: %d",self.percent);
    // If we can decrement our percentage, do so, and redraw the view
    if (self.percent > 0) {
        [self updatePercent:self.percent - 1];
        
    }
    else {
        [self.m_timer invalidate];
        self.m_timer = nil;
        //if(g)
        [self play];
    }
}
@end