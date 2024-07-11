//
//  MTHelpView.m
//  MagicTrains
//
//  Created by Blazej Zyglarski on 20.02.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//



#import "MTObjectiveView.h"
#import "MTGui.h"
#import "MTAudioPlayer.h"

@interface MTObjectiveView ()
@property  SKScene* mainScene;
@property SKEmitterNode* emitter;
@property SKSpriteNode * shadow;
@property SKSpriteNode * face;

@property SKSpriteNode * HELPSTAR;
@property float degrees;

@end
@implementation MTObjectiveView
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

+ (int) helpScreen
{ @synchronized(self) { return value; } }
+ (void) setHelpScreen:(int)val
{ @synchronized(self) { old=value; value = val; } }
+ (void) revert
{ @synchronized(self) {value=old; } }

- (void) setImage:(NSString*)name{
    UIImage * u = [UIImage imageWithContentsOfFile:name];
    SKTexture * t = [SKTexture textureWithImage:u];
    SKSpriteNode* n = [SKSpriteNode spriteNodeWithTexture:t size:t.size];
    [n setScale:0.5];
    n.position=CGPointMake(1024/2, 768/2);
    
    [self.scene addChild:n];
}
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
    
    
}


-(void) presetHelp{
    
    //[[MTAudioPlayer instanceMTAudioPlayer] fadeInBackgroundSilent];
    
    
    
    SKSpriteNode * HELPSHADOW = [SKSpriteNode spriteNodeWithImageNamed:@"HELP_SHADOW_TASK"];
    SKSpriteNode * HELP_LIGHT = [SKSpriteNode spriteNodeWithImageNamed:@"HELP_LIGHT_LEFT"];
    HELPSTAR = [SKSpriteNode spriteNodeWithImageNamed:@"HELP_LIGHT_LEFT"];
    SKSpriteNode * ghost = [SKSpriteNode spriteNodeWithImageNamed:@"CIUCIU_HELP"];
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
                                                                        [SKAction group:@[[MTObjectiveView jumpWithStartPoint:CGPointMake(160, 180) endPoint:CGPointMake(180, 180) height:20],[SKAction rotateToAngle:0.1 duration:0.2]]]
                                                                        ,
                                                                        [SKAction waitForDuration:5],
                                                                        [SKAction group:@[[MTObjectiveView jumpWithStartPoint:CGPointMake(180, 180) endPoint:CGPointMake(160, 180) height:15],[SKAction rotateToAngle:-0.1 duration:0.2]]]
                                                                        
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
    [self.superview bringSubviewToFront:self];
    
    
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




@end
