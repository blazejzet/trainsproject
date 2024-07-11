//
//  MTGhostRepresentationEffectNode.m
//  MagicTrains
//
//  Created by Mateusz Wieczorkowski on 17.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTGhostRepresentationEffectNode.h"
#import "MTGhostRepresentationNode.h"
#import "MTGUI.h"
#import "MTViewController.h"
#import "MTSceneAreaNode.h"
#import "MTStateOfGhostRepresentationNode.h"
#import "MTExecutor.h"


#define BORDER 10

/*Wskaźnik na aktywny obiekt tej klasy - coś jak singleton ale nie do konca*/
static MTGhostRepresentationEffectNode *currentEffectNode;

@interface MTGhostRepresentationEffectNode()
@property SKEffectNode *lightingNode;

@end
@implementation MTGhostRepresentationEffectNode
@synthesize lightingNode;
-(void)setLightRotation:(CGFloat)zRotation{
    //lightingNode.zRotation=-zRotation;
    for(SKNode * s in lightingNode.children){
        [s setZRotation:zRotation];
    }
    //lightingNode.frame=CGRectMake(0,0,100,100);
}



-(id) initEffectNodeOnCart: (MTCodeBlockNode*)GRN
{
    if (self = [super initWithTexture:GRN.texture])
    {
        /*Zabezpieczenie przed kilkoma efektami na raz na ekranie - jesli nie chcesz z niego korzystac stworz inny konstruktor*/
        if(currentEffectNode != nil)
            [currentEffectNode destroyMe];
        
        /*Nazwa obiektu*/
        self.name = @"MTGhostRepresentationEffectNode";
        
        /*Wskaźnik na "rodzica"*/
        //self.myGRN = GRN;
        
        /*Kopia bezpieczenstwa aktualnego zPosition reprezentacji*/
        self.myGRNzPosition = GRN.zPosition;
        self.myGRN.zPosition = 0;
        
        /*Odczepianie zbednych efektow - profilaktycznie*/
        /*           for (MTSpriteNode* child in self.myGRN.children)
         {
         if([child.name isEqualToString:@"MTGhostRepresentationEffectNode"])
         [(MTGhostRepresentationEffectNode *)child removeEffectNode];
         }
         */
        /*To co nam potrzebne dla samego MTSpriteNode*/
        self.position = CGPointMake(0, 0);
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.xScale = 1.0;
        self.yScale = 1.0;
        self.size = CGSizeMake((self.myGRN.size.height/self.myGRN.xScale), (self.myGRN.size.width/self.myGRN.yScale));
        
        /*Ustawiamy kolorki*/
        self.color = [UIColor blackColor];
        self.blendMode = SKBlendModeAlpha;
        self.colorBlendFactor = 1.0;
        self.alpha = 0.1;
        
        /*Ustawiamy odpowiednie zPosition - tak aby GRN razem z efektem byly zawsze nad innymi duszkami i efekt byl pod naszym GRN*/
        self.zPosition = self.myGRN.zPosition-2;
        self.myGRN.zPosition = self.myGRN.zPosition+3;
        
        /*//Rozmycie automatyczne  się nie udaje - bug w SK //ZBYT POWOLNE!!!
         self.lightingNode = [[SKEffectNode alloc] init];
         SKTexture *texture = self.texture;
         SKSpriteNode *light = [SKSpriteNode spriteNodeWithTexture:texture];
         lightingNode.filter = [self blurFilter];
         light.position = self.position;
         lightingNode.blendMode = SKBlendModeAlpha;
         
         [lightingNode addChild: light];
         light.size = CGSizeMake((self.size.height+BORDER), (self.size.width+BORDER));
         
         lightingNode.shouldEnableEffects = YES;
         [self addChild:lightingNode];
         
         SKLightNode *light2 = [[SKLightNode alloc] init];
         light2.categoryBitMask = 1 << 0;
         light2.falloff = 1.3;
         light2.ambientColor = [UIColor whiteColor];
         light2.lightColor = [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
         light2.shadowColor = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.06];
         [self addChild:light2];*/
         
         //*/
        
        [self makeMeCurrent];
        
    }
    
    return self;
}

-(id) initEffectNodeOn: (MTSpriteNode *)GRN
{
    if (self = [super initWithTexture:GRN.texture])
    {
        /*Zabezpieczenie przed kilkoma efektami na raz na ekranie - jesli nie chcesz z niego korzystac stworz inny konstruktor*/
        if(currentEffectNode != nil)
            [currentEffectNode destroyMe];
        
        /*Nazwa obiektu*/
        self.name = @"MTGhostRepresentationEffectNode";
        
        /*Wskaźnik na "rodzica"*/
        self.myGRN = GRN;
        
        /*Kopia bezpieczenstwa aktualnego zPosition reprezentacji*/
        self.myGRNzPosition = GRN.zPosition;
        self.myGRN.zPosition = 0;
        
        /*Odczepianie zbednych efektow - profilaktycznie*/
        /*           for (MTSpriteNode* child in self.myGRN.children)
         {
         if([child.name isEqualToString:@"MTGhostRepresentationEffectNode"])
         [(MTGhostRepresentationEffectNode *)child removeEffectNode];
         }
         */
        /*To co nam potrzebne dla samego MTSpriteNode*/
        self.position = CGPointMake(0, 0);
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.xScale = 1.0;
        self.yScale = 1.0;
        self.size = CGSizeMake((self.myGRN.size.height/self.myGRN.xScale), (self.myGRN.size.width/self.myGRN.yScale));
        
        /*Ustawiamy kolorki*/
        self.color = [UIColor blackColor];
        self.blendMode = SKBlendModeAlpha;
        self.colorBlendFactor = 1.0;
        self.alpha = 0.1;
        
        /*Ustawiamy odpowiednie zPosition - tak aby GRN razem z efektem byly zawsze nad innymi duszkami i efekt byl pod naszym GRN*/
        self.zPosition = self.myGRN.zPosition-2;
        self.myGRN.zPosition = self.myGRN.zPosition+3;
        self.physicsBody.mass = 0;
        self.physicsBody.dynamic = NO;
        
        /*//Rozmycie automatyczne  się nie udaje - bug w SK //ZBYT POWOLNE!!!
         self.lightingNode = [[SKEffectNode alloc] init];
         SKTexture *texture = self.texture;
         SKSpriteNode *light = [SKSpriteNode spriteNodeWithTexture:texture];
         lightingNode.filter = [self blurFilter];
         light.position = self.position;
         lightingNode.blendMode = SKBlendModeAlpha;
         
         [lightingNode addChild: light];
         light.size = CGSizeMake((self.size.height+BORDER), (self.size.width+BORDER));
         
         lightingNode.shouldEnableEffects = YES;
         [self addChild:lightingNode];
         /*
         SKLightNode *light2 = [[SKLightNode alloc] init];
         light2.categoryBitMask = 1 << 0;
         light2.falloff = 1.3;
         light2.ambientColor = [UIColor whiteColor];
         light2.lightColor = [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
         light2.shadowColor = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.06];
         [self addChild:light2];*/
         
         //*/
        
        [self makeMeCurrent];
        
    }
    
    return self;
}




/*Konstruktor kopiujacy obiekt typu MTGhostRepresentationEffectNode. Uzywany np w strefie animacji*/
-(id) initCopyFrom: (MTGhostRepresentationEffectNode *)effectNode
{
    if (self = [super initWithTexture:effectNode.texture])
    {
        self.position = effectNode.position;
        self.anchorPoint = effectNode.anchorPoint;
        self.xScale = effectNode.xScale;
        self.yScale = effectNode.yScale;
        self.color = effectNode.color;
        self.blendMode = effectNode.blendMode;
        self.colorBlendFactor = effectNode.colorBlendFactor;
        self.alpha = 0.8;
        self.size = CGSizeMake(effectNode.size.height/effectNode.myGRN.xScale, effectNode.size.width/effectNode.myGRN.yScale);
        self.physicsBody.mass = 0;
        self.physicsBody.dynamic = NO;
        
        /*Dostrajanie zPosition*/
        effectNode.myGRN.zPosition++;
        effectNode.zPosition = effectNode.zPosition;
        //self.zPosition = effectNode.myGRN.zPosition-2;
        
        //////NSLog(@"myGRN %f effect %f additional %f", effectNode.myGRN.zPosition, effectNode.zPosition, self.zPosition);
        
        self.myGRN = nil; //taki obiekt nie posiada domyslnie wskaznika do reprezentacji
    }
    return self;
}

/*Funkcja usuwajaca NODEa - konieczna, zamiast [myEffect removeFromParent]*/
-(void) removeEffectNode
{
    [self removeAllChildren];
    if (self.myGRN != nil)
    {
        if(self.myGRN.parent!=nil){
            self.myGRN.zPosition = 0;
        }
    }
    @try {
        if(self.parent!=nil){
        [self removeFromParent];
        }
    } @catch (NSException *exception) {
    } @finally {
    }
}

/*STREFA ANIMACJI*/

-(void) doPostInitAnimationWithMe
{
    if (ANIMATIONS)
    {
        SKAction *element1 = [SKAction resizeToWidth:(self.myGRN.size.width/self.myGRN.xScale)+BORDER \
                                              height:(self.myGRN.size.height/self.myGRN.yScale)+BORDER duration:0.2];
        
        SKAction *element2 = [SKAction fadeAlphaTo:0.6 duration:0.2];
        
        SKAction *initAnimation = [SKAction group:@[element1, element2]];
        
        [self runAction:initAnimation];
        
    } else {
        
        self.size = CGSizeMake((self.myGRN.size.height/self.myGRN.xScale)+BORDER, (self.myGRN.size.width/self.myGRN.yScale)+BORDER);
        
    }
}


- (CIFilter *)blurFilter
{
    /*CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"]; // 3
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:20] forKey:@"inputRadius"];
    return filter;*/
    
    return nil;
}

-(void) doSelectedAnimationWithMe
{
    
    //TODO -  TUTAJ SIĘ COŚ WYWALA
    /*Dla pewnosci*/
    //[self removeAllActions];
    
    /*Tworze dodatkowego NODEa - zeby efekt wygladal przyzwoicie - obwodka caly czas aktywna*/
    //MTGhostRepresentationEffectNode *additionalNode = [[MTGhostRepresentationEffectNode alloc] initCopyFrom:self];
    //[self addChild:additionalNode];
    
    /*Mozemy ustawic intensywnosc efektu: mnoznik wielkosci ramki*/
    float intensity = 4;
    
    /*Zestaw animacji*/
    SKAction *element1 = [SKAction resizeToWidth:(self.myGRN.size.width/self.myGRN.xScale)+BORDER*intensity \
                                          height:(self.myGRN.size.height/self.myGRN.yScale)+BORDER*intensity duration:0.4];
    SKAction *element2 = [SKAction fadeAlphaTo:1.0 duration:0.4];
    
    SKAction *selectedAnimation = [SKAction group:@[element1, element2]];
    
    /*Wykonywanie animacji*/
    //[self.lightingNode runAction: selectedAnimation completion:^{
        //[self removeAllChildren];
    //}];
}

-(void) doUnselectedAnimationWithMe
{
    [self removeAllActions];
    //SKAction *unselectedAnimation = [SKAction resizeToWidth:(self.myGRN.size.width/self.myGRN.xScale) \
                                                     height:(self.myGRN.size.height/self.myGRN.yScale) duration:0.2];
    //[self runAction:unselectedAnimation completion:^{
        [self removeEffectNode];
    //}];
}

/*STREFA GESTOW
 *Przekazanie ich do rodzica (czyli MTGhostRepresentationNode) - mozna tutaj zdefiniowac inne zachowanie NODEa efektu w roznych stanach*/
-(void)panGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    MTSceneAreaNode* scene = (MTSceneAreaNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
    if(!scene.menuMode)
    {
        [(MTStateOfGhostRepresentationNode*)(self.myGRN.state) panGesture:g :v WithGhostRep:self.myGRN];
    }
    
}

-(void)pinchGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    MTSceneAreaNode* scene = (MTSceneAreaNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
    if(!scene.menuMode)
    {
        [(MTStateOfGhostRepresentationNode*)(self.myGRN.state) pinchGesture:g :v WithGhostRep:self.myGRN];
    }
}

-(void)rotateGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    MTSceneAreaNode* scene = (MTSceneAreaNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
    if(!scene.menuMode)
    {
        [(MTStateOfGhostRepresentationNode*)(self.myGRN.state) rotateGesture:g :v WithGhostRep:self.myGRN];
    }
}

-(void)tapGesture:(UIGestureRecognizer *)g
{
    MTSceneAreaNode* scene = (MTSceneAreaNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
    if(!scene.menuMode)
    {
        [(MTStateOfGhostRepresentationNode*)(self.myGRN.state) tapGesture:g WithGhostRep:self.myGRN];
    }
}

/*ZABEZPIECZENIE PRZEZ KILKUKROTNYM TWORZENIEM EFEKTU, np w przypadku duzego obciazenia CPU :( */
+(MTGhostRepresentationEffectNode*) getCurrentEffectNode
{
    return currentEffectNode;
}

-(void) makeMeCurrent
{
    if (currentEffectNode == self)
    {
        [self destroyMe];
    }
    
    currentEffectNode = self;
}

-(void) destroyMe
{
    //TODO Mateusz Zrobic to lepiej :)
    [self removeEffectNode];
    currentEffectNode = nil;
}

@end
