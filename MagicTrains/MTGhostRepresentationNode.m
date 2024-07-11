//
//  MTGhostRepresentationNode.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.02.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//2


#import "MTGUI.h"
#import "MTSendSignalCart.h"
#import "MTGhostRepresentationNode.h"
#import "MTStateOfGhostRepresentationNode.h"
#import "MTTrain.h"
#import "MTGhost.h"
#import "MTGhostsBarNode.h"
#import "MTGhostIconNode.h"
#import "MTSceneAreaNode.h"
#import "MTGlowFilter.h"
#import <SpriteKit/SpriteKit.h>
#import "MTTrashNode.h"
#import "MTStorage.h"
#import "MTGhostRepresentationEffectNode.h"
#import "MTViewController.h"
#import "MTStateOfEditingGhostRepresentationNode.h"
#import "MTAudioPlayer.h"
#import "MTGhostDefaults.h"
#import "MTSignalNotificationNames.h"

#import "MTBlockingBackground.h"
#import "MTWindowAlert.h"
#import "MTSceneAreaNode.h"

//#import "SKSpriteNode+SNExt.h"
#import "SKTexture+MTTextureLoader.h"

#define N_Drawing_started @"DrawingStarted"
#define N_Drawing_ended @"DrawingEnded"

#define ARC4RANDOM_MAX 0x100000000

@interface MTGhostRepresentationNode ()

//@property NSMutableDictionary *variablesForTrains;
@property NSMutableArray *variablesForTrains;
@property int nothingHappened;
@property (weak) MTWindowAlert * alert;
@property NSMutableArray* costumeVisuals;
@property NSTimer * moodWatcher;
@property MTGhostRepresentationEffectNode * myEffect;
@property SKSpriteNode * shadow;
@property SKPhysicsBody * oPhysicsBody;
@property int dontMove;
@property CGPoint oldposition;
@property CGPoint oldposition2;

@property NSMutableArray*joints;

@end

@implementation MTGhostRepresentationNode;
@synthesize moodState;
@synthesize ghostName;
@synthesize oldposition2;
@synthesize shadow;
@synthesize costumeVisuals;
@synthesize nothingHappened;
@synthesize myEffect;
@synthesize oldposition;
@synthesize moodWatcher;
@synthesize oPhysicsBody;
@synthesize joints;
@synthesize dontMove;
@synthesize draw;
@synthesize massign;

static MTGhostRepresentationNode *selectedRepresentation;
static const uint32_t wall  =  0x1 << 0;
static const uint32_t ghost =  0x1 << 1;
 
-(id) init
{
    if (self = [super init]) {
        self.myFlags = [[MTGhostRepresentationEventFlags alloc]initWithGRN: self];
        self.deleted = false;
        self.massign = 1;
        self.affectByJoystick=true;
        self.name = @"MTGhostRepresentationNode";
        //self.texture = [SKTexture textureCachedWithImageNamed:@"TUX"];
        self.userClone = false;
        [self resetVariables];
        if(self.moodWatcher){
            [self.moodWatcher invalidate];
            self.moodWatcher=nil;
        }
        self.moodWatcher= [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(moodWatcherInvocation) userInfo:nil repeats:YES];
        [[MTViewController getInstance]addTimer:self.moodWatcher];
        //[self physicBodyForGhostRep: self width:self.size.width height: self.size.height scale:self.xScale];
        
        
    }
    return self;
}
-(id) initWithGhostInstance:(MTGhostInstance *)sourceInstance ghostIcon:(MTGhostIconNode *)icon
{
    self = [self init];//[self initWithImageNamed: sourceInstance.ImageName];
    self.myGhostInstance = sourceInstance;
    self.myGhostIcon = icon;
    self.affectByJoystick=true;

    
    [self resetMe];
    
    
    //ustawienia fizyki
    [self physicBodyForGhostRep: self width:self.size.width height: self.size.height scale:self.xScale];
    
    self.ghostName= [self.myGhostIcon.textureName substringToIndex:[self.myGhostIcon.textureName rangeOfString:@"_"].location];
    [self setupMoodVisuals:self.ghostName];
    self.moodState=0;
    [self setMoodState];
    
    [self goIntoStateOfEditing];
    
    MTSpriteMoodNode* v2 = [MTSpriteMoodNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(75, 75)];
    [self.myGhostIcon removeAllChildren];
    [self.myGhostIcon addChild:v2];
    [v2 setSize:CGSizeMake(50, 50)];
    SKAction* sk = [self.costumeVisuals objectAtIndex:0];
    [v2 runAction:sk];
    return (id) self;
}

-(id)initClone
{
    MTGhostRepresentationNode *newClone = [[MTGhostRepresentationNode alloc] initWithGhostInstance:self.myGhostInstance ghostIcon:self.myGhostIcon];

#if DEBUG_NSLog
    ////NSLog(@"Sklonowalem sie do %p", newClone);
#endif
    
    newClone.position = self.position;
    newClone.hp = self.hp;
    newClone.size = CGSizeMake(75,75);
    MTSpriteMoodNode* visual= (MTSpriteMoodNode* )[newClone.children firstObject];
    //MTSpriteMoodNode* visualo= (MTSpriteMoodNode* )[self.children firstObject];
    if(visual!=nil){
        visual.size=CGSizeMake(75,75);
        //visual.xScale=visualo.xScale;
        //visual.yScale=visualo.yScale;
        
    }
    newClone.xScale=self.xScale;
    newClone.yScale=self.yScale;
    newClone.userClone = true; //Jestem klonem stworzonym przez uzytkownika - sprawdzane przy wykonywaniu lokomotyw!
    newClone.zRotation = self.zRotation;
    self.zPosition+=1;
    newClone.myGhostIcon = self.myGhostIcon;
    
    //ustawienia fizyki
    [self physicBodyForGhostRep: newClone width:newClone.size.width height: newClone.size.height scale:newClone.xScale];
    
    newClone.moveXInSimulation = false;
    newClone.moveYInSimulation = false;
    newClone.affectByJoystick=true;
    
    int x = arc4random()%3-1;
    int y = arc4random()%3-1;
    
    if(x==0&y==0)x=1;
    newClone.position=CGPointMake(x/**(newClone.size.width/2)*/+newClone.position.x,y/*(newClone.size.height/2)*/+newClone.position.y);
    
    [newClone goIntoStateOfSimulation];
    
    return newClone;
    
}


-(void)startGravitating{
    //self.physicsBody.dynamic = false;
    SKFieldNode * skf = [SKFieldNode radialGravityField];
    skf.enabled=YES;
    skf.strength=0.2;
    skf.minimumRadius=10.0;
    skf.name = @"GravityField";
    [self addChild:skf];

}
-(void)stopGravitating{
    for(SKNode * s in self.children){
        if ([s isKindOfClass:[SKFieldNode class]] &&
            [[s name]isEqualToString:@"GravityField"]){
            [s removeFromParent];
        }
    }
}

-(void)startReverseGravitating{
    SKFieldNode * skf = [SKFieldNode radialGravityField];
    skf.enabled=YES;
    skf.strength=-0.2;
    skf.minimumRadius=10.0;
    skf.name = @"ReverseGravityField";
    [self addChild:skf];

}
-(void)stopReverseGravitating{
    for(SKNode * s in self.children){
        if ([s isKindOfClass:[SKFieldNode class]] &&
            [[s name]isEqualToString:@"ReverseGravityField"]){
            [s removeFromParent];
        }
    }

}
-(void) physicBodyForGhostRep: (MTGhostRepresentationNode*)rep  width:(CGFloat)width height: (CGFloat)height scale:(CGFloat) scale
{
    //NSString * dName = [rep.ghostName substringToIndex:[rep.ghostName rangeOfString:@"_"].location];
    int dnr = [[rep.ghostName substringFromIndex:1]intValue];
    if([[MTStorage getInstance] ghostCostumeIsSquare:dnr]){
        if(rep)
        rep.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(width*0.8, height*0.8)];
        //rep.oPhysicsBody=self.physicsBody;
    }else{
        if(rep)
            rep.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:width/2.7];
        //rep.oPhysicsBody=self.physicsBody;
    }
    
    rep.lightingBitMask = 1<<0;
    rep.shadowCastBitMask = 1<<0;
    rep.shadowedBitMask = 1<<0;
    
    
    /*if(!shadow){
    shadow = [SKSpriteNode spriteNodeWithTexture:rep.texture];
    shadow.blendMode = SKBlendModeAlpha;
    shadow.colorBlendFactor = 1;
    shadow.color = [SKColor blackColor];
    shadow.alpha = .25;
    shadow.size=rep.size;
        rep.position=CGPointMake(rep.position.x,rep.position.y-10);
        [rep addChild:shadow];
        shadow.zPosition=-1;
    }*/
    
    
    
    //rep.physicsBody = [SKPhysicsBody bodyWithTexture:rep.texture size:rep.size];
    rep.physicsBody.dynamic = YES;
    rep.physicsBody.categoryBitMask = ghost;
    rep.physicsBody.contactTestBitMask = ghost | wall;
    rep.physicsBody.collisionBitMask = ghost | wall;
    rep.physicsBody.usesPreciseCollisionDetection = NO;
    
    rep.physicsBody.affectedByGravity = YES;
    
    rep.physicsBody.mass =  [self.myGhostIcon.myGhost getScaledMass] * self.xScale;
    if (self.massign==-1){
        rep.physicsBody.fieldBitMask=8;
    }else{
        rep.physicsBody.fieldBitMask=1;
        
    }
    
    
    rep.physicsBody.restitution = 0.5;
    [rep.physicsBody applyForce:CGVectorMake(0, 0)];
    rep.physicsBody.velocity = CGVectorMake(0,0);
    [rep.physicsBody applyImpulse:CGVectorMake(0, 0)];
    
    //wylaczenie tarcia zderzenia sa bardziej plynne
    rep.physicsBody.friction = 0.7f;
    
    //odbijanie z taka sama sila, jak uderza
    rep.physicsBody.restitution = .4f;
    //spowalnianie przesuwania bo nastapilo tarcie
    rep.physicsBody.linearDamping = .7f;
}

-(void)goIntoStateOfEditing
{
    if(!self.physicsBody && self.texture){
    [self physicBodyForGhostRep: self width:self.size.width height: self.size.height scale:self.xScale];
    }
    
    [self stopGravitating];
    [self stopReverseGravitating];
    self.physicsBody.velocity = CGVectorMake(0,0);
    self.physicsBody.angularVelocity=0;
    MTGhost * myGhost = [self.myGhostInstance getMyGhost];
    if (![myGhost allowedTouching])
    {
      self.physicsBody.dynamic = NO;
      self.state = [MTStateOfGhostRepresentationNode getMTStateOfConstantGhostRepresentationNode];

    }else
    {
        self.physicsBody.dynamic=YES;
        self.state = [MTStateOfGhostRepresentationNode getMTStateOfEditingGhostRepresentationNode];
    }
       
#if DEBUG_NSLog
    ////NSLog(@"Edit");
#endif
    
}

-(void)goIntoStateOfSimulation
{
    self.state = [MTStateOfGhostRepresentationNode getMTStateOfSimulationGhostRepresentationNode];
    self.deleted = false;

#if DEBUG_NSLog
    ////NSLog(@"Sim");
#endif
}

-(void)goIntoStateOfConstant
{
    self.state = [MTStateOfGhostRepresentationNode getMTStateOfConstantGhostRepresentationNode];
    self.deleted = false;
    
#if DEBUG_NSLog
    ////NSLog(@"Constant");
#endif
    
}

-(MTGhostRepresentationNode *)getSelectedRepresentationNode
{
    return selectedRepresentation;
}

+(MTGhostRepresentationNode *)getSelectedRepresentationNode
{
    return selectedRepresentation;
}

+(void)resetSelectedRepresentationNode
{
    selectedRepresentation = nil;
}

-(void) getAttributesFromInstance
{
    
    MTSpriteNode *src = self.myGhostInstance.node;
    self.ghostName= [self.myGhostIcon.textureName substringToIndex:[self.myGhostIcon.textureName rangeOfString:@"_"].location];
    [self setupMoodVisuals:self.ghostName];
    
    self.position = CGPointMake(src.position.x, src.position.y);
    self.xScale = src.xScale;
    self.yScale = src.yScale;
    // zamiana na elegancki powrót do miejsc startowych.
    //[self runAction:[SKAction scaleXTo:src.xScale y:src.yScale duration:0.1]];
    //    [self runAction:[SKAction moveTo:CGPointMake( src.position.x , src.position.y) duration:0.4]];
    
    self.size = CGSizeMake(src.size.width,src.size.height);
    self.anchorPoint = CGPointMake(0.5, 0.5);
    self.zPosition = src.zPosition;
    self.zRotation = src.zRotation;
    self.texture = self.myGhostIcon.texture;
    self.moodState=0;
    [self setMoodState];
    self.hidden = false;
    self.hp = self.myGhostIcon.myGhost.hp;
    //self.physicsBody.mass=self.g
}

-(void) setAttributesToInstance
{
    MTSpriteNode *dst = self.myGhostInstance.node;
    self.ghostName= [self.myGhostIcon.textureName substringToIndex:[self.myGhostIcon.textureName rangeOfString:@"_"].location];
    [self setupMoodVisuals:self.ghostName];
    self.moodState=0;
    [self setMoodState];

    
    dst.position = CGPointMake( self.position.x, self.position.y);
    dst.xScale = self.xScale;
    dst.yScale = self.yScale;
    dst.size = CGSizeMake(self.size.width, self.size.height);
    dst.anchorPoint = CGPointMake(0.5, 0.5);
    dst.zPosition = self.zPosition;
    dst.zRotation = self.zRotation;
    //dst.physicsBody = self.physicsBody;
}


-(void) setupMoodVisuals:(NSString*) dName{
    int dnr = [[dName substringFromIndex:1]intValue];
    
    BOOL isSimple = [[MTStorage getInstance]getGhostDefaults:dnr].isSimple;
    
    ////NSLog(@"DN: %@",dName);
    self.costumeVisuals = [NSMutableArray array];
    
    
    NSMutableArray *textures_USMIECHNIETY = [NSMutableArray arrayWithCapacity:8];
    if(isSimple){
         textures_USMIECHNIETY = [NSMutableArray arrayWithCapacity:1];
        NSString *textureName = [NSString stringWithFormat:@"EMPTY"];
        SKTexture *texture = [SKTexture textureCachedWithImageNamed:textureName];
        [textures_USMIECHNIETY addObject:texture];
    }else{
    for (int i = 1; i <= 9; i++)
    {
        NSString *textureName = [NSString stringWithFormat:@"%@_USMIECHNIETY_%d",dName, i];
        SKTexture *texture =
        [SKTexture textureCachedWithImageNamed:textureName];
        [textures_USMIECHNIETY addObject:texture];
    }}
    
    [self.costumeVisuals addObject:[SKAction repeatActionForever:[SKAction animateWithTextures:textures_USMIECHNIETY timePerFrame:0.2]]];
    
    
    NSMutableArray *textures_ZASYPIA = [NSMutableArray arrayWithCapacity:1];
        if(isSimple){
             textures_ZASYPIA = [NSMutableArray arrayWithCapacity:1];
            NSString *textureName = [NSString stringWithFormat:@"EMPTY"];
            SKTexture *texture = [SKTexture textureCachedWithImageNamed:textureName];
            [textures_ZASYPIA addObject:texture];
        }else{
    for (int i = 1; i <= 1; i++)
    {
        NSString *textureName = [NSString stringWithFormat:@"%@_ZASYPIA",dName];
        SKTexture *texture =
        [SKTexture textureCachedWithImageNamed:textureName];
        [textures_ZASYPIA addObject:texture];
    }
        }
    [self.costumeVisuals addObject:[SKAction repeatActionForever:[SKAction animateWithTextures:textures_ZASYPIA timePerFrame:0.2]]];
    

   

    
    NSMutableArray *textures_SPI = [NSMutableArray arrayWithCapacity:5];
            if(isSimple){
                textures_SPI = [NSMutableArray arrayWithCapacity:1];
                NSString *textureName = [NSString stringWithFormat:@"EMPTY"];
                SKTexture *texture = [SKTexture textureCachedWithImageNamed:textureName];
                [textures_SPI addObject:texture];
            }else{
    for (int i = 1; i <= 5; i++)
    {
        NSString *textureName = [NSString stringWithFormat:@"%@_SPI_%d",dName, i];
        SKTexture *texture =
        [SKTexture textureCachedWithImageNamed:textureName];
        [textures_SPI addObject:texture];
    }
            }
    [self.costumeVisuals addObject:[SKAction repeatActionForever:[SKAction animateWithTextures:textures_SPI timePerFrame:0.2]]];
    
    
    
    NSMutableArray *textures_ZDZIWIONY = [NSMutableArray arrayWithCapacity:1];
                if(isSimple){
                    textures_ZDZIWIONY = [NSMutableArray arrayWithCapacity:1];
                    NSString *textureName = [NSString stringWithFormat:@"EMPTY"];
                    SKTexture *texture = [SKTexture textureCachedWithImageNamed:textureName];
                    [textures_ZDZIWIONY addObject:texture];
                }else{
    for (int i = 1; i <= 1; i++)
    {
        NSString *textureName = [NSString stringWithFormat:@"%@_ZDZIWIONY",dName];
        SKTexture *texture =
        [SKTexture textureCachedWithImageNamed:textureName];
        [textures_ZDZIWIONY addObject:texture];
    }}
    
    [self.costumeVisuals addObject:[SKAction animateWithTextures:textures_ZDZIWIONY timePerFrame:0.6]];
    
    
    
    NSMutableArray *textures_KRZYCZY = [NSMutableArray arrayWithCapacity:6];
                    if(isSimple){
                        textures_KRZYCZY = [NSMutableArray arrayWithCapacity:1];
                        NSString *textureName = [NSString stringWithFormat:@"EMPTY"];
                        SKTexture *texture = [SKTexture textureCachedWithImageNamed:textureName];
                        [textures_KRZYCZY addObject:texture];
                    }else{
                        for (int i = 1; i <= 6; i++)
    {
        NSString *textureName = [NSString stringWithFormat:@"%@_KRZYCZY_%d",dName, i];
        SKTexture *texture =
        [SKTexture textureCachedWithImageNamed:textureName];
        [textures_KRZYCZY addObject:texture];
    }
                    }
    
    [self.costumeVisuals addObject:[SKAction repeatActionForever:[SKAction animateWithTextures:textures_KRZYCZY timePerFrame:0.2]]];
    
    

}


-(void) setMoodState{
    SKAction* sk = [self.costumeVisuals objectAtIndex:self.moodState];
    
    if (moodState==0){
        sk = [SKAction sequence:@[[self.costumeVisuals objectAtIndex:3],[self.costumeVisuals objectAtIndex:self.moodState]]];
    }
    MTSpriteMoodNode* visual= (MTSpriteMoodNode* )[self.children firstObject];
    if(visual==nil){
        visual = [MTSpriteMoodNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(75, 75)];
        //visual.xScale=self.xScale;
        //visual.yScale=self.yScale;
        [self addChild:visual];
    }
    //[self removeAllChildren];
    //[visual removeFromParent];
    //[self addChild:visual];
    [visual removeAllActions];
    [visual runAction:sk];
    //[visual setScale: self.xScale];
    
    //MTSpriteMoodNode *v2 = [visual copy];
    //MTSpriteMoodNode* visual = [MTSpriteMoodNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(75, 75)];
    //[self.myGhostIcon removeAllChildren];
    //[self.myGhostIcon addChild:v2];
    //[v2 setSize:CGSizeMake(50, 50)];
    //SKAction* sk = [self.costumeVisuals objectAtIndex:1];
    //[v2 runAction:sk];
}

-(void) moodWatcherInvocation{
    if(selectedRepresentation==self){
        
    }else{
    //////NSLog(@"... %d", nothingHappened);
    self.nothingHappened++;
        if(self.nothingHappened==5){
            self.moodState=1;
            [self setMoodState];
        }
        if(self.nothingHappened==10){
            self.moodState=2;
            [self setMoodState];
        }
    }
}

-(void)auc{
    self.moodState=0;
    [self setMoodState];
    [[MTAudioPlayer instanceMTAudioPlayer] playGhost: [[self.ghostName substringFromIndex:1]intValue]];
   
}

-(void)makeMeSelected
{
    @try{
     [[MTAudioPlayer instanceMTAudioPlayer] playGhost: [[self.ghostName substringFromIndex:1]intValue]];
    if ( selectedRepresentation )
    {
        [selectedRepresentation makeMeUnselected];
    }
    
    selectedRepresentation = self;
    self.nothingHappened=0;
    self.moodState=0;
    [self setMoodState];
    
    
    if (ANIMATIONS && GHOST_EFFECT_NODE)
    {
        myEffect = [[MTGhostRepresentationEffectNode alloc] initEffectNodeOn:self];
        [self addChild:myEffect];
        
               
        [myEffect doPostInitAnimationWithMe];
        
        if([self.state isKindOfClass:[MTStateOfEditingGhostRepresentationNode class]])
            [myEffect doSelectedAnimationWithMe];
    }
    
    
    }@catch(NSException *e){
        
    }
    /* ikonka zaznacz sie */
    //[self.myGhostIcon makeMeSelected];
    [self.myGhostIcon tapGesture:nil];
}

-(void)makeMeUnselected
{
    @try{
        
    if (ANIMATIONS && GHOST_EFFECT_NODE && selectedRepresentation != nil)
    {
        for (MTSpriteNode* child in selectedRepresentation.children)
        {
            if([child isKindOfClass:[MTGhostRepresentationEffectNode class]]
               
               )
            {
                [(MTGhostRepresentationEffectNode *)child doUnselectedAnimationWithMe];
            }
            if([child isKindOfClass:[SKEmitterNode class]]){
                [child removeFromParent];
            }
        }
    }
    
    selectedRepresentation = nil;
        
    }@catch(NSException *e){
        
    }
}

/*
-(void)hold:(UIGestureRecognizer *)g :(UIView *)v{
    //if (!self.blocked){
        [super hold:g :v];
    //}//
}*/


-(void)holdGesture:(UIGestureRecognizer *)g  :(UIView *)v
{
    [self.state holdGesture:g :v WithGhostRep:self];
}
-(void)animateTap{
    if(_tapanimationactive==0){ _tapanimationactive=1;
    SKAction *scaleDown = [SKAction scaleBy:0.9 duration:0.1];
    SKAction * a =
    [SKAction sequence:@[
                         scaleDown, [scaleDown reversedAction]
                         ,[SKAction runBlock:^{
                            _tapanimationactive=0;
                        }]]];
    [self runAction:a];
    }
}

-(void)tapGesture:(UIGestureRecognizer *)g
{
    
    MTSceneAreaNode* scene = (MTSceneAreaNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
    
    if(scene.addMultiCloneMode == true || scene.addOneCloneMode == true)
    {
        [scene addNewGhostInstance:g];
    }
    else
    {
        [self.state tapGesture:g WithGhostRep:self];
    }
}

-(void)panGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    
    MTSceneAreaNode * sceneArea = ((MTSceneAreaNode *)[(SKNode *)self.scene.children[0] childNodeWithName:@"MTSceneAreaNode"]);
    if(!sceneArea.menuMode)
    {
        [self.state panGesture:g :v WithGhostRep:self];
    }
}

-(void)pinchGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    bool menuMode = ((MTSceneAreaNode *)[(SKNode *)self.scene.children[0] childNodeWithName:@"MTSceneAreaNode"]).menuMode;
    if(!menuMode)
    {
        [self.state pinchGesture:g :v WithGhostRep:self];
    }
}

-(void)rotateGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    bool menuMode = ((MTSceneAreaNode *)[(SKNode *)self.scene.children[0] childNodeWithName:@"MTSceneAreaNode"]).menuMode;
    if(!menuMode)
    {
        [self.state rotateGesture:g :v WithGhostRep:self];
    }
}

-(void)setRotation:(CGFloat)zRotation{
    [self.state setRotationOfRep:self WithAngle:zRotation];
    //[myEffect setLightRotation:zRotation];
}



/**
 *
 * Funkcja przywracająca wartości atrybutow reprezentacji duszka do stanu sprzed
 * symulacji
 *
 */
-(void)resetMe
{
    self.moveXInSimulation = false;
    self.moveYInSimulation = false;
    self.affectByJoystick = true;
    [self stopGravitating];
    [self stopReverseGravitating];
    self.physicsBody.pinned=false;
    self.alpha=1.0;
    self.physicsBody.pinned=false;
    [self removeAllActions];
    [self getAttributesFromInstance];
    [self resetJoints];
    [self resetVariables];
    self.dontMove=0;
}

-(void)resetJoints{
    @try {
        [self removeMyJoints];
    } @catch (NSException *exception) {
    } @finally {
    }
}
-(void)remove
{
    //DA SIĘ USUNĄĆ W SHOWCASE!!!???
    if(self.alert==nil){
        MTGhost *gt= self.myGhostIcon.myGhost;
        MTGhostsBarNode *gBar = (MTGhostsBarNode *)[(SKNode *)self.scene.children[0] childNodeWithName:@"MTGhostsBarNode"];
        
        if(gt.ghostInstances.count > 1 || gBar.ghostIconQuota > 1)
        {
            MTBlockingBackground *background = [[MTBlockingBackground alloc] initFullBackgroundWithDuration:1.0 Color:[UIColor blackColor] Alpha:0.4 andWaitTime:0.1];
            MTWindowAlert *alert = [[MTWindowAlert alloc] initWithGhost:gt ghostBarNode:gBar ghostRepresentationNode:self];
            alert.background = background;
            self.alert=alert;
            [self addChild:alert];
            alert.position=CGPointMake(0,0);
            //[((MTSceneAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"]) addChild:alert];
            alert.zPosition=1224.0;
            self.zPosition=1223.0;
        }
    }else{
        [self.alert cancel];
        self.alert=nil;
    }
}
-(void)saveMeToInstance
{
    
}
-(BOOL)setPosDirectional:(CGPoint) np op:(CGPoint) op{
    //stary punkt poprzedniego:op;
    //nowy punkt poprzedniego:np;
    NSLog(@"Setting pos of %@ DN %d", self.ghostName, self.dontMove);
    if(self &&  [self canmove]){
        NSLog(@"             POSSIBLE ");
        
        
            CGFloat rdist  = sqrt((self.position.x-op.x)*(self.position.x-op.x)+
                         (self.position.y-op.y)*(self.position.y-op.y));
    
    CGVector tv = CGVectorMake(self.position.x-np.x, self.position.y-np.y);
    CGFloat tvdist = sqrt(tv.dx*tv.dx+tv.dy*tv.dy);
    
    CGVector nv = CGVectorMake((tv.dx/tvdist)*(rdist), (tv.dy/tvdist)*(rdist));
    
        CGFloat nvd = sqrt(nv.dx*nv.dx+nv.dy*nv.dy);
    
        NSLog(@"rdist = %f, nvd: %f", rdist,nvd);
        
    CGPoint newpoint = CGPointMake(np.x+nv.dx, np.y+nv.dy);
        
       [self setPos:newpoint];
        return true;//ruszam
   
    }else{
        NSLog(@"             IMPOSSIBLE DECREASING DN:%D", self.dontMove-1);

        self.dontMove-=1;
        return false;//nie ruszam
    }
    
    
}


-(BOOL) canmove{
    return self.dontMove==0;
}


-(void) drawLineToPoint:(CGPoint) pt{
    //self.oldposition2
    //DO pt
    if(self.draw){
    if(self.oldposition2.x!=-1000){
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 5.0 );
    CGContextSetStrokeColorWithColor(ctx,[UIColor blackColor].CGColor);
    //CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(ctx, self.oldposition2.x, self.oldposition2.y);
    CGContextAddLineToPoint(ctx,pt.x+self.parent.frame.size.width/2,-pt.y+self.parent.frame.size.height/2);
    CGContextStrokePath(ctx);
    self.oldposition2=CGPointMake(pt.x+self.parent.frame.size.width/2,-pt.y+self.parent.frame.size.height/2);
    }
    self.oldposition2=CGPointMake(pt.x+self.parent.frame.size.width/2,-pt.y+self.parent.frame.size.height/2);
    }

}
-(BOOL)setPos:(CGPoint) pt
{
    
    
   //NSLog(@">>>>>>Posx  x: %f y %f",pt.x,pt.y);
    //CGVector dxy = CGVectorMake(pt.x-self.position.x, pt.y-self.position.y);
    //if([self canmove]){
    CGPoint op = self.position;//oldposition;
        
        if(pt.x<-1024/2)pt.x=-1024/2;
        if(pt.x>1024/2)pt.x=1024/2;
        if(pt.y<-768/2)pt.y=-768/2;
        if(pt.y>768/2)pt.y=768/2;
        [self.state setPositionOfRep:self WithPoint:pt ];
    if(self.draw){
        [self drawLineToPoint:pt];
    }
    self.oldposition=pt;
    
        
        if (self.joints!=nil){
            self.dontMove=0;
            for (MTGhostRepresentationNode* n in self.joints){
                self.dontMove+=1;
        }
            int x = 0;
            for (MTGhostRepresentationNode* n in self.joints){
                x++;
                   NSLog(@"setPos %d) Setting for: %@, DM %d",x, self.ghostName,self.dontMove);
                if(![n setPosDirectional:pt op:op]){
                    self.dontMove-=1;
                }
                
                
            }
        }
        
        
    
       return false;
    
    
    
}
-(void)setPhysics:(bool)flag
{
    [self.state setPhysics:self ToValue:flag];
}


-(void)setDynamics:(bool)flag
{
    [self.state setDynamics:self ToValue:flag];
}


-(void)setGravitation:(bool)value
{
    [self.state setGravitation:self ToValue:value];
}

-(void)setGravitationMy:(bool)value{
    [self.state setGravitationMy:self ToValue:value];
}


-(void)setMasSign:(int)value{
    [self.state setMasMy:self ToValue:value];
}

-(void)setReversedGravity:(bool)value
{
    [self.state setReversedGravity:self ToValue:value];
}

-(void)setJoystick:(bool)value
{
    [self.state setJoystick:self ToValue:value];
}

/**
 *  Musi byc wywoływana po kompilacji kodu
 *
 */
-(void)prepareMeBeforSimulation
{
    self.physicsBody.dynamic=YES;
    for (int i=0 ;i<self.myGhostIcon.myGhost.trains.count ; i++)
    {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        [self.variablesForTrains addObject: array];
        for (int j=0;j<((MTTrain*)self.myGhostIcon.myGhost.trains[i]).code.count;j++)
        {
            [array addObject:[[NSMutableDictionary alloc]init]];
        }
    }
    
}

/**
 *
 *
 */
- (id)getVariableWithName:(NSString *)varName Class: (Class) aClass ForCartNo:(NSInteger) cartNo TrainNo: (NSInteger) trainNo
{
    NSMutableArray* trainDict = self.variablesForTrains[trainNo];
    NSMutableDictionary* cartDict = nil;
    
    if (cartNo < 0)
        cartNo = 0;
    if (trainNo < 0)
        trainNo = 0;
    
    if (trainDict)//Jezeli trainDict istnieje
    {
        ///probuje uzyskać cartDict
        cartDict = trainDict[cartNo];
    }
    else
    {
        ///tworze trainDict
        trainDict = [[NSMutableArray alloc]init];
        self.variablesForTrains[trainNo] = trainDict ;
    }
    
    id variable = nil;
    if (cartDict)//Jezeli cartDict istnieje
    {
        ///probuje uzyskać zmienna
        variable = [cartDict objectForKey: varName];
    }
    else
    {
        ///tworze cartDict
        cartDict = [[NSMutableDictionary alloc]init];
        trainDict[cartNo] = cartDict;
    }
    
    if (variable == nil)// jezeli nie ma zmiennej
    {
        if (aClass == [NSNumber class])
        {
            variable = [[NSNumber alloc]initWithInteger:0];
        }
        if (variable == nil)
        {
            
#if DEBUG_NSLog
            ////NSLog(@"Błąd inicjalizacji obiektu");
#endif
            
        }
        [cartDict setObject:variable forKey:varName];
    }
    return variable;
}

- (void)setVariable: (id) variable WithName:(NSString *)varName ForCartNo:(NSInteger) cartNo TrainNo: (NSInteger) trainNo
{

     self.nothingHappened=0;
#if DEBUG_NSLog
    ////NSLog(@"wagonik[%i] z pociagu[%i] ustawia %@ na %i",cartNo,trainNo,varName,[variable integerValue]);
#endif
    
    if (cartNo < 0)
        cartNo = 0;
    if (trainNo < 0)
        trainNo = 0;
    
   [((NSMutableDictionary *)self.variablesForTrains[trainNo][cartNo]) setObject:variable forKey: varName] ;
   /* if (!trainDict)
    {
        trainDict = [[NSMutableArray alloc]init];
        self.variablesForTrains[trainNo] = trainDict;
    }
    if (cartNo < 0)
    {
        cartNo = 0;
    }*/
    //NSMutableDictionary* cartDict=trainDict [cartNo] ;
    /*if (!cartDict)
    {
        cartDict = [[NSMutableDictionary alloc]init];
        trainDict[cartNo] = cartDict;
    }*/
    //[cartDict setObject:variable forKey:varName];
}



- (void) resetVariables
{
    self.variablesForTrains = nil;
    self.variablesForTrains = [[NSMutableArray alloc] init];
}

-(void)removeFromStage{
    
    self.physicsBody.dynamic=false;
    self.deleted = true;
    [self.myFlags removeNotifications];
    SKSpriteNode * del = [[SKSpriteNode alloc]initWithTexture:self.texture];
    //Dodatkowy NOD (dummy) do pokazania animaacji.
    del.position=self.position;
    del.xScale=self.xScale;
    del.yScale=self.yScale;
    del.size=self.size;
    del.zRotation=self.zRotation;
    del.zPosition=self.zPosition+1;
    [self.parent addChild:del];
      [self removeFromParent];
    [del runAction:[SKAction sequence:@[[SKAction scaleBy:1.1 duration:0.03],[SKAction scaleBy:0.0 duration:0.1]]] completion:^{
        [del removeFromParent];
    
      }];
  
}

-(void)increaseHP{
    self.hp = self.hp +1;
    [[NSNotificationCenter defaultCenter] postNotificationName:N_HP_Signal object:self];
    [self showHP];
}
-(void)decreaseHP{
    self.hp = self.hp -1;
    [[NSNotificationCenter defaultCenter] postNotificationName:N_HP_Signal object:self];
    [self showHP];
}
-(void)showHP{

    for(int i = 0;i<10;i++){
        int d = i %2;
        
        MTSpriteNode * s;
        if(self.hp>i){
            s= [[MTSpriteNode alloc]initWithImageNamed:[NSString stringWithFormat:@"HEART%d",d]];
        }else{
             s= [[MTSpriteNode alloc]initWithImageNamed:[NSString stringWithFormat:@"HEART%d_E",d]];
            s.alpha=0.3;
            
        }
        [s setScale:0.5];
        [self.parent addChild:s];
        s.position=CGPointMake(self.position.x-125*0.5+i*25*0.5, self.position.y+self.size.height/2+10);
        [s runAction:[SKAction sequence:@[[SKAction group:@[[SKAction moveByX:0 y:40 duration:0.8],[SKAction fadeAlphaTo:0.0 duration:0.8]]],[SKAction removeFromParent]]]];
    }
}


-(void)sendSignal:(NSString*)color{
    MTSpriteNode * s;
    s= [[MTSpriteNode alloc]initWithImageNamed:[NSString stringWithFormat:@"SIGNAL_%@",color]];
    [s setScale:0.5];
    [self.parent addChild:s];
    
    //s.zPosition=self.zPosition-1;
    s.position=CGPointMake(self.position.x, self.position.y+self.size.height/2+10);
    [s runAction:[SKAction sequence:@[[SKAction group:@[[SKAction moveByX:0 y:40 duration:0.8],[SKAction fadeAlphaTo:0.0 duration:0.8]]],[SKAction removeFromParent]]]];
    
}

-(void)receiveSignal:(NSString*)color{
    MTSpriteNode * s;
    s= [[MTSpriteNode alloc]initWithImageNamed:[NSString stringWithFormat:@"SIGNAL_%@",color]];
    [s setScale:0.5];
    [self.parent addChild:s];
    //s.zPosition=self.zPosition-1;
    s.position=CGPointMake(self.position.x, self.position.y+self.size.height/2+50);
    [s runAction:[SKAction sequence:@[[SKAction group:@[[SKAction moveByX:0 y:-40 duration:0.8],[SKAction fadeAlphaTo:0.0 duration:0.8]]],[SKAction removeFromParent]]]];
    
}


-(void)addNextJoint:(MTGhostRepresentationNode*)n{
    if(self.joints==nil){
        self.joints = [NSMutableArray array];
    }
    if(![self.joints containsObject:n]){
        [self.joints addObject:n];
    }
}

-(void)removeAllJoints{
    if(self.joints!=nil){
        for (MTGhostRepresentationNode* n in self.joints){
            [n removeAllJoints];
        }
        self.joints = nil;
    }
    
}
-(void)removeJoints:(MTGhostRepresentationNode*)n{
    if(self.joints!=nil){
        [self.joints removeObject:n];
        //self.joints = nil;
    }
    
}
-(void)removeMyJoints{
    for(SKPhysicsJoint * s in self.physicsBody.joints){
        [self.scene.physicsWorld removeJoint:s];
    }
    if(self.joints!=nil){
        for (MTGhostRepresentationNode* n in self.joints){
            [n removeJoints:self];
        }
        self.joints = nil;
    }
    
}
-(void)onUpdate:(NSNotification *)notify{
    NSLog(@"Update objet draivn");
    
    [self drawLineToPoint:self.position];
}



-(void)startDrawing:(BOOL)b{
    self.draw=b;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUpdate:)
                                                 name:@"Update"
                                               object:nil];
    
    if(b){
        
        self.oldposition2=CGPointMake(self.position.x+self.parent.frame.size.width/2,-self.position.y+self.parent.frame.size.height/2);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:N_Drawing_started object:self];
    }else{
        
    }
}


@end
