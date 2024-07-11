//
//  MTHelpView.m
//  MagicTrains
//
//  Created by Blazej Zyglarski on 20.02.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//



#import "MTHelpView.h"
#import "MTAudioPlayer.h"
#import "MTGUI.h"
#import "MTWebApi.h"

@interface MTHelpView ()
@property SKScene* mainScene;
@property SKEmitterNode* emitter;
@property SKSpriteNode * shadow;
@property SKSpriteNode * face;

@property SKSpriteNode * HELPSTAR;
@property float degrees;

@end
@implementation MTHelpView
@synthesize mainScene;
@synthesize emitter;
@synthesize delegate;
@synthesize shadow;
@synthesize face;
@synthesize HELPSTAR;
@synthesize degrees;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
static int value;
static int old;

static BOOL isAllowedHelp = false;
static BOOL isAllowedHelpOld = false;

+ (int) helpScreen
{ @synchronized(self) { return value; } }
+ (void) setHelpScreen:(int)val
{ @synchronized(self) { old=value; value = val; } }
+ (void) revert
{ @synchronized(self) {value=old; } }

+ (void) revertHelpAllowed
{ @synchronized(self) {isAllowedHelp=isAllowedHelpOld; } }

+ (BOOL) isHelpAllowed
{ @synchronized(self) { return isAllowedHelp && (! [MTWebApi getSchool]); } }
+ (void) setHelpAllowed:(BOOL)val
{ @synchronized(self) {isAllowedHelpOld  = isAllowedHelp;  isAllowedHelp  = val; } }


-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    
        [self setAllowsTransparency:YES];
        //self.scene = [[SKScene alloc]initWithSize:self.frame.size];
        mainScene = [SKScene sceneWithSize:self.frame.size];
        mainScene.physicsWorld.gravity=CGVectorMake(0.0, 0.0);
    
        [mainScene setBackgroundColor:[UIColor clearColor]];
        [self presentScene:mainScene];
    
        [self presetHelp];
    
    UISwipeGestureRecognizer*g=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gest:)];
    g.direction=UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:g];
    
    
    return self;
}


-(void)gest:(UITapGestureRecognizer*)g{
    [self endTalk];
}

-(void)endTalk{
    [UIView animateWithDuration:0.5 animations:^{
        self.center= CGPointMake(self.center.x-self.frame.size.width, self.center.y);
        self.alpha=0.0;
        if(delegate)[delegate resetHelpTimerCounter];
        [[MTAudioPlayer instanceMTAudioPlayer]stopHelp];
    } completion:^(BOOL b){
        [mainScene removeAllChildren];
        [self presentScene:nil];
//        self.scene = nil;
        self.mainScene=nil;
        [self removeFromSuperview];
      
    }];
}

-(void)rotateSatrs{
    self.degrees +=0.01;
    if (self.degrees==360)self.degrees=1;
    
  //  [self.HELPSTAR setZRotation:self.degrees];
    
    //self.star2.transform = CGAffineTransformMakeRotation(-self.degrees * M_PI/180);
}

-(void) update:(CGFloat)v{
    //////NSLog(@">>>>>%f",v);
    @try{
    if(self && self.face){
    [self.face setTexture:[SKTexture textureWithImageNamed:@"face_mowi_1"]];
    if(v>-10){[self.face setTexture:[SKTexture textureWithImageNamed:@"face_mowi_6"]];}
    else{
    if(v>-13){[self.face setTexture:[SKTexture textureWithImageNamed:@"face_mowi_5"]];}
    else{
        if(v>-16){[self.face setTexture:[SKTexture textureWithImageNamed:@"face_mowi_4"]];}
        else{
            if(v>-19){[self.face setTexture:[SKTexture textureWithImageNamed:@"face_mowi_3"]];}
            else{
                if(v>-22){[self.face setTexture:[SKTexture textureWithImageNamed:@"face_mowi_2"]];}
                else{
                    if(v>-26){[self.face setTexture:[SKTexture textureWithImageNamed:@"face_mowi_4"]];}
                    else{
                        [self.face setTexture:[SKTexture textureWithImageNamed:@"face_mowi_1"]];
                    }
                }
            }        }
     }
     }
    }
    }@catch(NSException*e){
        
    }
}


-(void) animateHelp:(int)sc{
    
    NSDictionary * elements=[NSDictionary dictionary];
    
    
    switch (sc) {
              //Scena   Czas  : Miejsce
        case 19:  //main-scene
            elements = @{@0.0 : [NSValue valueWithCGPoint:CGPointMake(510, 352)],
                         @2.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH/2, HEIGHT-30)],
                         @17.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-30, HEIGHT/2)],
                         @22.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-30, 30)],
                         @27.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-30, HEIGHT/2)],
                         @32.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH/2, HEIGHT/2)],
                         @39.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH/2, HEIGHT/2)]};
            break;
        case 14:  //desktop-empty
            elements = @{@0.0 : [NSValue valueWithCGPoint:CGPointMake(30, HEIGHT-100)],
                         @8.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-30, HEIGHT-30)],
                         @21.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH/2, HEIGHT/2)],
                         @25.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-30, HEIGHT-30)],
                         @32.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH/2, HEIGHT/2)],
                         @42.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH/3, HEIGHT-30)],
                         @45.0 : [NSValue valueWithCGPoint:CGPointMake((WIDTH*2/3), HEIGHT-30)]};
            break;
        case 15:  //desktop-nonempty
            elements = @{@0.0 : [NSValue valueWithCGPoint:CGPointMake(30, HEIGHT-30)],
                         @10.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH/2, HEIGHT/2)],
                         @16.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-30, HEIGHT/2)]
                         };
            break;
        case hs_cars1:  //cars1 = locomotives library
            elements = @{@0.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-400, HEIGHT-60)],
                         //@7.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-300, HEIGHT-60)],
                         @7.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-200, HEIGHT-60)],
                         @10.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-100, HEIGHT-60)],
                         
                         @13.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-400, HEIGHT-180)],
                         @16.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-300, HEIGHT-180)],
                         @19.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-200, HEIGHT-180)],
                         @22.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-100, HEIGHT-180)],

                         @24.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-400, HEIGHT-300)],
                         @28.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-300, HEIGHT-300)],
                         @31.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-200, HEIGHT-300)],
                         @35.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-100, HEIGHT-300)],
                         
                         @39.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-400, HEIGHT-420)],
                         @42.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-300, HEIGHT-420)],
                         @45.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-200, HEIGHT-420)],
                         @48.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-100, HEIGHT-420)],
                         
                         @51.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-400, HEIGHT-540)],
                         @54.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-300, HEIGHT-540)],
                         @57.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-200, HEIGHT-540)]
                         
                         
                         };
            break;
        case hs_cars2:  //cars1 = locomotives library
            elements = @{@4.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-400, HEIGHT-60)],
                         @7.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-300, HEIGHT-60)],
                         @8.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-200, HEIGHT-60)],
                         @9.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-100, HEIGHT-60)],
                         
                         @10.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-400, HEIGHT-180)],
                         @12.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-300, HEIGHT-180)],
                         @14.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-200, HEIGHT-180)],
                         @16.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-100, HEIGHT-180)],
                         
                         @18.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-400, HEIGHT-300)],
                         @20.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-300, HEIGHT-300)],
                         @22.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-200, HEIGHT-300)],
                         @24.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-100, HEIGHT-300)],
                         
                         @27.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-400, HEIGHT-420)]
                         
                         };
            break;
            
        case hs_cars3:  //cars1 = locomotives library
            elements = @{@0.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-400, HEIGHT-60)],
                         @7.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-300, HEIGHT-60)]
                         
                         };
            break;

            
        case hs_cars4:  //cars1 = locomotives library
            elements = @{@3.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-400, HEIGHT-60)],
                         @6.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-300, HEIGHT-60)],
                         @8.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-200, HEIGHT-60)],
                         @10.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-100, HEIGHT-60)],
                         
                         @12.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-400, HEIGHT-180)],
                         @14.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-300, HEIGHT-180)],
                         @16.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-200, HEIGHT-180)],
                         @20.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-100, HEIGHT-180)]
                         
                         };
            break;
        case hs_cars5:  //cars1 = locomotives library
            elements = @{@4.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-400, HEIGHT-60)],
                         @7.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-300, HEIGHT-60)],
                         @8.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-200, HEIGHT-60)],
                         @10.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-100, HEIGHT-60)],
                         
                        // @12.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-400, HEIGHT-180)],
                         @12.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-300, HEIGHT-180)],
                        // @14.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-200, HEIGHT-180)],
                        // @16.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-100, HEIGHT-180)],
                         
                         @17.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-400, HEIGHT-300)],
                        // @20.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-300, HEIGHT-300)],
                         @21.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-200, HEIGHT-300)],
                         //@24.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-100, HEIGHT-300)],
                         
                         @25.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-400, HEIGHT-420)],
                         @30.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-200, HEIGHT-420)]
                         
                         };
            break;

        case hs_cars6:  //cars1 = locomotives library
            elements = @{@4.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-400, HEIGHT-60)],
                         @5.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-300, HEIGHT-60)],
                         @6.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-200, HEIGHT-60)],
                         @7.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-100, HEIGHT-60)],
                         
                         @8.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-400, HEIGHT-180)]
                         
                         
                         };
            break;
            
        case hs_cars7:  //cars1 = locomotives library
            elements = @{@0.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-350, HEIGHT-60)],
                         @4.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-100, HEIGHT-60)]
                         //@6.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-100, HEIGHT-60)],
                         //@7.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-100, HEIGHT-60)],
                         
                         //@8.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-400, HEIGHT-180)]
                         
                         
                         };
            break;

        
            
        case hs_characters:  //cars1 = locomotives library
            elements = @{@0.0 : [NSValue valueWithCGPoint:CGPointMake(450, HEIGHT-150)],
                         @13.0 : [NSValue valueWithCGPoint:CGPointMake(450, 150)],
                         @19.0 : [NSValue valueWithCGPoint:CGPointMake(300, HEIGHT/2)],
                         @23.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-200, 100)],
                         @25.0 : [NSValue valueWithCGPoint:CGPointMake(WIDTH-100, 300)],
                         @30.0 : [NSValue valueWithCGPoint:CGPointMake(100, HEIGHT/2)]
                         
                         
                         };
            break;
default:
            break;
    }
    
   
    
    [elements enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        float klucz = [(NSNumber*)key floatValue];
        if(self.superview != nil){
            [self performSelector:@selector(highlight:) withObject:obj afterDelay:0.5+klucz];
        }
    }];
    
}


-(void) presetHelp{
    
    //[[MTAudioPlayer instanceMTAudioPlayer] fadeInBackgroundSilent];
    
    
    [[MTAudioPlayer instanceMTAudioPlayer] playHelp:MTHelpView.helpScreen witDelegate:self];
    [self animateHelp:MTHelpView.helpScreen];
    
    
    SKSpriteNode * HELPSHADOW = [SKSpriteNode spriteNodeWithImageNamed:@"HELP_SHADOW_LEFT"];
    SKSpriteNode * HELP_LIGHT = [SKSpriteNode spriteNodeWithImageNamed:@"HELP_LIGHT_LEFT"];
    HELPSTAR = [SKSpriteNode spriteNodeWithImageNamed:@"HELP_LIGHT_LEFT"];
    SKSpriteNode * ghost = [SKSpriteNode spriteNodeWithImageNamed:@"CIUCIU"];
    self.face = [SKSpriteNode spriteNodeWithImageNamed:@"face_mowi_1"];
    //self.shadow =[SKSpriteNode spriteNodeWithImageNamed:@"CIUCIU_SHADOW"];

    
    
    [HELP_LIGHT runAction:
     [SKAction repeatActionForever:
      [SKAction animateWithTextures:@[
                                      [SKTexture textureWithImageNamed:@"HELP_LIGHT_LEFT"],
                                      [SKTexture textureWithImageNamed:@"HELP_LIGHT_LEFT3"],
                                      [SKTexture textureWithImageNamed:@"HELP_LIGHT_LEFT2"],
                                    ] timePerFrame:3.0]]];
    
    
    
      /* [face runAction:
     /*[SKAction repeatActionForever:
      /*[SKAction animateWithTextures:@[
                                      [SKTexture textureWithImageNamed:@"face_mowi_1.png"],
                                      [SKTexture textureWithImageNamed:@"face_mowi_1.png"],
                                      [SKTexture textureWithImageNamed:@"face_mowi_2.png"],
                                      [SKTexture textureWithImageNamed:@"face_mowi_2.png"],
                                      [SKTexture textureWithImageNamed:@"face_mowi_2.png"],
                                      [SKTexture textureWithImageNamed:@"face_mowi_2.png"],
                                      [SKTexture textureWithImageNamed:@"face_mowi_3.png"],
                                      [SKTexture textureWithImageNamed:@"face_mowi_3.png"],
                                      [SKTexture textureWithImageNamed:@"face_mowi_2.png"],
                                      [SKTexture textureWithImageNamed:@"face_mowi_2.png"],
                                      [SKTexture textureWithImageNamed:@"face_mruga_2.png"],
                                      [SKTexture textureWithImageNamed:@"face_mruga_2.png"],
                                      [SKTexture textureWithImageNamed:@"face_mowi_1.png"],
                                      [SKTexture textureWithImageNamed:@"face_mowi_1.png"],
                                      [SKTexture textureWithImageNamed:@"face_mowi_1.png"],
                                      [SKTexture textureWithImageNamed:@"face_mowi_1.png"]
                                      ] timePerFrame:0.1]]];*/
    [ghost addChild:face];
    face.size= ghost.size;
    [ghost setScale:0.4];
    [ghost setZPosition:1.0];
    [HELPSTAR setScale:0.8];
    //[HELPSHADOW setScale:0.5];
    //[HELP_LIGHT setScale:0.5];
    
  //  [NSTimer scheduledTimerWithTimeInterval:1/60 target:self selector:@selector(rotateSatrs) userInfo:nil repeats:YES];

    //[self.mainScene addChild:shadow];
    [self.mainScene addChild:HELPSHADOW];
    [self.mainScene addChild:HELP_LIGHT];
    [self.mainScene addChild:HELPSTAR];
    [self.mainScene addChild:ghost];
    ghost.position=CGPointMake(170, 180);
    HELPSHADOW.position=CGPointMake(1024/2, 768/2);
    HELP_LIGHT.position=CGPointMake(1024/2, 768/2+50);
    HELPSTAR.position=CGPointMake(200, 450);
    
    //shadow.size=CGSizeMake(2000, 500);
    //shadow.scale=2;
    //shadow.anchorPoint=CGPointMake(100, 100);
   // shadow.position=CGPointMake(200, 450);
   // [shadow setAlpha:0.2];
   // [shadow setBlendMode:SKBlendModeAdd];
    [HELPSTAR setAlpha:0.1];
    
    
    [self highlight2:CGPointMake(170, 180)];
    
    [ghost runAction:[SKAction repeatActionForever:[SKAction sequence:@[
                                        [SKAction group:@[[MTHelpView jumpWithStartPoint:CGPointMake(160, 180) endPoint:CGPointMake(180, 180) height:20],[SKAction rotateToAngle:0.1 duration:0.2]]]
                                          ,
                                          [SKAction waitForDuration:5],
                                        [SKAction group:@[[MTHelpView jumpWithStartPoint:CGPointMake(180, 180) endPoint:CGPointMake(160, 180) height:15],[SKAction rotateToAngle:-0.1 duration:0.2]]]
                                        
                                          ]]]];
    

    
}

-(void) highlight:(NSValue* )v{
    CGPoint c = [(NSValue*)v CGPointValue];
    c = CGPointMake(c.x-50, c.y-50);
    void (^b)(void);
    b = ^{
        NSString *firePath = [[NSBundle mainBundle] pathForResource:@"MyParticleM" ofType:@"sks"];
        emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:firePath];
        [self.mainScene addChild:emitter];
        [emitter setTargetNode:self.mainScene];
        [emitter setPosition:c];
        [emitter setZPosition:0];
        [emitter setAlpha:1.0];
        CGPathRef circle = CGPathCreateWithEllipseInRect(CGRectMake(0,0,100,100), NULL);
        SKAction *followTrack = [SKAction followPath:circle asOffset:YES orientToPath:YES duration:1.0];
        SKAction *forever = [SKAction repeatActionForever:[SKAction sequence:@[followTrack,[SKAction moveTo:c duration:0]]]];
        [emitter runAction:forever];
    };
    
    //[self.shadow runAction:[SKAction moveTo:c duration:0.3]];
    
    if(emitter){
        //[emitter removeFromParent];
        //b();
        [emitter runAction:[SKAction sequence:@[[SKAction fadeAlphaTo:0.0 duration:0.3],[SKAction removeFromParent],[SKAction runBlock:^{
            [emitter removeAllActions];
            
            b();
        
        }]]]];
    }else{
        b();
    }
    
}


-(void) highlight2:(CGPoint )c{
    //void (^b)(void);
    //b = ^{
        NSString *firePath = [[NSBundle mainBundle] pathForResource:@"Smoke" ofType:@"sks"];
        SKEmitterNode* emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:firePath];
        [self.mainScene addChild:emitter];
        [emitter setPosition:c];
        [emitter setZPosition:0];
        [emitter setAlpha:1.0];
   // };
    
   // [self.shadow runAction:[SKAction moveTo:c duration:0.3]];
    
   // if(emitter){
     //   [emitter runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.3 ],[SKAction runBlock:b],[SKAction removeFromParent]]]];
   // }else{
   //     b();
   // }
    
}

-(void) showMainScreenHelp{

    [self setAlpha:0.0];
    [UIView animateWithDuration:1 animations:^{
        [self setAlpha:1.0];
    }];
    
    
}

+ (SKAction *)jumpWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint height:(CGFloat)height {
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:startPoint];
    CGPoint peak = CGPointMake((endPoint.x + startPoint.x)/2, startPoint.y + height);
    [bezierPath addCurveToPoint:endPoint controlPoint1:peak controlPoint2:peak];
    
    SKAction *jumpAction = [SKAction followPath:bezierPath.CGPath asOffset:NO orientToPath:NO duration:.5f];
    jumpAction.timingMode = SKActionTimingEaseIn;
    return jumpAction;
}



+ (void) showInstantHelp:(NSString*)name icon:(NSString*)icon scenePosition:(CGPoint)p node:(SKSpriteNode *)s{
   //NSLog(@"IH %@_%@, [%f, %f]", name, icon, p.x,p.y);
    NSString* stringtoplay = [[NSString stringWithFormat:@"help_%@_%@_%@.aif",name,icon,[MTWebApi getLang]] stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
    
    NSLog(@"SP: %@",stringtoplay);
    
    NSString *pathForFile = [[NSBundle mainBundle] pathForResource:[[NSString stringWithFormat:@"help_%@_%@_%@",name,icon,[MTWebApi getLang]] stringByReplacingOccurrencesOfString:@"@2x" withString:@""] ofType:@"aif"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL playing = false;
    if ([fileManager fileExistsAtPath:pathForFile]){
        playing=true;
    }
    
    if(playing){
    NSString *firePath = [[NSBundle mainBundle] pathForResource:@"MySpark" ofType:@"sks"];
    SKEmitterNode* emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:firePath];
    [s addChild:emitter];
    
    CGPoint ap = CGPointMake(s.frame.size.width/2-s.anchorPoint.x*s.frame.size.width,s.frame.size.height/2- s.anchorPoint.y*s.frame.size.height);
    
    [emitter setPosition:ap];
    [emitter setZPosition:0];
    [emitter setAlpha:1.0];
    [emitter runAction:[SKAction sequence:@[[SKAction waitForDuration:1.0],[SKAction removeFromParent]]]];
    
    
    NSString *firePath2 = [[NSBundle mainBundle] pathForResource:@"MyMagicParticle2" ofType:@"sks"];
    SKEmitterNode* emitter2= [NSKeyedUnarchiver unarchiveObjectWithFile:firePath2];
    [s addChild:emitter2];
    
    CGPoint ap2 = CGPointMake(s.frame.size.width/2-s.anchorPoint.x*s.frame.size.width,s.frame.size.height/2- s.anchorPoint.y*s.frame.size.height);
    
    [emitter2 setPosition:ap];
    [emitter2 setZPosition:0];
    [emitter2 setAlpha:0.5];
    [emitter2 runAction:[SKAction sequence:@[[SKAction waitForDuration:1.0],[SKAction fadeAlphaTo:0.0 duration:3.0],[SKAction removeFromParent]]]];
    [s runAction:[SKAction sequence:@[[SKAction playSoundFileNamed:stringtoplay waitForCompletion:FALSE],[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:0.7 duration:2],[SKAction colorizeWithColorBlendFactor:0.0 duration:2]]]];
    
    
    SKSpriteNode * cat = [[SKSpriteNode alloc]initWithImageNamed:@"catpsd3"];
        [s addChild:cat];
    CGPoint ap3 = CGPointMake(s.frame.size.width/2-s.anchorPoint.x*s.frame.size.width-cat.frame.size.width/4,s.frame.size.height/2- s.anchorPoint.y*s.frame.size.height-cat.frame.size.height/4);
    [cat setPosition:ap3];
    cat.alpha = 0.0;
    [cat setScale:0.5];
    [cat runAction:[SKAction sequence:@[
                                        [SKAction fadeAlphaTo:1.0 duration:0.1],
                                        [SKAction repeatAction:[SKAction animateWithTextures:@[
                                                                                               [SKTexture textureWithImageNamed:@"catpsd1"],[SKTexture textureWithImageNamed:@"catpsd2"],[SKTexture textureWithImageNamed:@"catpsd3"],[SKTexture textureWithImageNamed:@"catpsd2"]
                                                                                               ] timePerFrame:0.1] count:3],
                                        [SKAction resizeToWidth:0.0 height:0.0 duration:0.1],
                                        [SKAction removeFromParent]
                                        
                                        ]]];
    }else{
        
    }

    
}

-(void)dealloc{
   //NSLog(@"Deallocking HelPView");
}
@end
