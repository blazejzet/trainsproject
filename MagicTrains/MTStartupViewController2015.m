//
//  MTStartupViewController.m
//  MagicTrains
//
//  Created by Blazej Zyglarski on 05.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTStartupViewController2015.h"
#import "MTViewController.h"
#import "MTButtonsView.h"
#import "MTAudioPlayer.h"
#import "MTGhostImageView.h"
#import "TestView.h"
#import "MTWebApi.h"
#import "MTAvatarView.h"
#import "MTGUI.h"
#import "MySegue.h"
#import "MTNewMenuButton.h"
#import "NetReach.h"
#import "MTCloudKitController.h"
#import "MTTestFaceView.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface MTStartupViewController2015 ()
@property (weak, nonatomic) IBOutlet UIView *menuVie;
@property (weak, nonatomic) IBOutlet UIImageView *logoboard;
@property (weak, nonatomic) IBOutlet UIView *funboard;
@property (weak, nonatomic) IBOutlet UIImageView *titleboard;
@property UIImageView* star1;
@property NSMutableArray * ghosts;
@property (weak, nonatomic) IBOutlet UIImageView *bgboard;
@property BOOL playStartInfo;
@property BOOL enabled;
@property BOOL first;
@property BOOL school;

@property MTTestFaceView* m_testView;
@property (weak) TestView* uploadProgress;
@property   MTAvatarView * avw;

@property CGPoint start;



@property NSTimer * t1;


@property MTButtonsView* numbers;
@property UIImageView * si;

@property float degrees;
@property int astep;
@property UIImageView* imv;

//WłAŚCIWOŚCI DOTYCZĄCE NOWEGO MENU
@property NSMutableArray* przyciski;

//===
@end

@implementation MTStartupViewController2015
@synthesize t1;
@synthesize ghosts;
@synthesize avw;
@synthesize first;
@synthesize astep;
@synthesize star1;
@synthesize playStartInfo;
@synthesize enabled;
@synthesize degrees;
@synthesize m_testView;
@synthesize numbers;
@synthesize uploadProgress;
@synthesize school;


@synthesize imv;

@synthesize przyciski;

-(void)startHelp{
     //if(self.playStartInfo){
        [[MTAudioPlayer instanceMTAudioPlayer] performSelector:@selector(playStartInfo) withObject:nil afterDelay:.1];
       //  }
}
-(void)startPlayStartInfo{
    if(self.playStartInfo){
        if(!m_testView){
            [self insertTestView];
            if(m_testView){
                [m_testView.test show];
                [m_testView.test startCountdown];
            }
        }
    }

}


-(void)touchesBeganX:(NSSet *)touches withEvent:(UIEvent *)event{
    //////NSLog(@"Beg");
    _start = [[touches anyObject] locationInView:self.view];
    
}

-(void)touchesMovedX:(NSSet *)touches withEvent:(UIEvent *)event{
    //////NSLog(@"Mov");
    CGPoint p  = [[touches anyObject] locationInView:self.view];
    
    [self updatePositions:CGPointMake(self.menuVie.center.x, self.menuVie.center.y-_start.y+p.y)];
    
    _start = p;
    
}

-(void)updatePositions:(CGPoint)p{
    NSLog(@"Updating positions: %f %f",p.x,p.y);
    if(HEIGHT==768){
    if(p.y>HEIGHT/2 && p.y<HEIGHT+250){
        self.menuVie.center=p;
        self.logoboard.center=CGPointMake(self.logoboard.center.x, p.y/4);
        self.titleboard.center=CGPointMake(self.titleboard.center.x, p.y/4);
        self.funboard.center=CGPointMake(self.funboard.center.x, p.y/4);
        //////NSLog(@"%f", p.y/3.5);
    if (p.y/4<=HEIGHT/4){
        self.titleboard.alpha = pow(((p.y/3.5)/(HEIGHT/3.5)),16);
        self.funboard.alpha = pow(((p.y/3.5)/(HEIGHT/3.5)),1.5);
        self.logoboard.alpha = pow(((p.y/3.5)/(HEIGHT/3.5)),1.5);
    }else{
        self.titleboard.alpha=1;
        self.funboard.alpha=1;
        self.logoboard.alpha=1;
        
    }
    }
    }else{
        if(p.y>HEIGHT/2 && p.y<HEIGHT+250){
            self.menuVie.center=p;
            self.logoboard.center=CGPointMake(self.logoboard.center.x, p.y/3);
            self.titleboard.center=CGPointMake(self.titleboard.center.x, p.y/3);
            self.funboard.center=CGPointMake(self.funboard.center.x, p.y/3);
            //////NSLog(@"%f", p.y/3.5);
            if (p.y/3<=HEIGHT/4){
                self.titleboard.alpha = pow(((p.y/3.5)/(HEIGHT/3.5)),16);
                self.funboard.alpha = pow(((p.y/3.5)/(HEIGHT/3.5)),1.5);
                self.logoboard.alpha = pow(((p.y/3.5)/(HEIGHT/3.5)),1.5);
            }else{
                self.titleboard.alpha=1;
                self.funboard.alpha=1;
                self.logoboard.alpha=1;
                
            }
        }
    }
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    self.playStartInfo=false;
    MTViewController * mt = (MTViewController*) segue.destinationViewController;
    
    if([sender isKindOfClass:[NSDictionary class]]){
        NSDictionary * sceneInfo = (NSDictionary*)sender;
        mt.scene = sceneInfo;
        CGFloat y = ((UIView*)sceneInfo[@"delegate"]).center.y +
        ((UIView*)sceneInfo[@"delegate"]).superview.frame.origin.y+
        ((UIView*)sceneInfo[@"delegate"]).superview.superview.frame.origin.y+
        ((UIView*)sceneInfo[@"delegate"]).superview.superview.superview.frame.origin.y+
        ((UIView*)sceneInfo[@"delegate"]).superview.superview.superview.superview.frame.origin.y;
        ((MySegue*)segue).spoint=CGPointMake(((UIView*)sceneInfo[@"delegate"]).center.x-150,y);
        
        //mt.loadedStage=[n intValue];
   
        
        
        
    //}else{
    //    mt.downloadedStage=(NSString*)sender;
    }
}
-(void) preparemenu{
    [self preparemenu:true];
}

-(void) showCloudKitLogin{
    self.imv =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iCLOUD"]];
    [self.view addSubview:self.imv];
    self.imv.center=CGPointMake(512, 100);
    self.imv.alpha=0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.imv.alpha=0.9
        ;
    }];
    
    [imv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rmvCKL)]];
    [imv setUserInteractionEnabled:true];
}

-(void) rmvCKL{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.imv.alpha=0;
    } completion:^(BOOL b){
        [self.imv removeFromSuperview];
        //TODO
        //Akcja dodania icloud.
    }];
}

-(void) preparemenu:(BOOL)netenabled{
   //NSLog(@"PREPARING MENU (is int con: %i",self.enabled);
    przyciski = [NSMutableArray array];
    MTNewMenuButton* bsandbox = [[MTNewMenuButton alloc] initWithType:@"sandbox"];
    [przyciski addObject:bsandbox];
    [bsandbox performSelector:@selector(click) withObject:nil afterDelay:2.0]; //po to aby sie sam sandbox na dziendobry odpalil.
    
    if (! self.school){
    //WERSJA NORMALNA:
    
    [przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"cloudmy"]];
    [przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"cloud"]];
    [przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"cloud_downloaded"]];
    [przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"contest"]];
    //[przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"book"]];
        }
    
    [przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"cloudshowcase"]];
    if (self.school){
        //WERSJA SZKOLNA:
        [przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"more"]];
    }
    
    
    float i = -((przyciski.count-1)*1.0/2.0);
    ////NSLog(@">>>>>>%f",i);
    for(MTNewMenuButton* b in przyciski){
        [self.menuVie addSubview:b];
        if (netenabled) [b setEnabled]; else [b  setDisabled];
        b.p=self;
        CGPoint p  = CGPointMake(self.view.frame.size.width/2+b.frame.size.width*1.5*5/przyciski.count*i, 50);
        
        b.center = p;
        
        
        MTNewMenuPoziomDisplay * mtpoziom = [[NSClassFromString([NSString stringWithFormat:@"MTNewMenuPoziomDisplay_%@",b.type]) alloc] init];
        [mtpoziom prepare:p];
        mtpoziom.p=self;
        if (netenabled) [mtpoziom setEnabled]; else [mtpoziom  setDisabled];
        [self.menuVie addSubview:mtpoziom];
        mtpoziom.delegate = self;
        b.refDisplay= mtpoziom;
        
        b.othersCollection = self.przyciski;
        float atime = 0.1 * (arc4random()%10)+1.0;
        [b performSelector:@selector(show) withObject:nil afterDelay:atime];
        i++;
    }
}



-(void) enableCloud{
    self.enabled=true;
    for(MTNewMenuButton* b in przyciski){
        //b.userInteractionEnabled=true;
        [b setEnabled];
        //b.alpha=1.0;
    }
}

-(void) disableCloud{
    self.enabled=false;
    for(MTNewMenuButton* b in przyciski){
        //if([b.type isEqualToString:@"cloudmy"] || [b.type isEqualToString:@"cloud"])
        //b.userInteractionEnabled=false;
        //b.alpha=0.1;
        [b setDisabled];
    }
}

-(void) createMenu:(BOOL) netenabled{
    if(self.przyciski == nil){
        //Sprawdzanie czy jest iCoud
        [MTCloudKitController checkIfUserLoggedToICloudOnSuccess:^{
           //NSLog(@"CloudKitSuccess");
            if(self.przyciski == nil){
                [self preparemenu:netenabled];
            }
        } onError:^{
            //NSLog(@"CloudKitFailed");
            [self showCloudKitLogin];
            if(self.przyciski == nil){
            [self preparemenu:false];
            }
        }];
        
        [self showAvatar];
    }
}
-(void)checkTI{
    if(![MTWebApi checkServicing]){
        //[[MTWebApi getInstance] setDel:self];
        [[MTWebApi getInstance] performSelector:@selector(checkTI) withObject:nil afterDelay:1.0];
    }
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //wersja ustawiana w opcjach aplikacji w formie 1.1.0.0. Brane pod uwage pierwsze dwie liczby
    //zwraca 1.1.x.x -> 1001, 2.5.1 -> 2005 itp.
    int appv = [MTWebApi getAppVersion];
    self.school = [MTWebApi getSchool];
    if(self.school){
        if([MTWebApi checkServicing]){
            // SERWIS JUŻ ODPALONY
            // nie sprawdzaj
            

        }else{
            [MTWebApi checkMasterService];
        }
    }
    NSLog(@"Witamy w Trains Project wersja %d",appv );
    //self.menuVie.frame=self.view.frame;
    //self.menuVie.contentMode=UIViewContentModeCenter;
    self.logoboard.frame=self.view.frame;
    self.logoboard.contentMode=UIViewContentModeCenter;
    self.funboard.frame=self.view.frame;
    self.funboard.contentMode=UIViewContentModeCenter;
    self.titleboard.frame=self.view.frame;
    self.titleboard.contentMode=UIViewContentModeCenter;
    self.bgboard.frame=self.view.frame;
    self.bgboard.contentMode=UIViewContentModeScaleAspectFill;
    
    
    self.enabled=true;
    self.first=true;
    
    NetReach* reach = [NetReach reachabilityWithHostname:@"icloud.com"];
    
    // Set the blocks
    reach.reachableBlock = ^(NetReach*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            ////NSLog(@"REACHABLE!");
            [self enableCloud];
            [self createMenu:true];
            [MTWebApi setOnline];
        });
    };
    
    reach.unreachableBlock = ^(NetReach*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            ////NSLog(@"SORRY, UNREACHABLE!!!!");
            [self disableCloud];
            [self createMenu:false];
            [MTWebApi setOffline];
            
        });
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    
    
    
    
    
    self.playStartInfo=true;
    [super viewDidLoad];
    [self performSelector:@selector(startPlayStartInfo) withObject:nil afterDelay:16.];
    
    // [ playStartInfo];
    
    self.degrees=-0.0;
    
    if ([MTWebApi getSchool]){
        [self checkTI];
    }
 
    if ([MTWebApi getSchool]){
        self.star1= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"ROTATING_BG_classroom"]];
        self.titleboard.image = [UIImage imageNamed:@"STARTUP_TITLE_classroom"];
    }else{
        self.star1= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"ROTATING_BG"]];
        self.titleboard.image = [UIImage imageNamed:@"STARTUP_TITLE"];
        
    }
    
    [self.star1 setFrame:CGRectMake(000,000,2048,2048)];
    self.star1.center=self.bgboard.center;
    self.star1.alpha=1.0;
    [self.bgboard addSubview:self.star1];
    if(!self.t1)
    self.t1=[NSTimer scheduledTimerWithTimeInterval:1/60 target:self selector:@selector(rotateSatrs) userInfo:nil repeats:YES];

    astep=0;

    [UIView animateWithDuration:0.5 animations:^{
        [self.logoboard setFrame:self.logoboard.frame];
        
    } completion:^(BOOL b){
        
        [UIView animateWithDuration:0.5 animations:^{
            CGFloat x = 0;
            if (HEIGHT==1024) x=200;
                [self updatePositions:CGPointMake(1024/2, HEIGHT-(768-930)-x)];
                self.si.alpha=1;

        } completion:^(BOOL b){
            self.playStartInfo=true;
            [self animate];
            [reach startNotifier];
        }];
    }];
    
    //*przycisk logowania facebook - do wersji 2.0
    //FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    //loginButton.center = self.view.center;
    //[self.view addSubview:loginButton];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    
    CGPoint old = self.menuVie.center;
    if(self.first){
        self.first=false;
    }else{
        if(HEIGHT==1024){
            [self updatePositions:CGPointMake(old.x, old.y+200)];
        }else{
            [self updatePositions:CGPointMake(old.x, old.y+000)];
            
        }
    }
  //  [UIView animateWithDuration:0.5 animations:^{
  //      [self updatePositions:old];
  //
  //  }];
    if(self.przyciski != nil){
        for(MTNewMenuButton* b in przyciski){
            [b refresh];
        }
    }
    
}

-(void)logoBoardAnimate{
    [UIView animateWithDuration:.5 animations:^{
        self.logoboard.transform =  CGAffineTransformMakeRotation(0.1);
    } completion:^(BOOL b){
        [UIView animateWithDuration:.5 animations:^{
            self.logoboard.transform =   CGAffineTransformMakeRotation(-.1);
        } completion:^(BOOL b){
           
            
        }];
        
    }];
    
    [UIView animateWithDuration:.4 animations:^{
        self.logoboard.transform =  CGAffineTransformMakeScale(1.05, 1.05);
        self.titleboard.transform =  CGAffineTransformMakeScale(1.03, 1.03);
        
    } completion:^(BOOL b){
        [UIView animateWithDuration:.2 animations:^{
            self.logoboard.transform =  CGAffineTransformMakeScale(0.97, 0.97);
            self.titleboard.transform =  CGAffineTransformMakeScale(1.025, 1.025);
        } completion:^(BOOL b){
            [UIView animateWithDuration:.2 animations:^{
                self.logoboard.transform =  CGAffineTransformMakeScale(1.0, 1.0);
                self.titleboard.transform =  CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL b){
                
            }];
            
        }];

    }];
}

-(void)animate{
    
    [NSTimer scheduledTimerWithTimeInterval:1.1 target:self selector:@selector(logoBoardAnimate) userInfo:nil repeats:YES];
    UIView * u = self.bgboard;
    
    NSString *ghostName=@"D1";
    
    self.ghosts = [NSMutableArray arrayWithCapacity:6];
    for(int i =0;i<=5;i++)[self.ghosts addObject:[[UIImageView alloc]init]];
    int j=0;
    int gn[]  = {3,31,34,4,32,35};
    int k[]  = {2,1,0,5,4,3};
    
    for(int i =0;i<=5;i++){
        
                
                MTGhostImageView * ghost1= [[MTGhostImageView alloc ]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"D%d_C1.png",gn[i]]]];
                [ghost1 setFrame:CGRectMake(000,000,100,100)];
                ghost1.center=CGPointMake(u.center.x+10,u.center.y);
                ghost1.alpha=0;
                [self.funboard addSubview:ghost1];
                
                UIImageView *ghostface= [[UIImageView alloc ]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"D%d_USMIECHNIETY_1.png",gn[i]]]];
                [ghostface setFrame:CGRectMake(000,000,100,100)];
                
                ghostface.alpha=1;
                [ghost1 addSubview:ghostface];
                
                [self.ghosts replaceObjectAtIndex:k[i] withObject:ghost1];
        
        
    }
    
    
    
   
    
    
    [UIView animateWithDuration:0.3 animations:^{
       
    } completion:^(BOOL a){
        
        [UIView animateWithDuration:0.2 animations:^{
            
        } completion:^(BOOL b){
            [UIView animateWithDuration:0.2 animations:^{
                
            } completion:^(BOOL b){
                [UIView animateWithDuration:0.2 animations:^{
                 
                    
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
                            //[UIView endAll]
                            [UIView animateWithDuration:0.6 animations:^{
                              //  ghost.center=CGPointMake(ghost.center.x, ghost.center.y+20);
                            } completion:^(BOOL b){
                                [UIView animateWithDuration:0.6 animations:^{
                                //    ghost.center=CGPointMake(ghost.center.x, ghost.center.y-20);
                                } completion:^(BOOL b){
                                    
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

-(void)buttonPressed:(int)i{
    ////NSLog(@"DEPRECATED");
    //[self performSegueWithIdentifier:@"go" sender:[NSNumber numberWithInt:i]];
}


-(void)openScene:(NSDictionary*)scene{
    
    [self performSegueWithIdentifier:@"go2" sender:scene];
}

-(void)insertTestView{
    if(!m_testView){
        m_testView = [[MTTestFaceView alloc] init];
        m_testView.test.percent = 100;
        [self.view addSubview:m_testView];
        [m_testView.test show];
        //[m_testView startCountdown];
        m_testView.center=CGPointMake(WIDTH-88,88);
        [m_testView setDelegate:self];
    }
}
-(void)userAction{
    self.playStartInfo=false;
    
}

NSString *letters_ = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters_ characterAtIndex: arc4random_uniform([letters_ length])]];
    }
    
    return randomString;
}

-(void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes{
    if(self.uploadProgress){
        [self.uploadProgress updatePercent:((CGFloat)totalBytesWritten / expectedTotalBytes) * 100.0];
    }
    
}


- (void)       connection:(NSURLConnection *)connection
          didSendBodyData:(NSInteger)bytesWritten
        totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    if(self.uploadProgress){
        [self.uploadProgress updatePercent:((CGFloat)totalBytesWritten / totalBytesExpectedToWrite) * 100.0];
        if( (((CGFloat)totalBytesWritten / totalBytesExpectedToWrite) * 100.0) == 100.0){
            [self.uploadProgress hide];
        }
        
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    ////NSLog(@"%@",error);
    [self.uploadProgress setRedColor];
    [self.uploadProgress updatePercent:100.0];
    [self.uploadProgress performSelector:@selector(hide) withObject:nil afterDelay:2.0];
    
}


-(void)rotateSatrs{
    self.degrees +=0.0003;
    if (self.degrees==360)self.degrees=1;
    
    self.star1.transform = CGAffineTransformMakeRotation(self.degrees * M_PI/180);
    
    //self.star2.transform = CGAffineTransformMakeRotation(-self.degrees * M_PI/180);
}




-(void)netPressed:(NSString *)s{
    //[self performSegueWithIdentifier:@"go" sender:s];
}

-(void)uploadPressed:(int) i {
    NSString *apiKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"apiKey"];
    NSMutableURLRequest *request = [[MTWebApi getInstance] saveGameWithFileName:[NSString stringWithFormat:@"SessionData%lu.mtd.mtz",(unsigned long) i]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
-(void)taskPressed:(NSString *)s{
    //[self performSegueWithIdentifier:@"go" sender:s];
}
-(void)learnPressed:(NSString *)s{
    //[self performSegueWithIdentifier:@"go" sender:s];
}
-(void)shareProgressBar:(TestView*)t{
    self.uploadProgress=t;
}

-(void)showAvatar{
    if(avw != nil){
               [avw removeFromSuperview];
    }
   avw = [[MTAvatarView alloc] init];
    [self.view addSubview:avw];
    avw.center=CGPointMake(100,100);
}

@end
