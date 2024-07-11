//
//  MTGameOverView.m
//  MagicTrains
//
//  Created by Blazej Zyglarski on 20.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTGameOverView.h"
#import "MTGhostImageView.h"
#import "MTGUI.h"

@interface MTGameOverView ()
@property    UIImageView * star1;
@property    UIImageView * star2;
@property    BOOL win;
@property    UIImageView * mstar1;
@property    UIImageView * mstar2;
@property    UIImageView * mstar3;
@property    UIImageView * puchar;
@property    NSMutableArray * ghosts;

@property    UIImageView * ghost;
@property UIImageView* wygrana;
@property NSTimer* t1;
@property NSTimer* t2;

@property float degrees;




@end
@implementation MTGameOverView
@synthesize wygrana;
@synthesize delegate;
@synthesize ghost;
- (instancetype)initWithWin:(BOOL)win{
    self = [self initWithWin:win andGhost:@"D3"];
    return self;
}

- (instancetype)initWithWin:(BOOL)win andGhost:(NSString*)ghostName
{
     self= [super initWithImage:[UIImage imageNamed:@"EMPTY.png"]];
    
    if (self){
        [self setFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        UIVisualEffectView *visualEffectView;
        visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        
        visualEffectView.frame = CGRectMake(0, 0,  WIDTH, HEIGHT);
        [self addSubview:visualEffectView];
        [self setUserInteractionEnabled:YES];
        
        
        self.win=win;
        if(win)
            [self initWin:ghostName];
        else
            [self initGameOver:ghostName];
        
    }
    return self;
}
-(void)show{
    self.alpha=0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=1;
    }];
}

-(void)hide{
    //self.alpha=0;
    // [[MTAudioPlayer instanceMTAudioPlayer] stopHappyFail];
    //[[MTAudioPlayer instanceMTAudioPlayer] play:@"background_code"];
    [[MTAudioPlayer instanceMTAudioPlayer] play:@"background_codeloop"];
    ////NSLog(@"------");
    [self.t1 invalidate];
    self.t1=nil;
    [self.t2 invalidate];
    self.t2=nil;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0;
        [self.delegate hide];
    }completion:^(BOOL a){[self removeFromSuperview];}];
}


-(void)hideAndExit{
    [self hide];
    [self.delegate performSelector:@selector(exit)];
}

-(void)initWin:(NSString*)ghostName{
  //  [[MTAudioPlayer instanceMTAudioPlayer] playHappy];
    if([[ghostName substringFromIndex:1] integerValue]>9){
        ghostName=@"D4"
        ;    }
     [[MTAudioPlayer instanceMTAudioPlayer] play:@"background_simulation_win" next:@"background_codeloop"];
    
    self.wygrana  = [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"WYGRANA.png"]];
    UIImageView *  u = self.wygrana;
    [u setFrame:CGRectMake(000,000, WIDTH, HEIGHT)];
   [self addSubview:u];
    
    self.star1= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"STAR2.png"]];
    [self.star1 setFrame:CGRectMake(000,000,2000,2000)];
    self.star1.center=u.center;
    self.star1.alpha=0.01;
    [u addSubview:self.star1];
    
    self.t1=[NSTimer scheduledTimerWithTimeInterval:1/60 target:self selector:@selector(rotateSatrs) userInfo:nil repeats:YES];
    self.t2=[NSTimer scheduledTimerWithTimeInterval:1/10 target:self selector:@selector(putNewStar) userInfo:nil repeats:YES];
    self.star2= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"STAR2.png"]];
    [self.star2 setFrame:CGRectMake(000,000,2000,2000)];
    self.star2.center=u.center;
    self.star2.alpha=0.01;
    [u addSubview:self.star2];
    
    self.mstar1= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"MAGICSTARON1.png"]];
    [self.mstar1 setFrame:CGRectMake(000,000,1,1)];
    self.mstar1.center=u.center;
    self.mstar1.alpha=0.01;
    [u addSubview:self.mstar1];
    self.mstar2= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"MAGICSTARON2.png"]];
    [self.mstar2 setFrame:CGRectMake(000,000,1,1)];
    self.mstar2.center=u.center;
    self.mstar2.alpha=0.01;
    [u addSubview:self.mstar2];
    self.mstar3= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"MAGICSTARON3.png"]];
    [self.mstar3 setFrame:CGRectMake(000,000,1,1)];
    self.mstar3.center=u.center;
    self.mstar3.alpha=0.01;
    [u addSubview:self.mstar3];
    
    

    //[NSTimer scheduledTimerWithTimeInterval:1/60 target:self selector:@selector(rotateSatrs) userInfo:nil repeats:YES];
    self.ghosts = [NSMutableArray arrayWithCapacity:6];
    for(int i =0;i<=5;i++)[self.ghosts addObject:[[UIImageView alloc]init]];
    int j=0;
    int ind[]  = {2,5,1,4,0,3};
    
    for(int i =1;i<=7;i++){
        if (![[NSString stringWithFormat:@"D%d",i] isEqual:ghostName]){
            if(j<6){
            
            MTGhostImageView * ghost1= [[MTGhostImageView alloc ]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"D%d_C1.png",i]]];
            [ghost1 setFrame:CGRectMake(000,000,100,100)];
            ghost1.center=u.center;
            ghost1.alpha=0;
            [self addSubview:ghost1];
            
            UIImageView *ghostface= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"D%d_USMIECHNIETY_1.png",i]]];
            [ghostface setFrame:CGRectMake(000,000,100,100)];
            
            ghostface.alpha=1;
            [ghost1 addSubview:ghostface];
            
            [self.ghosts replaceObjectAtIndex:ind[j] withObject:ghost1];
            j++;
            }
        }
    }
    
    ghost= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_C1.png",ghostName]]];
    [ghost setFrame:CGRectMake(000,000,100,100)];
    ghost.center=u.center;
    ghost.alpha=0.01;
    [self addSubview:ghost];
    
    
    self.puchar= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"PUCHAR.png"]];
    [self.puchar setFrame:CGRectMake(000,000,1,1)];
    self.puchar.center=u.center;
    self.puchar.alpha=0.01;
    [self addSubview:self.puchar];
    
    UIImageView *ghostface= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_USMIECHNIETY_1.png",ghostName]]];
    [ghostface setFrame:CGRectMake(000,000,100,100)];
    
    ghostface.alpha=1;
    [ghost addSubview:ghostface];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        [ghost setFrame:CGRectMake(000,000,200,200)];
        ghost.center=u.center;
        [ghostface setFrame:CGRectMake(000,000,200,200)];
        ghost.alpha=1;
        [self.puchar setFrame:CGRectMake(000,000,200,200)];
        self.puchar.center=CGPointMake(ghost.center.x-100,ghost.center.y);
        self.puchar.alpha=1;
    } completion:^(BOOL a){
        
        [UIView animateWithDuration:0.2 animations:^{
            [self.mstar3 setFrame:CGRectMake(320+(WIDTH-1024)/2,165+(HEIGHT-768)/2,205,249)];
            //[self.mstar3 setFrame:CGRectMake(20,165,205,249)];
            self.mstar3.alpha=1;
            
        } completion:^(BOOL b){
            [UIView animateWithDuration:0.2 animations:^{
                [self.mstar2 setFrame:CGRectMake(410+(WIDTH-1024)/2,150+(HEIGHT-768)/2,205,249)];
                self.mstar2.alpha=1;
                
            } completion:^(BOOL b){
                [UIView animateWithDuration:0.2 animations:^{
                    [self.mstar1 setFrame:CGRectMake(515+(WIDTH-1024)/2,165+(HEIGHT-768)/2,205,249)];
                    self.mstar1.alpha=1;
                    
                } completion:^(BOOL b){
                    [UIView animateWithDuration:0.6 animations:^{
                        int i =0;
                        for(UIImageView* ght in self.ghosts){
                            int k=1;
                            if(i<3)k=-1;
                            
                            int n= i%3+1;
                            ght.center=CGPointMake(ght.center.x+k*(n+1)*60, 20+ght.center.y+n*10);
                            ght.transform = CGAffineTransformMakeRotation((k*n*5*3.14/180));
                            ght.alpha=1;
                            i++;
                        }
                    } completion:^(BOOL b){
                        [UIView animateWithDuration:0.6 animations:^{
                            int i =0;
                            for(MTGhostImageView* ght in self.ghosts){
                                [ght animate:-1];
                                [UIView animateWithDuration:0.6 animations:^{
                                    ght.center=CGPointMake(ght.center.x, ght.center.y+10);
                                } completion:^(BOOL b){
                                    [UIView animateWithDuration:0.6 animations:^{
                                        ght.center=CGPointMake(ght.center.x, ght.center.y-10);
                                    } completion:^(BOOL b){
                                        
                                    }];
                                }];

                            }
                        } completion:^(BOOL b){
                            [UIView animateWithDuration:0.6 animations:^{
                                ghost.center=CGPointMake(ghost.center.x, ghost.center.y+20);
                            } completion:^(BOOL b){
                                [UIView animateWithDuration:0.6 animations:^{
                                    ghost.center=CGPointMake(ghost.center.x, ghost.center.y-20);
                                } completion:^(BOOL b){
                                    
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
    //[NSTimer scheduledTimerWithTimeInterval:1/60 target:self selector:@selector(rotateSatrs) userInfo:nil repeats:YES];
    
    int d = arc4random()%5+1;
    
    UIImageView *btt= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"GAMEOVERBACK.png"]];
    [btt setFrame:CGRectMake(WIDTH/2-110,HEIGHT-300,100,100)];
    [btt addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)]];
    [self addSubview:btt];
    [btt setUserInteractionEnabled:true];
    
    
    UIImageView *btt2= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"GAMEOVEROK.png"]];
    [btt2 setFrame:CGRectMake(WIDTH/2+10,HEIGHT-300,100,100)];
    [btt2 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideAndExit)]];
   [btt2 setUserInteractionEnabled:true];
    [self addSubview:btt2];
    
   
    
}




-(void)initGameOver:(NSString*)ghostName{
    //[[MTAudioPlayer instanceMTAudioPlayer] playFail];
    [[MTAudioPlayer instanceMTAudioPlayer] play:@"background_simulation_fail" next:@"background_codeloop"];
    if([[ghostName substringFromIndex:1] integerValue]>9){
        ghostName=@"D4"
        ;    }
    
    self.wygrana  = [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"PRZGRANA.png"]];
    UIImageView *  u = self.wygrana;
    [u setFrame:CGRectMake(000,000, WIDTH, HEIGHT)];
    [self addSubview:u];
    
    self.star1= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"STAR2.png"]];
    [self.star1 setFrame:CGRectMake(000,000,2000,2000)];
    self.star1.center=u.center;
    self.star1.alpha=0.01;
    [u addSubview:self.star1];
    
    self.t1=[NSTimer scheduledTimerWithTimeInterval:1/60 target:self selector:@selector(rotateSatrs) userInfo:nil repeats:YES];
    self.t2=[NSTimer scheduledTimerWithTimeInterval:1/10 target:self selector:@selector(putNewStar) userInfo:nil repeats:YES];
    self.star2= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"STAR2.png"]];
    [self.star2 setFrame:CGRectMake(000,000,2000,2000)];
    self.star2.center=u.center;
    self.star2.alpha=0.01;
    [u addSubview:self.star2];
    
    /*self.mstar1= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"MAGICSTARON1.png"]];
    [self.mstar1 setFrame:CGRectMake(000,000,1,1)];
    self.mstar1.center=u.center;
    self.mstar1.alpha=0.01;
    [u addSubview:self.mstar1];
    self.mstar2= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"MAGICSTARON2.png"]];
    [self.mstar2 setFrame:CGRectMake(000,000,1,1)];
    self.mstar2.center=u.center;
    self.mstar2.alpha=0.01;
    [u addSubview:self.mstar2];
    self.mstar3= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"MAGICSTARON3.png"]];
    [self.mstar3 setFrame:CGRectMake(000,000,1,1)];
    self.mstar3.center=u.center;
    self.mstar3.alpha=0.01;
    [u addSubview:self.mstar3];*/
    
    
    
    //[NSTimer scheduledTimerWithTimeInterval:1/60 target:self selector:@selector(rotateSatrs) userInfo:nil repeats:YES];
    self.ghosts = [NSMutableArray arrayWithCapacity:6];
    for(int i =0;i<=5;i++)[self.ghosts addObject:[[UIImageView alloc]init]];
    int j=0;
    int ind[]  = {2,5,1,4,0,3};
    
    /*for(int i =1;i<=7;i++){
        if (![[NSString stringWithFormat:@"D%d",i] isEqual:ghostName]){
            if(j<6){
                
                MTGhostImageView * ghost1= [[MTGhostImageView alloc ]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"D%d_C1.png",i]]];
                [ghost1 setFrame:CGRectMake(000,000,100,100)];
                ghost1.center=u.center;
                ghost1.alpha=0;
                [self addSubview:ghost1];
                
                UIImageView *ghostface= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"D%d_ZDZIWIONY.png",i]]];
                [ghostface setFrame:CGRectMake(000,000,100,100)];
                
                ghostface.alpha=1;
                [ghost1 addSubview:ghostface];
                
                [self.ghosts replaceObjectAtIndex:ind[j] withObject:ghost1];
                j++;
            }
        }
    }*/
    
    ghost= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_C1.png",ghostName]]];
    [ghost setFrame:CGRectMake(000,000,100,100)];
    ghost.center=u.center;
    ghost.alpha=0.01;
    [self addSubview:ghost];
    
    
    /*self.puchar= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"PUCHAR.png"]];
    [self.puchar setFrame:CGRectMake(000,000,1,1)];
    self.puchar.center=u.center;
    self.puchar.alpha=0.01;
    [self addSubview:self.puchar];*/
    
    UIImageView *ghostface= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_ZDZIWIONY.png",ghostName]]];
    [ghostface setFrame:CGRectMake(000,000,100,100)];
    
    ghostface.alpha=1;
    [ghost addSubview:ghostface];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        [ghost setFrame:CGRectMake(000,000,200,200)];
        ghost.center=u.center;
        [ghostface setFrame:CGRectMake(000,000,200,200)];
        ghost.alpha=1;
        [self.puchar setFrame:CGRectMake(000,000,200,200)];
        self.puchar.center=CGPointMake(ghost.center.x-100,ghost.center.y);
        self.puchar.alpha=1;
    } completion:^(BOOL a){
        
        [UIView animateWithDuration:0.2 animations:^{
          //  [self.mstar3 setFrame:CGRectMake(320,165,205,249)];
           // self.mstar3.alpha=1;
            
        } completion:^(BOOL b){
            [UIView animateWithDuration:0.2 animations:^{
            //    [self.mstar2 setFrame:CGRectMake(410,150,205,249)];
             //   self.mstar2.alpha=1;
                
            } completion:^(BOOL b){
                [UIView animateWithDuration:0.2 animations:^{
               //     [self.mstar1 setFrame:CGRectMake(515,165,205,249)];
                  //  self.mstar1.alpha=1;
                
                } completion:^(BOOL b){
                    [UIView animateWithDuration:0.6 animations:^{
                        int i =0;
                       /* for(UIImageView* ght in self.ghosts){
                            int k=1;
                            if(i<3)k=-1;
                            
                            int n= i%3+1;
                            ght.center=CGPointMake(ght.center.x+k*(n+1)*60, 20+ght.center.y+n*10);
                            ght.transform = CGAffineTransformMakeRotation((k*n*5*3.14/180));
                            ght.alpha=1;
                            i++;
                        }*/
                    } completion:^(BOOL b){
                        [UIView animateWithDuration:0.6 animations:^{
                            int i =0;
                           /* for(MTGhostImageView* ght in self.ghosts){
                                //[ght animate:-1];
                                [UIView animateWithDuration:0.6 animations:^{
                                    ght.center=CGPointMake(ght.center.x, ght.center.y+10);
                                } completion:^(BOOL b){
                                    [UIView animateWithDuration:0.6 animations:^{
                                        ght.center=CGPointMake(ght.center.x, ght.center.y-10);
                                    } completion:^(BOOL b){
                                        
                                    }];
                                }];
                                
                            }*/
                        } completion:^(BOOL b){
                            [UIView animateWithDuration:0.6 animations:^{
                                ghost.center=CGPointMake(ghost.center.x, ghost.center.y+20);
                            } completion:^(BOOL b){
                                [UIView animateWithDuration:0.6 animations:^{
                                    ghost.center=CGPointMake(ghost.center.x, ghost.center.y-20);
                                } completion:^(BOOL b){
                                    
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
    //[NSTimer scheduledTimerWithTimeInterval:1/60 target:self selector:@selector(rotateSatrs) userInfo:nil repeats:YES];
    
    int d = arc4random()%5+1;
    
    UIImageView *btt= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"GAMEOVERBACK.png"]];
    [btt setFrame:CGRectMake(WIDTH/2-110,HEIGHT-300,100,100)];
     [btt addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)]];
    [self addSubview:btt];
       [btt setUserInteractionEnabled:true];
    
    UIImageView *btt2= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"GAMEOVEREXIT.png"]];
    [btt2 setFrame:CGRectMake(WIDTH/2+10,HEIGHT-300,100,100)];
     [btt2 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideAndExit)]];
    [self addSubview:btt2];
   [btt2 setUserInteractionEnabled:true];
    
    
    UIImageView *btt3= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"GAMEOVERX.png"]];
    [btt3 setFrame:CGRectMake(WIDTH/2-50,300,100,100)];
    
    [self addSubview:btt3];

    
    
}



-(void)rotateSatrs{
    self.degrees +=0.1;
    if (self.degrees==360)self.degrees=1;
    
    self.star1.transform = CGAffineTransformMakeRotation(self.degrees * M_PI/180);

    self.star2.transform = CGAffineTransformMakeRotation(-self.degrees * M_PI/180);
}

-(void)putNewStar{
    int d = arc4random()%5+1;
    
    
    int x = arc4random()%(int)WIDTH;
    int y = arc4random()%(int)WIDTH;
    int zx = arc4random()%2;
    int zy = arc4random()%2;
    if(zx==0)zx=-1;
    if(zy==0)zy=-1;
    int ey = arc4random()%2;
    int ex = (ey+1)%2;
    
    UIImageView *u;
    if(!self.win){
        u= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"DROP%d.png",d]]];
        u.alpha=1;
        [u setFrame:CGRectMake(u.frame.origin.x+zx*(ey*WIDTH+x),u.frame.origin.y+zy*(ex*WIDTH+y), 200, 200)];
    }else{
        u= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"STARS%d.png",d]]];
        [u setFrame:CGRectMake(WIDTH/2,HEIGHT/2,40,40)];
        u.alpha=0;
    }    //u.center=self.center;

    [wygrana addSubview:u];
    [UIView animateWithDuration:3 animations:^{
        if(self.win){
            u.alpha=1;
            [u setFrame:CGRectMake(u.frame.origin.x+zx*(ey*WIDTH+x),u.frame.origin.y+zy*(ex*WIDTH+y), 200, 200)];
        }else{
            [u setFrame:CGRectMake(WIDTH/2,HEIGHT/2,40,40)];
            u.alpha=0;
        }
        
    } completion:^(BOOL a){[u removeFromSuperview];}];
}
@end
