//
//  MTINMenuView.m
//  MagicTrains
//
//  Created by Blazej Zyglarski on 18.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTINMenuView.h"
#import "MTHelpView.h"
#import "MTGUI.h"
#import <QuartzCore/QuartzCore.h>

#import "MTViewController.h"
#import "MTGhostsBarNode.h"
#import "MTAvatarView.h"
#import "MTWebApi.h"
#import "MTStarView.h"
#import "MTAudioPlayer.h"
#import "MTGhostMenuView.h"
#import "MTSceneAreaNode.h"
#import "MTArchiver.h"

@interface MTINMenuView ()
@property UISwitch * s;
@property NSDictionary* scene;
@property MTStarView*sv;
@property UIImageView* ss;
@property UIImageView* sp;
@property UIImageView* save;
@end

@implementation MTINMenuView
@synthesize delegate;
@synthesize sp;
@synthesize ss;
@synthesize sv;
@synthesize save;

CGFloat oldLocation;

@synthesize s,isMenuShowed;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
/*
-(instancetype)init{
    self = [super initWithFrame:CGRectMake(0,0,200,768)];{
        
        UIImageView *bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"inmenu"]];
        [self addSubview:bg];
        bg.center=CGPointMake(bg.center.x-20, bg.center.y);
        
        [self setUserInteractionEnabled:YES];
        //[self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openclose)]];
        UISwipeGestureRecognizer* g1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(openclose)];
        UISwipeGestureRecognizer* g2 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(openclose)] ;
        [g1 setDirection:UISwipeGestureRecognizerDirectionLeft];
        [g2 setDirection:UISwipeGestureRecognizerDirectionRight];
        
        [self addGestureRecognizer:g1
         ];
        [self addGestureRecognizer:g2
         ];
        
        UIImageView * x= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LIN.png"]];
        //x setFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
        [x setFrame:CGRectMake(180,0,1,768)];
        [self addSubview:x];
        
        UIImageView * z= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MENUBG.png"]];
        [z setFrame:CGRectMake(0,0,180,768)];
        [self addSubview:z];
        
        
        UIImageView * y= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"toggle2.png"]];
        //y.contentScaleFactor=0.5;
        [y setFrame:CGRectMake(180, 0, y.frame.size.width, y.frame.size.height)];
        //y.center=CGPointMake(188,y.frame.size.height/2);
        [self addSubview:y];
        
        
        UIImageView * u= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logoinmenu"]];
        u.contentScaleFactor=0.5;
        u.center = CGPointMake(90, 90);
        //[u setFrame:CGRectMake(40, 40, u.frame.size.width/3, u.frame.size.height/3)];
        //u.center=CGPointMake(188,768/2);
        [self addSubview:u];
        
        u= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BACK_BTT.png"]];
        u.contentScaleFactor=0.5;
        [u setFrame:CGRectMake(40, 40, u.frame.size.width/2, u.frame.size.height/2)];
        u.center=CGPointMake(90,200);
        [self addSubview:u];
        [u addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exit)]];
        [u setUserInteractionEnabled:YES];
        
        u= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"help.png"]];
        u.contentScaleFactor=0.5;
        //[u setFrame:CGRectMake(70, 70, u.frame.size.width/2, u.frame.size.height/2)];
        u.center=CGPointMake(90,600);
        [self addSubview:u];
        [u addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(help)]];
        [u setUserInteractionEnabled:YES];
        
        self.s = [[UISwitch alloc ]initWithFrame:CGRectMake(30, 30, 130, 30)];
        s.center = CGPointMake(u.center.x, u.center.y+100);
        [s setOnTintColor:[UIColor redColor]];
        [s.layer setBorderColor:[[UIColor redColor] CGColor]];
        [self addSubview:s];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL v = [defaults boolForKey:@"autohelp"];
        //[s setSelected:!v];
        s.on=!v;
        [self saveAutoHelpState];
        
        [s addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveAutoHelpState)]];
        [s addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
        
        //[defaults setObject:firstName forKey:@"firstName"];
        
        
        
        u= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ABOUT_BTT.png"]];
        u.contentScaleFactor=0.5;
        [u setFrame:CGRectMake(40, 40, u.frame.size.width/2, u.frame.size.height/2)];
        u.center=CGPointMake(90,270);
        [self addSubview:u];x
    }
    return self;
}*/


-(void)soundoff{
    sp.alpha=0;
    ss.alpha=1;
     [sp setUserInteractionEnabled:NO];
     [ss setUserInteractionEnabled:YES];
    [ss.superview bringSubviewToFront:ss];
    [[MTAudioPlayer instanceMTAudioPlayer]turnOffSound];
}
-(void)soundon{
    sp.alpha=1;
    ss.alpha=0;
    [sp setUserInteractionEnabled:YES];
    [ss setUserInteractionEnabled:NO];
    [sp.superview bringSubviewToFront:sp];
      [[MTAudioPlayer instanceMTAudioPlayer] turnOnSound];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if([touches.anyObject locationInView:self.superview].x>WIDTH-100)return;
    
    oldLocation  =[touches.anyObject locationInView:self.superview].y;
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if([touches.anyObject locationInView:self.superview].x>WIDTH-100)return;
    
    CGFloat c = [touches.anyObject locationInView:self.superview].y-oldLocation;
    oldLocation  =[touches.anyObject locationInView:self.superview].y;
    if (self.center.y+c<145){
        self.center=CGPointMake(self.center.x, self.center.y+c);
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if([touches.anyObject locationInView:self.superview].x>WIDTH-100)return;
    
    if (self.center.y>0){
        if (! self.isMenuShowed || self.center.y<135){
            [self showMenuAnimated:YES];
        }else{
            [self exit];
        }
    }else if(self.center.y<0){
        [self hideMenuAnimated:YES];
    }
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideMenuAnimated:YES];
}
-(id)initWithScene:(NSDictionary*)scene{
    self = [super initWithFrame:CGRectMake(0,0,WIDTH,200)];
    if(self){
        
        _scene = scene;
        
        
        //self.backgroundColor= [UIColor redColor];
        UIImageView *bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"inmenu_h"]];
        [self addSubview:bg];
        bg.center=CGPointMake(WIDTH/2, 75);
        
        UIImageView *bgback = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_bar"]];
        [self addSubview:bgback];
        bgback.center=CGPointMake(WIDTH/2, -15);
        
        [self setUserInteractionEnabled:YES];
        
        
        
        UIImageView * y= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"toggleh"]];
        //y.contentScaleFactor=0.5;
        [y setFrame:CGRectMake(0, 170, WIDTH, y.frame.size.height)];
        y.contentMode = UIViewContentModeCenter;
        //y.center=CGPointMake(188,y.frame.size.height/2);
        [self addSubview:y];
        
        
        UIImageView * u= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logoinmenu"]];
        u.contentScaleFactor=0.5;
        u.center = CGPointMake(90, 90);
        //[u setFrame:CGRectMake(40, 40, u.frame.size.width/3, u.frame.size.height/3)];
        //u.center=CGPointMake(188,768/2);
        [self addSubview:u];
        
        u= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_button"]];
        //[u setFrame:CGRectMake(40, 40, u.frame.size.width/2, u.frame.size.height/2)];
        u.center=CGPointMake(200,90);
        [self addSubview:u];
        [u addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exit)]];
        [u setUserInteractionEnabled:YES];
        
        u= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"help_BG"]];
        u.center=CGPointMake(WIDTH-100,90);
        [self addSubview:u];
        [u addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(help)]];
        [u setUserInteractionEnabled:YES];
        
        u= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"help_button"]];
        //u.contentScaleFactor=0.5;
        //[u setFrame:CGRectMake(70, 70, u.frame.size.width/2, u.frame.size.height/2)];
        u.center=CGPointMake(WIDTH-140,90);
        if(![MTWebApi getSchool]){
        [self addSubview:u];
        
        [u addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(help)]];
        }
        [u setUserInteractionEnabled:YES];
        
        
        
        if([scene[@"file"] hasPrefix:@"task://"])
        {
        UIImageView*xu= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"task_button"]];
        //u.contentScaleFactor=0.5;
        //[u setFrame:CGRectMake(70, 70, u.frame.size.width/2, u.frame.size.height/2)];
        xu.center=CGPointMake(WIDTH-210,90);
        [self addSubview:xu];
        [xu addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(objective)]];
        [xu setUserInteractionEnabled:YES];
        }
        self.ss= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sound_off"]];
        ss.center=CGPointMake(280,90);
        [self addSubview:ss];
        [ss addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(soundon)]];
        [ss setUserInteractionEnabled:NO];

        
        self.sp= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sound_play"]];
        sp.center=CGPointMake(280,90);
        [self addSubview:sp];
        [sp addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(soundoff)]];
        [sp setUserInteractionEnabled:YES];
        
        
        
        self.save= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"save"]];
        save.center=CGPointMake(360,90);
        [self addSubview:save];
        [save addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(saveStage)]];
        [save setUserInteractionEnabled:YES];
        
        
        
        
        MTAvatarView* avatar= [[MTAvatarView alloc]initWithData:_scene[@"avatar"]];
        [self addSubview:avatar];
        avatar.center = CGPointMake(WIDTH/2, 90);
        
        self.s = [[UISwitch alloc ]initWithFrame:CGRectMake(30, 30, 130, 30)];
        s.center = CGPointMake(u.center.x+60, u.center.y);
        [s setOnTintColor:[UIColor redColor]];
        [s.layer setBorderColor:[[UIColor redColor] CGColor]];
        [self addSubview:s];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL v = [defaults boolForKey:@"autohelp"];
        //[s setSelected:!v];
        s.on=!v;
        [self saveAutoHelpState];
        
        [s addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveAutoHelpState)]];
        [s addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
        
        //[defaults setObject:firstName forKey:@"firstName"];
        // TUTAJ TRZEBA SPRAWDZIĆ, CZY WOGÓLE MOŻNA TO CO TU JEST OCENIAĆ (czyli w przypadku odpalenia czegokolwiek z piaskownicy,nie!. Oceniane są tylko już wysłane rzeczy, czyli takie, które są w cloudzie. Nie robimy powiązania z rzeczami będącymi wciąż w piaskownicy. Bo można trochę to zmienić i potem wysłać ponownie już jako nową rzecz (nie aktualizujemy, tak ustaliliśmy)
        
        if ([(NSString *)(scene[@"file"]) containsString:@"sandbox"]
            || [(NSString *)(scene[@"file"]) containsString:@"task"]
            || [(NSString *)(scene[@"file"]) containsString:@"learn"]){
            //NOSTARS!
        }else{
        [[[MTWebApi alloc] init] checkStars:self.scene completion:^(BOOL can,int my, int world){
            if (can && my==0){
                //możesz oceniać
               self.sv= [[MTStarView alloc]initWithMyStars:my worldStars:world starCallback:^(int ocena){
                  [self.sv removeFromSuperview];
                   
                   [[[MTWebApi alloc] init] setScene:self.scene Stars:ocena];
                   
                   
                   self.sv=[[MTStarView alloc]initWithMyStars:my worldStars:world starCallback:nil];
                   [self addSubview:self.sv];
                   self.sv.center = CGPointMake(WIDTH/2+100, 90);
               }];
                [self addSubview:self.sv];
                self.sv.center = CGPointMake(WIDTH/2+100, 90);
            }else if(can && my>0){
                self.sv=[[MTStarView alloc]initWithMyStars:my worldStars:world starCallback:nil];
                [self addSubview:self.sv];
                self.sv.center = CGPointMake(WIDTH/2+100, 90);
                //możesz, ale już oceniłeś
            }else {
                //nie możesz oceniać
                self.sv=[[MTStarView alloc]initWithMyStars:my worldStars:world starCallback:nil];
                [self addSubview:self.sv];
                self.sv.center = CGPointMake(WIDTH/2+100, 90);
            }
        }];
        }
        
        
        
    }
    return self;
}

- (void)changeSwitch:(id)sender{
    [self saveAutoHelpState];
}

-(void)saveStage{
    SKNode *root = [[[MTViewController getInstance] mainScene] childNodeWithName:@"MTRoot"];
    MTSceneAreaNode *scene = (MTSceneAreaNode *) [root childNodeWithName:@"MTSceneAreaNode"];
    [scene saveRepresentationNodes];
    [[MTArchiver getInstance]encodeStorage];
}
-(void)saveAutoHelpState{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:!s.on forKey:@"autohelp"];
    [defaults synchronize];
    //BOOL v = [defaults objectForKey:@"autohelp"];
    //[s setSelected:v];
}
-(void)exit{ 
    if(delegate) {
        
        for(UIView * u in self.superview.subviews){
            if ([u isKindOfClass:[MTGhostMenuView class]]){
                [(MTGhostMenuView*)u removeFromParent];
            }
        }
        
        
        [delegate exit];
        
    }
}

-(void)openclose{
   
}
/*
-(void)hideMenuAnimated:(BOOL)animated{
    void (^b)(void);
    b = ^{
        self.center=CGPointMake(-80,768/2);
    };
    
    if (animated){
        [ UIView animateWithDuration:0.1 animations:b];
    }else{
        b();
    }
}


-(void)hideFullMenuAnimated:(BOOL)animated{
    void (^b)(void);
    b = ^{
        self.center=CGPointMake(-80,768/2);
        self.alpha=0;
    };
    
    if (animated){
        [ UIView animateWithDuration:0.1 animations:b];
    }else{
        b();
    }
}


-(void)showMenuAnimated:(BOOL)animated{
    void (^b)(void);
    self.alpha=0.0;
    b = ^{
        self.center=CGPointMake(100,768/2);
        self.alpha=1;
    };
    
    if (animated){
        [ UIView animateWithDuration:0.1 animations:b];
    }else{
        b();
    }
}*/


-(void)hideMenuAnimated:(BOOL)animated{
    void (^b)(void);
    b = ^{
        self.isMenuShowed = NO;
        self.center=CGPointMake(WIDTH/2,-70);
    };
    
    if (animated){
        [ UIView animateWithDuration:0.1 animations:b];
    }else{
        b();
    }
}


-(void)hideFullMenuAnimated:(   BOOL)animated{
    void (^b)(void);
    b = ^{
        self.isMenuShowed = NO;
        self.center=CGPointMake(WIDTH/2,-85);
        self.alpha=0;
    };
    
    if (animated){
        [ UIView animateWithDuration:0.1 animations:b];
    }else{
        b();
    }
}


-(void)showMenuAnimated:(BOOL)animated{
    void (^b)(void);
    self.alpha=1.0;
    b = ^{
        self.isMenuShowed = YES;
        self.center=CGPointMake(WIDTH/2,75);
        self.alpha=1;
    };
    
    if (animated){
        [ UIView animateWithDuration:0.1 animations:b];
    }else{
        b();
    }
}


-(void)objective{
    [self.delegate performSelector:@selector(showHelp) withObject:nil];
}

-(void)help{
    if(![MTWebApi getSchool]){
    MTHelpView * help = [[MTHelpView alloc]initWithFrame:self.superview.frame];
    [help showMainScreenHelp];
    [self.superview addSubview:help];
    
    [self hideMenuAnimated:YES];
    }
}
@end
