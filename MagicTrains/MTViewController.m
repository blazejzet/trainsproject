//
//  MTViewController.m
//  testNodow
//
//  Created by Dawid Skrzypczyński on 18.12.2013.
//  Copyright (c) 2013 UMK. All rights reserved.
//

#import "MTViewController.h"
#import "MTMainScene.h"
#import "MTArchiver.h"
#import "MTINMenuView.h"
#import "MTGameOverView.h"
#import "MTExecutor.h"
#import "TestView.h"
#import "MTHelpView.h"
#import "MTObjectiveView.h"
#import "MTWebApi.h"
#import "MTProjectTypeEnum.h"
#import "MySegue.h"
#import "MTLoadingView.h"
#import "MTStorage.h"
#import "MTGUI.h"
#import "MTGhostIconNode.h"
#import "MTNotSandboxProjectOrganizer.h"

#import "MTOfflineData.h"
#import "MTGlobalVar.h"
#import "MTGoXYCartOptions.h"
#import "MTStrategyOfSimultanousPinchRotateGestures.h"
#import "MTStrategyOfSimultanousPanPinchRotateGestures.h"
#import "MTStrategyOfAvailabilityNoneGestures.h"
#import "MTStrategyOfAvailabilityAllGestures.h"
#import "MTShotCartsOptions.h"
#import "MTRotationCartOptions.h"
#import "MTOfflineData.h"
#import "MTMoveCartsOptions.h"

#import "MTUserStorage.h"
#import "MTStrategyOfSimultanousNoneGestures.h"

#define degrees(x) (180.0 * x / M_PI)
@interface MTViewController()
@property MTINMenuView* inmenu;
@property NSMutableArray * timers;
@property MTGameOverView * gameOverScreen;
@property TestView* m_testView;
@property int helpTimerCounter;
@property NSArray* atlases;
@property MTLoadingView* loading;
@property UIImageView * blockview;
@property CMMotionManager * mot;
@end

@implementation MTViewController
@synthesize inmenu;
@synthesize blockview;
@synthesize helpTimerCounter;
@synthesize m_testView;
@synthesize loadedStage;
@synthesize downloadedStage;
@synthesize timers;
@synthesize mot;
@synthesize atlases;
@synthesize skf;

static MTViewController *myViewControllerInstance;
+ (MTViewController *) getInstance
{
    // CFIndex rc = CFGetRetainCount((__bridge CFTypeRef)myInstance);
    // ////NSLog(@"INSTANCE: %@",myInstance);
    // ////NSLog(@"CFGetRetainCount>>%d",rc);
    return myViewControllerInstance;
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    ////NSLog(@"INITWITHNIBNAME");
    //if([MTViewController getInstance]){
    //    self = [MTViewController getInstance];
        ////NSLog(@"UŻYCIE ISTNIEJĄCEJ INSTANCJI %@", [MTViewController getInstance]);
     //   return [MTViewController getInstance];
    //}else{
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
        myViewControllerInstance=self;
        ////NSLog(@"TWORZENIE NOWEJ INSTANCJI %@", self);

        return self;
    //}
  
//    return self;
}
-(instancetype)init{
    ////NSLog(@"INIT");
    self = [super init];
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    ////NSLog(@"INITWITH CODER");
    /*if([MTViewController getInstance]){
        self = [MTViewController getInstance];
        ////NSLog(@"UŻYCIE ISTNIEJĄCEJ INSTANCJI %@", [MTViewController getInstance]);
        return [MTViewController getInstance];
    }else{
      */
    
    self = [super initWithCoder:aDecoder];
    ////NSLog(@"Aktualny CFGetRetainCount>>%d",CFGetRetainCount((__bridge CFTypeRef)self));
    myViewControllerInstance=self;
    ////NSLog(@"TWORZENIE NOWEJ INSTANCJI %@", self);
    ////NSLog(@"Aktualny CFGetRetainCount>>%d",CFGetRetainCount((__bridge CFTypeRef)self));
    return self;
    //}

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.helpTimerCounter=0;
    if(self.m_testView){
        
        [self.m_testView hide];
        self.m_testView=nil;
    }
}

-(void)exit{
    //[[MTAudioPlayer instanceMTAudioPlayer] fadeInBackground];

       ////NSLog(@"1 exit Aktualny CFGetRetainCount>>%d",CFGetRetainCount((__bridge CFTypeRef)self));
    
    MTGhostsBarNode * gbr = (id) ([[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTGhostsBarNode"]);
    [gbr showBar];
    
    for(NSTimer* t in self.timers){
        if(t){
            [t invalidate];
            
        }
    }
    self.timers = nil;
    ////NSLog(@"2 exit Aktualny CFGetRetainCount>>%d",CFGetRetainCount((__bridge CFTypeRef)self));;
    
    myViewControllerInstance=nil;
    ////NSLog(@"2 exit Aktualny CFGetRetainCount>>%d",CFGetRetainCount((__bridge CFTypeRef)self));;
    [self.inmenu hideFullMenuAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    [[MTAudioPlayer instanceMTAudioPlayer] play:@"background_startloop"];
    
    //[self dismissViewControllerAnimated:YES completion:^{}];
    //[self release];
    
   // CFIndex rc2 = CFGetRetainCount((__bridge CFTypeRef)self);
      ////NSLog(@"2 exit Aktualny CFGetRetainCount>>%d",CFGetRetainCount((__bridge CFTypeRef)self));;
    //self=nil;
}
- (void)viewDidLoad
{
    ////NSLog(@"1 viewDidLoad Aktualny CFGetRetainCount>>%d",CFGetRetainCount((__bridge CFTypeRef)self));
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(exit)
                                                 name:@"RemoteExit"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showBlock)
                                                 name:@"RemoteBlock"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideBlock)
                                                 name:@"RemoteUnBlock"
                                               object:nil];
    
   
    
    
    myViewControllerInstance = self;
    self.timers= [NSMutableArray array];
    ////NSLog(@"2 viewDidLoad Aktualny CFGetRetainCount>>%d",CFGetRetainCount((__bridge CFTypeRef)self));
    [self.timers addObject:[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkHelp) userInfo:nil repeats:YES]];
    ////NSLog(@"3 viewDidLoad Aktualny CFGetRetainCount>>%d",CFGetRetainCount((__bridge CFTypeRef)self));
    SKView *skView = (SKView *)self.view;
    //skView.showsPhysics=true;
    
    self.skf =  [SKFieldNode linearGravityFieldWithVector:vector_float(vector3(0, 0, 0))];
    skf.enabled=YES;
    skf.strength=1.0;
    skf.name=@"SKF";
    skf.categoryBitMask=8;
    //[_mainScene addChild:skf];
    
    
  //  ////NSLog(@"VC = %@",[[MTViewController getInstance] mainScene]);
    /*[super viewDidLoad];
    SKView *skView = (SKView *)self.view;
    
    self.mainScene = [MTMainScene sceneWithSize:skView.bounds.size];
    [skView presentScene:self.mainScene];
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;*/
    
    self.mot =  [[CMMotionManager alloc] init];
    
    [self.mot startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc] init]  withHandler:
    ^(CMDeviceMotion * _Nullable gyroData, NSError * _Nullable error){
        
        if([MTExecutor getInstance].simulationStarted){
            if([MTExecutor getInstance].useCM){
       // CMAttitude * a = gyroData.attitude;
        CMAcceleration  a = gyroData.gravity;
        NSLog(@"%f, %f, %f",a.x, a.y,a.z);
        SKNode * scene = [[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
        scene.scene.physicsWorld.gravity=CGVectorMake( -a.y*5.0,  a.x*5.0);
        SKFieldNode * skf = [MTViewController getInstance].skf;
        skf.direction = vector_float(vector3( a.y*10.0,  -a.x*10.0, 0.0));
        }
        }else{
            SKNode * scene = [[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
            scene.scene.physicsWorld.gravity=CGVectorMake( 0.0,  0.0);
            SKFieldNode * skf = [MTViewController getInstance].skf;
            skf.direction = vector_float(vector3( 0.0,  0.0, 0.0));
        }

    }];
}



-(void)hideLoading{
    NSLog(@"Hiding Loading");
    [(MTGhostIconNode *)[self.mainScene childNodeWithName:@"MTGhostIconNode"] tapGesture:nil];
    [self.view.layer removeAllAnimations];
    [self.loading.superview bringSubviewToFront:self.loading];
    //[self.loading removeFromSuperview];
    ////NSLog(@"hiding");
    [UIView animateWithDuration:0.3 animations:^{
        self.loading.alpha=0;
        //self.loading.center=CGPointMake(512, 0);
    } completion:^(BOOL c){
        if(c){
            [self.loading clear];
       //[self.loading removeFromSuperview];
        self.loading=nil;
        }
    }];
}
-(void)showLoading{
    if(!self.loading){
        self.loading = [[MTLoadingView alloc]init];
        [self.view addSubview:self.loading];
        self.loading.frame=self.view.frame;
        self.loading.clipsToBounds=true;
        
    self.loading.center=CGPointMake(WIDTH/2, HEIGHT/2);
        ////NSLog(@">>>>>>>>> %f %f",self.view.center.x,self.view.center.y);
    [self.view bringSubviewToFront:self.loading];
    self.atlases = @[
                   
                     [SKTextureAtlas atlasNamed:@"Cars"],
                     [SKTextureAtlas atlasNamed:@"Sprites_SCENE"],
                     [SKTextureAtlas atlasNamed:@"SpritesJoystick"],
                     [SKTextureAtlas atlasNamed:@"HELP-SPRITES"]];
    
    
    [SKTextureAtlas preloadTextureAtlases:atlases  withCompletionHandler:^{
        [self finishLoadScene];
        //[self hideLoading];
    }];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [[MTAudioPlayer instanceMTAudioPlayer] play:@"background_code"];
    [MTStorage getNewInstance];
    [MTCategoryIconNode resetIcon];
    SKView *skView = (SKView *)self.view;
    
    //CGSize  s = skView.bounds.size;
    //if (HEIGHT<768){
    //    s = CGSizeMake(1024, 768);
        //HEIGHT=768;
    //}
    
    
        self.mainScene = [MTMainScene sceneWithSize:skView.bounds.size];
    NSLog(@"Creating scene :%@",self.mainScene);
        [skView presentScene:self.mainScene];
    [self.mainScene addChild:skf];
        self.mainScene.scaleMode = SKSceneScaleModeAspectFill;
        [UIApplication sharedApplication].statusBarHidden = YES;
        motionManager = [[CMMotionManager alloc] init]; //inicjalizacja obiektu obslugi sensorow (zyroskop)
        referenceAttitude = nil;
        NSArray* lista = [NSArray array];
        [self showLoading];
    
    
}

-(void)initinmenu{
    if(self.inmenu==nil){
    ////NSLog(@"1.1 viewWillLayoutSubviews Aktualny CFGetRetainCount>>%d",CFGetRetainCount((__bridge CFTypeRef)self));
        self.inmenu = [[MTINMenuView alloc]initWithScene:self.scene];
        self.inmenu.delegate=self;
        ////NSLog(@"1.2 viewWillLayoutSubviews Aktualny CFGetRetainCount>>%d",CFGetRetainCount((__bridge CFTypeRef)self));
        [self.view.superview addSubview:self.inmenu];
        [self.view bringSubviewToFront:self.inmenu];
        [self.inmenu hideMenuAnimated:NO];
        self.inmenu.center= CGPointMake(self.inmenu.center.x,self.inmenu.center.y-50);

        //[self.inmenu hideMenuAnimated:YES];
        [UIView animateWithDuration:1.0 animations:^{
            self.inmenu.center= CGPointMake(self.inmenu.center.x,self.inmenu.center.y+50);

        } completion:nil];
    }
   
    //self.inmenu.center=CGPointMake(1000, 500);
}
/*
 * Inicjalizacja żyroskopu co żądany czas w setnych sekundy.
 * wykorzystuje wbudowany w język moduł obsługi sensorów do odczytania surowych danych z żyroskopy.
 * Aktywuje wątek, który co żądany czas zapisuje w ustalonych zmiennych przetworzone dane.
 */
-(void) startGyroUpdateWithDurationPerSecound: (CGFloat)duration {
    
    [motionManager startDeviceMotionUpdates];
    [motionManager startGyroUpdates];
    timer = [NSTimer scheduledTimerWithTimeInterval:1/duration
                                             target:self
                                           selector:@selector(doGyroUpdate)
                                           userInfo:nil 
                                            repeats:YES];
    [self addTimer:timer];


}

/*
 * Wyłączenie obsługi żyroskopu. Wywołanie w stopSimulation z MTExecutora celem mniejszego obciążenia systemu. Żyroskop nie jest potrzebny w czasie edycji.z
 */
-(void) stopGyroUpdate{
    
    [motionManager stopDeviceMotionUpdates];
    [motionManager stopGyroUpdates];
    [timer invalidate];

}

/*
 * Funkcja wywoływania co określony czas celem aktualizacji i przetwarzania danych z żyroskopu.
 * Uruchamiania w oddzielnym wątku przez startGyroUpdateWithDurationPerSecound
 */
-(void) doGyroUpdate
{
    CMDeviceMotion *deviceMotion = motionManager.deviceMotion;
    CMAttitude *attitude = deviceMotion.attitude;
    
    float rate = motionManager.gyroData.rotationRate.z;
	if (fabs(rate) > .2) {
		self.gyroDirection = rate > 0 ? 1 : -1;
		self.gyroRotation = degrees(attitude.pitch);
		//self.rotation += self.direction * M_PI/90.0;
       // ////NSLog(@"\n\tgyroDirection: %f\n\tgyroRotation: %f",self.gyroDirection, self.gyroRotation);
	}
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
   /* if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

//-(void)loadScene:(NSDictionary*)scene{
    //[self showLoading];
    
//}

-(void)finishLoadScene{
    if (self.scene){
        [[MTArchiver getNewInstance] setScene: self.scene];
        
        if ([self.scene[@"file"] hasPrefix:@"sandbox://"]){//normalna
            [self loadStage:[((NSString*)self.scene[@"file"]) substringFromIndex:10]];
        }else if ([self.scene[@"file"] hasPrefix:@"task://"]){
            
            [self loadStage:((NSString*)self.scene[@"local_file"]) ];
            
            
        }else if ([self.scene[@"file"] hasPrefix:@"icloud://"]){ //tymczasowa z icloud (nie będzie savea.
            [self loadStage:((NSString*)self.scene[@"local_file"]) ];
        }else if ([self.scene[@"file"] hasPrefix:@"saved://"]){ //zapisana
            [self loadStage:((NSString*)self.scene[@"local_file"]) ];
        }
    }
}

-(void)loadStage:(NSString*)fname{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        [[MTArchiver getInstance] setFilename: fname];
        [[MTArchiver getInstance] decodeStorage];
        
        if([self.scene[@"file"] hasPrefix:@"task://"]){
            
            [[MTStorage getInstance] setProjectType:MTProjectTypeQuest];
        }
        
        if([self.scene[@"file"] hasPrefix:@"learn://"]){
            [[MTStorage getInstance] setProjectType:MTProjectTypeLearn];
        }

        
        if([self.scene[@"file"] hasPrefix:@"sandbox://"]){
            [MTHelpView setHelpAllowed:YES];
        }else{
            [MTHelpView setHelpAllowed:NO];
            
        }

        if([self.scene[@"file"] hasPrefix:@"shared://"]){
            
            [[MTStorage getInstance] setProjectType:MTProjectTypeShared];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //PRepARE GUI Z LISTĄ!!!
            if([self.scene[@"file"] hasPrefix:@"task://"] || [self.scene[@"file"] hasPrefix:@"learn://"]){
                
                [self performSelector:@selector(showHelp) withObject:nil afterDelay:1.0];
                [(MTMainScene *) self.mainScene prepareGUI:[MTWebApi decodeList:self.scene[@"local_limits"]]];
            }
            else if([self.scene[@"file"] hasPrefix:@"learn://"]){
                 [(MTMainScene *) self.mainScene prepareGUI:[MTWebApi decodeList:self.scene[@"local_limits"]]];
                
            }else{
                [(MTMainScene *) self.mainScene prepareGUI];
            }
            if(self!=nil){
                [self hideLoading];
            }
           [[MTNotSandboxProjectOrganizer getInstance] calculateCartsInCategories];
           [[MTNotSandboxProjectOrganizer getInstance] prepareCategoryIconsForTab:0];

           //[self performSelector:@selector(hideLoading) withObject:nil afterDelay:1.0];
           
        });
    });
    }

-(void)showINMenu{
    
}

-(void) addTimer:(NSTimer*)t{
    [self.timers addObject:t];
}






-(void)showHelp{
    if(! [@"" isEqualToString:self.scene[@"task"]]){
        //startowy ekran zadania.
        bool aktdone = [[NSUserDefaults standardUserDefaults] boolForKey:self.scene[@"task"]];
        NSString * image = self.scene[@"local_task"];
        
        
        MTObjectiveView * ov = [[MTObjectiveView alloc]initWithFrame:self.view.frame];
        [ov setImage:image];
        [self.view.superview addSubview:ov];
        
        [ov showMainScreenHelp];
        self.helpTimerCounter=300;
        //help.delegate=self;
    }
    
}

-(void)removeHelp{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.help.alpha=0;
    } completion:^(BOOL b){
        [self.help removeFromSuperview];
        self.help=nil;
    }];
}



-(void)showBlock{
    if(!blockview){
        blockview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"WAIT"]];
        [self.view.superview addSubview:blockview];
        blockview.frame = self.view.frame;
    blockview.alpha=0.0;
    [UIView animateWithDuration:0.3 animations:^{
        blockview.alpha=1.0;
    } completion:^(BOOL b){
        
    }];
    }
}

-(void)hideBlock{
    
    [UIView animateWithDuration:0.3 animations:^{
        blockview.alpha=0.0;
    } completion:^(BOOL b){
        [self.blockview removeFromSuperview];
        self.blockview=nil;
    }];
}













-(void)showVictory:(NSString*) costumeName{
    //[[MTExecutor getInstance] stopSimulation];
    //WYGRANA. ODBLOKOWANIE POZIOMU!!!
    if(!self.gameOverScreen){
        self.gameOverScreen = [[MTGameOverView alloc]initWithWin:YES andGhost:costumeName];
        [self.view.superview addSubview:self.gameOverScreen];
        self.gameOverScreen.delegate=self;
        [self.gameOverScreen show];
        MTMainScene * mtms = (MTMainScene *) self.mainScene;
        [mtms.sceneAreaNode simulationEnd];
    }
    if ([self.scene[@"file"] hasPrefix:@"task://"]){
        //jeśli jest task, to zapisz informacje o ukończenieu.
        
        [[MTWebApi getInstance]saveFinished:self.scene[@"file"]];
        [[MTWebApi getInstance]saveFinished:self.scene[@"opening_level_set"]];//tutaj nr zestawu, który ma zostać otwarty po ukończeniu. np @"2";
        
    }
}


-(void)showGameOver:(NSString*) costumeName{
    //  [[MTExecutor getInstance] stopSimulation];
    if(!self.gameOverScreen){
    self.gameOverScreen = [[MTGameOverView alloc]initWithWin:NO andGhost:costumeName];
    [self.view.superview addSubview:self.gameOverScreen];
        self.gameOverScreen.delegate=self;
    [self.gameOverScreen show];
        
        MTMainScene * mtms = (MTMainScene *) self.mainScene;
        [mtms.sceneAreaNode simulationEnd];
    }
    
}
-(void)hide{
    self.gameOverScreen=nil;
}

-(void)checkHelp{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL v = [defaults boolForKey:@"autohelp"];
    
    if(!v){
        self.helpTimerCounter+=1;

    if(self.helpTimerCounter==60){
        [self insertAutoHelpView];
    }}
    
}

-(void)startHelp{
    if(![MTWebApi getSchool]){
    MTHelpView * help = [[MTHelpView alloc]initWithFrame:self.view.frame];
    [help showMainScreenHelp];
    [self.view.superview addSubview:help];
    self.helpTimerCounter=300;
        help.delegate=self;}
}
-(void)resetHelpTimerCounter{
    self.helpTimerCounter=0;
    self.m_testView=nil;
}
//Wstawianie autopomocy.
-(void)insertAutoHelpView{
    if(![MTWebApi getSchool]){
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL v = [defaults boolForKey:@"autohelp"];
    if([MTHelpView isHelpAllowed])
    if(!v)
    if(![[MTAudioPlayer instanceMTAudioPlayer] isHelpPlaying])
    if(!m_testView){
        
        m_testView = [[TestView alloc] initWH];
        [self.view.superview addSubview:m_testView];
        [m_testView show];
   
        [m_testView startCountdown];
        m_testView.center=CGPointMake(68,700);
        m_testView.g=self;
    }
    }
}

-(void)unwindForSegue:(UIStoryboardSegue *)unwindSegue towardsViewController:(UIViewController *)subsequentVC
{
    ////NSLog(@"-------<");
}


-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"Zamykanie");
    SKView *skView = (SKView *)self.view;
    SKNode * root = [self.mainScene.scene childNodeWithName:@"MTRoot"];
    //USUWANIE Z NOTIFICATION CENTER! 
        MTCodeAreaNode * can = (MTCodeAreaNode*)[root childNodeWithName:@"MTCodeAreaNode"];
        [can deNotify];
        [[MTExecutor getInstance]remove];
        [[MTGhostIconNode getSelectedIconNode] remove];
    
    //[MTArchiver clear];
    [MTOfflineData clear];
    [MTGlobalVar clear];
    [MTExecutor clear];
    [MTGoXYCartOptions clear];
    [MTUserStorage clear];
    [MTStrategyOfSimultanousPinchRotateGestures clear];
    [MTStrategyOfSimultanousPanPinchRotateGestures clear];
    [MTStrategyOfSimultanousNoneGestures clear];
    [MTStrategyOfAvailabilityNoneGestures clear];
    [MTStrategyOfAvailabilityAllGestures clear];
    [MTStorage clear];
    [MTShotCartsOptions clear];
    [MTRotationCartOptions clear];
    [MTOfflineData clear];
    [MTMoveCartsOptions clear];

    //KONIEC
    
    [skView presentScene:nil];
    self.mainScene=nil;
    myViewControllerInstance=nil;
    [NSNotificationCenter defaultCenter];
}

@end
