//
//  MTCompilationIconNode.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 19.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTExecutionIconNode.h"
#import "MTMainScene.h"
#import "MTSceneAreaNode.h"
#import "MTStorage.h"
#import "MTExecutor.h"
#import "MTArchiver.h"
#import "MTGUI.h"
#import "MTViewController.h"


/*KONFIGURACJA CZASOWEJ ANIMACJI BEZCZYNNOSCI
 STANOWI PRZYKLAD ZASTOSOWANIA - SZCZEGOLOWY OPIS DZIALANIA*/

/*Zbior tekstur do animacji idleTexture*/
#define IDLE_TEXTURES @[ \
    [SKTexture textureWithImageNamed:@"var1.png"], \
    [SKTexture textureWithImageNamed:@"var2.png"], \
    [SKTexture textureWithImageNamed:@"var3.png"], \
    [SKTexture textureWithImageNamed:@"hak.png"]]

/*Czas pojedynczego efektu*/
#define TIME_PER_FRAME 2

/*Po ilu sekundach pierwszy efekt*/
#define FIRST_IDLE 10

/*Modulo dla RANDOM_IDLE*/
 #define RAND_MOD 30

/*Typ animacji:
 1 - texturowa
 2 - blending
 */
#define IDLE_ANIM_TYPE 2

@implementation MTExecutionIconNode

-(id) init{
    if (self = [super init])
    {
        self.name = @"MTExecutionIconNode";
        self.texture = [SKTexture textureWithImageNamed:@"hak.png"];
        self.anchorPoint = CGPointMake(0, 0);
        self.size = CGSizeMake(GHOST_BAR_WIDTH, GHOST_BAR_WIDTH * 2);
        
        /*Poczatek sekcji animacji bezczynnosci*/
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 //jedna sekunda
                                                      target:self
                                                    selector:@selector(refreshIdleTime)
                                                    userInfo:nil
                                                     repeats:YES];
        [[MTViewController getInstance] addTimer:self.timer];
        self.idleTime = 0;
        self.randomTime = FIRST_IDLE;
        
        /*Koniec sekcji animacji bezczynnosci*/
    }
    
    return self;
}
-(void) tapGesture:(UIGestureRecognizer *)g
{
    
}
-(void) panGestureOK:(UIGestureRecognizer *)g
{
    SKNode * root = [ self.scene childNodeWithName:@"MTRoot"];
    SKAction * act = [SKAction moveByX: CODE_AREA_WIDTH+CATEG_BAR_WIDTH - root.position.x y:0.0 duration:0.2 ];
    //TUTAj przesuniecie na scene...
    
    MTSceneAreaNode *scene = (MTSceneAreaNode *) [root childNodeWithName:@"MTSceneAreaNode"];
    [scene saveRepresentationNodes];
    [[MTArchiver getInstance]encodeStorage];
    [[MTArchiver getInstance]saveSnapshot:self.scene.view];
    
    [root runAction:act completion:^{
       
         [(MTMainScene *)self.scene prepareSimultaneousPinchRotate];
         [[MTExecutor getInstance] executeCode];
        }
    ];
    
    self.idleTime = 1;
    
}
-(void) panGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    CGPoint newPosition = [self newPositionVerticallyWithGesture:g inView:v inReferenceTo:self.parent];
    
    if(newPosition.y > HEIGHT/6*5-40)
    {
        self.position = [self newPositionVerticallyWithGesture:g inView:v inReferenceTo:self.parent];
    }
    
    if(newPosition.y<HEIGHT/6*5){
        self.texture = [SKTexture textureWithImageNamed:@"hak2.png"];
    }else{
        self.texture = [SKTexture textureWithImageNamed:@"hak.png"];
    }
    
    if (g.state == UIGestureRecognizerStateEnded)
    {
        if(newPosition.y < HEIGHT/6*5)
        {
            [self runAction: [SKAction moveTo:CGPointMake(0, HEIGHT-109) duration:0.2] completion:^(){
             self.texture = [SKTexture textureWithImageNamed:@"hak.png"];
            }];
        [self panGestureOK:g];
        }else{
            [self runAction: [SKAction moveTo:CGPointMake(0, HEIGHT-109) duration:0.3]];        }
    }
    
    self.idleTime = 1;
}

/*Funkcja odpowiedzialna za "odpalenie" animacji bezczynnosci*/
-(void) refreshIdleTime
{
    //////NSLog(@"IDLE: %f RANDOM: %f", self.idleTime, self.randomTime);

    MTExecutor *executor = [MTExecutor getInstance];
    
    
    /*sekcja definiowania animacji*/
    SKAction *idleTexture = [SKAction animateWithTextures:IDLE_TEXTURES timePerFrame:TIME_PER_FRAME];
    
    SKAction *idleColorBlend1 = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:0.4 duration:TIME_PER_FRAME/2];
    SKAction *idleColorBlend2 = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:0.0 duration:TIME_PER_FRAME/2];
    SKAction *idleColorBlend = [SKAction sequence:@[idleColorBlend1, idleColorBlend2, idleColorBlend1, idleColorBlend2]];
    
    /*sekcja liczenia czasu*/
    if(!executor.simulationStarted)
        self.idleTime = self.idleTime + 1;
    
    /*sekcja uruchamiania animacji*/
    if (self.idleTime >= self.randomTime)
    {
        /*nalezy pamietac aby w przypadku uzycia elementu/obiektu "zerowac" ta zmienna*/
        self.idleTime = 1;
        
        /*sekcja wyboru animacji i jej uruchomienia*/
        if (IDLE_ANIM_TYPE == 1)
            [self runAction:idleTexture];
        
        if (IDLE_ANIM_TYPE == 2)
            [self runAction:idleColorBlend];
        
        /*sekcja losowania kolejnego czasu bezczynnosci - zeby nie bylo monotonne*/
        self.randomTime = rand()%RAND_MOD;
        if (self.randomTime < TIME_PER_FRAME*4+4)
            self.randomTime = self.randomTime + TIME_PER_FRAME*2+5;
    }
}
@end
