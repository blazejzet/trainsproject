//
//  MTSceneAreaNode.m
//  testNodow
//
//  Created by Dawid Skrzypczyński on 18.12.2013.
//  Copyright (c) 2013 UMK. All rights reserved.
//

#import "MTSceneAreaNode.h"
#import "MTTrashNode.h"
#import "MTGhostMenuNode.h"
#import "MTGhostRepresentationNode.h"
#import "MTGhostsBarNode.h"
#import "MTGhostIconNode.h"
#import "MTGhostInstance.h"
#import "MTStorage.h"
#import "MTGhost.h"
#import "MTGUI.h"
#import "MTJoystickLeftArrowNode.h"
#import "MTJoystickRightArrowNode.h"
#import "MTJoystickUpArrowNode.h"
#import "MTJoystickDownArrowNode.h"
#import "MTJoystickAButtonNode.h"
#import "MTJoystickBButtonNode.h"
#import "MTJoystickCenterNode.h"
#import "MTLabelNode.h"
#import "MTDebugLabel.h"
#import "MTViewController.h"
#import "MTExecutor.h"
#import "MTMainScene.h"
#import "MTGhostMenuView.h"
#import "MTJoystickNode.h"
#import "MTTalkProtocol.h"
#import "MTHelpView.h"
#import "MTSpriteNodeStopSimulation.h"
#import "MTEndCloneButtonNode.h"
#import "MTExecutor.h"


@implementation MTSceneAreaNode{
     SKSpriteNode *lightBulb;
}
//static const uint32_t wall  =  0x1 << 0;
//static const uint32_t ghost =  0x1 << 1;

@synthesize backgroundA;
@synthesize backgroundB;
@synthesize drawableBackground;

-(id) init {
    if ((self = [super init]))
    {
      self = [self initWithImageNamed:@"scene_bgscene"];
        //self = [self initWithImageNamed:@"white"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onDrawingStarted:)
                                                     name:@"DrawingStarted"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onDrawingEnded:)
                                                     name:@"DrawingEnded"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onDrawingReset:)
                                                     name:@"DrawnigReset"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onUpdate:)
                                                     name:@"Update"
                                                   object:nil];
        
        
        self.name = @"MTSceneAreaNode";
        //self.debugMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"debugModeKey"]; //Do ustawienia w opcjach!
        //self.joystickMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"joystickModeKey"];
        self.menuMode = false;
        self.addOneCloneMode = false;
        self.endCloneButtonExists = false;
        self.ghostsRepresentations = [[NSMutableArray alloc] init];
        self.joystickElements = [[NSMutableArray alloc]init];
        self.debugElements = [[NSMutableArray alloc] init];
        
        self.globalVar1Cart = false;
        self.globalVar2Cart = false;
        self.globalVar3Cart = false;
        self.globalVar4Cart = false;
        self.HPCart = false;
        
        //TO TRZEBA WYLACZYC JESLI ZA SLABY SPRZET
        //====
        /*
        typedef NS_OPTIONS(uint32_t, Level1LightCategory)
        {
            CategoryLightPlayer            = 1 << 0,
        };
        lightBulb = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(20, 20)];
        lightBulb.zPosition = 100;
        [self addChild:lightBulb];
        lightBulb.position = CGPointMake(00, 350);
        SKLightNode *light = [[SKLightNode alloc] init];
        light.categoryBitMask = CategoryLightPlayer;
        light.falloff = 1.3;
        light.ambientColor = [UIColor whiteColor];
        light.lightColor = [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        light.shadowColor = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.06];
        [lightBulb addChild:light];
        
        */ //====
        
        
        //jeśli iPadNormalny to tylko wylacznik:
        if(HEIGHT==768){
            MTSpriteNodeStopSimulation* mttstop=[[MTSpriteNodeStopSimulation alloc]init768];
            [self addChild:mttstop];
            [mttstop setName:@"MTSpriteNodeStopSimulation"];
            mttstop.alpha=0.0;
            ////NSLog(@"mttstop: x: %f, Y:%f",mttstop.position.x,mttstop.position.y);
            //mttstop.alpha=0.0;
            mttstop.position=CGPointMake(1024/2-80, 140);
            mttstop.zPosition=9;

        }
        //jeśli iPadPro to ramka:
        
        if(HEIGHT==1024){
           
            MTSpriteNode* mtt2=[[MTSpriteNode alloc]initWithImageNamed:@"bleft"];
            [self addChild:mtt2];
            
            [mtt2 setName:@"MTSpriteNodeLeft"];
            
            ////NSLog(@"MTT2: x: %f, Y:%f",mtt2.position.x,mtt2.position.y);
            mtt2.position=CGPointMake(-WIDTH/2-5,0);
            
            
            
            MTSpriteNodeStopSimulation* mttstop=[[MTSpriteNodeStopSimulation alloc]init];
            [mtt2 addChild:mttstop];
            [mttstop setName:@"MTSpriteNodeStopSimulation"];
            mttstop.alpha=0.0;
            ////NSLog(@"mttstop: x: %f, Y:%f",mttstop.position.x,mttstop.position.y);
            //mttstop.alpha=0.0;
            mttstop.position=CGPointMake(-80, 0);
                mttstop.zPosition=9;
            
            
            MTSpriteNode* mtt=[[MTSpriteNode alloc]initWithImageNamed:@"btop"];
            [self addChild:mtt];
            ////NSLog(@"MTT: x: %f, Y:%f",mtt.position.x,mtt.position.y);
            
            mtt.position=CGPointMake(-mtt.size.height/2-50, 768/2+10);

            
            MTSpriteNode* mtt3=[[MTSpriteNode alloc]initWithImageNamed:@"bdownnh"];
            [self addChild:mtt3];
            ////NSLog(@"MTT: x: %f, Y:%f",mtt3.position.x,mtt3.position.y);
            
            mtt3.position=CGPointMake(-mtt.size.height/2-50, -768/2-8);

            
            
        }
    }
    return self;
}

-(void)onDrawingStarted:(NSNotification *)notify
{
    if(!self.drawableBackground){
        NSLog(@"Starting Drawing");
        self.drawableBackground=true;
        UIGraphicsBeginImageContext(self.size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), [UIImage imageNamed:@"scene_bgpaper"].CGImage);
    }
    
    
}

-(void)onDrawingReset:(NSNotification *)notify
{
    if(self.drawableBackground){
        NSLog(@"Starting Drawing");
        self.drawableBackground=true;
        UIGraphicsBeginImageContext(self.size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), [UIImage imageNamed:@"scene_bgpaper"].CGImage);
    }
    
    
}
-(void)onDrawingEnded:(NSNotification *)notify
{
    if(self.drawableBackground){
        NSLog(@"Starting Drawing");
        self.drawableBackground=false;
        self.texture=[SKTexture textureWithImageNamed:@"scene_bgscene"];
    }
    
    
}

-(void)onUpdate:(NSNotification *)notify
{
    if(self.drawableBackground){
        NSLog(@"Updating Drawing");
        UIImage *textureImage = UIGraphicsGetImageFromCurrentImageContext();
        SKTexture *texture = [SKTexture textureWithImage:textureImage];
        self.texture=texture;
    }
}

-(void)addGhostRepresentationNodeWith: (MTGhostInstance *) ghostInst ghostIcon: (MTGhostIconNode *) icon
{
    [self addGhostRepresentationNodeWith:ghostInst ghostIcon:icon :NO];
}
-(void)addGhostRepresentationNodeWith: (MTGhostInstance *) ghostInst ghostIcon: (MTGhostIconNode *) icon :(BOOL)blocked
{
    //[ghostInst getMyGhost] edytuj/nieEdytuj;
    ////NSLog(@"Adding REPNODE;");
    MTGhostRepresentationNode *newNode = [[MTGhostRepresentationNode alloc] initWithGhostInstance: ghostInst ghostIcon: icon];
     
   //if (blocked){
        //newNode.blocked = blocked;
      // newNode.physicsBody.dynamic=NO;
   //}
    
    [self.ghostsRepresentations addObject:newNode];
    
    [self addChild: newNode];
    
    float s = pow(2,icon.myGhost.mass)* self.xScale*2;
    newNode.physicsBody.mass= s;
    
    if (newNode.massign==-1){
        newNode.physicsBody.fieldBitMask=8;
    }else{
        newNode.physicsBody.fieldBitMask=1;
        
    }
}

-(void)addGhostRepresentationNodesWithGhostBar:(MTGhostsBarNode *)ghostBar
{
    /// Przegląda ikonki z ghost bara i dla każdej instancji duszka danej ikonki dodaje
    /// reprezentację graficzną.
    for (MTGhostIconNode* icon in ghostBar.icons) {
        [self addGhostRepresentationNodesWithGhostIcon:(MTGhostIconNode *)icon];
    }
    
}

-(void)addGhostRepresentationNodesWithGhostIcon:(MTGhostIconNode *)icon
{
    
    
    for (MTGhostInstance * ghostInstance in icon.myGhost.ghostInstances){
        
        [self addGhostRepresentationNodeWith:ghostInstance ghostIcon: icon];
    }
}

-(int) countAllRepresentationsforGhosts:(NSMutableArray *)array
{
    int count = 0;
    
    MTSceneAreaNode *sceneAreaNode = (MTSceneAreaNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
    
    for(int i = 0; i < array.count; i++)
    {
        MTGhost *ghost = array[i];
        int ghostRepCount = [sceneAreaNode countRepsForGhost:ghost WithRepType:@"oryginal"];
        int ghostRepCloneCount = [sceneAreaNode countRepsForGhost:ghost WithRepType:@"clone"];
        count+=ghostRepCount;
        count+=ghostRepCloneCount;
    }
    
    return count;
}

-(int) countRepsForGhost:(MTGhost *) ghost WithRepType:(NSString *)repType
{
    int count = 0;
    MTExecutor *executor = [MTExecutor getInstance];
    
    if([repType isEqual:@"oryginal"])
    {
        NSArray *representations = self.ghostsRepresentations;
        
        for(int i = 0; i < representations.count; i++)
            if(((MTGhostRepresentationNode *)representations[i]).myGhostIcon.myGhost == ghost)
                count++;
    }
    else
    {
        for(int i = 0; i < executor.UserCloneNodes.count; i++)
            if(((MTGhostRepresentationNode *)executor.UserCloneNodes[i]).myGhostIcon.myGhost == ghost)
                count++;
    }
    
    return count;
}

-(void)simulationEnd{
    [(MTGhostsBarNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTGhostsBarNode"]showBarNM];
    //wywołuje stopSimulation
    
}

-(void) panGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    
    if ([MTExecutor getInstance].simulationStarted)
        return;
    
    if(self.menuMode == true)
    {
        [self removeMenu];
        [self menuModeOff];
        
        [[self childNodeWithName:@"left"] removeFromParent];
        [[self childNodeWithName:@"right"] removeFromParent];
    }
    static CGPoint pos;
    static CGPoint xpos;
    
    if (g.state == UIGestureRecognizerStateBegan)
    {
        pos = CGPointMake([g locationInView:v].x, [g locationInView:v].y);
        MTGhostsBarNode* gb = (MTGhostsBarNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTGhostsBarNode"];
        if (!self.endCloneButtonExists)
            xpos =gb.position;
    }
    
    if(g.state==UIGestureRecognizerStateChanged){
        CGPoint currentPos = CGPointMake([g locationInView:v].x, [g locationInView:v].y);
        float minus = (currentPos.x-pos.x );
        ////NSLog(@"++++ %f",minus);
        MTGhostsBarNode* gb = (MTGhostsBarNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTGhostsBarNode"];
        float nx=xpos.x+minus;
        ////NSLog(@"%f",nx);
        
       if(nx>(0) && nx<GHOST_BAR_WIDTH ){
           if (!self.endCloneButtonExists)
               gb.position=CGPointMake(nx, gb.position.y);
        }
        
    }
    
    if(g.state == UIGestureRecognizerStateEnded)
    {
        MTGhostsBarNode* ghostBar = ((MTGhostsBarNode*)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTGhostsBarNode"]);
        
        CGPoint currentPos = CGPointMake([g locationInView:v].x, [g locationInView:v].y);
        float minus = abs(pos.x - currentPos.x);
        ////NSLog(@">>>> %f",minus);
        
        if(currentPos.x > pos.x && minus > DEAD_ZONE_GESTURE)
        {
            if ( ghostBar.isGhostBarOpened == true)
            {
                if (!self.endCloneButtonExists)
                    [ghostBar hideBar];
            }
        }
        else if(currentPos.x < pos.x && minus > DEAD_ZONE_GESTURE)
        {
            if ( ghostBar.isGhostBarOpened == true)
            {
                SKAction *act;
                SKNode * root = [self.scene childNodeWithName:@"MTRoot"];
                MTHelpView.helpScreen=hs_desktop_empty;
                for(UIView * u in self.scene.view.superview.subviews){
                    if ([u isKindOfClass:[MTGhostMenuView class]]){
                        [(MTGhostMenuView*)u removeFromParent];
                    }
                }
                
                act = [SKAction moveByX: 0 - root.position.x y:0.0 duration:0.2];
                [(MTMainScene *)self.scene prepareSimultaneousNone];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedGhostIcon Changed"
                                                                    object: nil];
                [root runAction: act completion:^{[ghostBar.picker fitIconsPPQ];}];
            } else {
            
                if (!self.endCloneButtonExists)
                    [ghostBar showBar];
                //[self simulationEnd];

            }
            
            
        }else{
            if (!self.endCloneButtonExists)
                [ghostBar showBar];
            SKAction *act;
            SKNode * root = [self.scene childNodeWithName:@"MTRoot"];
            /* przesuniecie w kierunkiu 0 (zamykanie sceneArea)*/
            MTHelpView.helpScreen=hs_desktop_empty;
            for(UIView * u in self.scene.view.superview.subviews){
                if ([u isKindOfClass:[MTGhostMenuView class]]){
                    [(MTGhostMenuView*)u removeFromParent];
                }
            }
            act = [SKAction moveByX: 0 - root.position.x y:0.0 duration:0.2 ];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedGhostIcon Changed"
                                                                object: nil];
            [(MTMainScene *)self.scene prepareSimultaneousNone];
        }
    }
}

-(CGPoint) coordFromClickedPoint:(CGPoint) pt
{
    return CGPointMake(pt.x - WIDTH /2 ,
                       (HEIGHT - pt.y) - HEIGHT / 2);
}

/**
 * Dodaje nowa instancje duszka do sceny.
 *
 * Wywolywane przy tapowaniu na scene (w tzw Trybie MultiKlonowania)
 */
-(void) addNewGhostInstance: (UIGestureRecognizer *)g
{
    if(self.ghostsRepresentations.count <= MAX_REAL_GHOST_REP)
    {
        MTGhost *ghost = [MTGhostIconNode getSelectedIconNode].myGhost;
        MTGhostInstance *recentInst = [ghost addNewInstance];

        CGPoint P = CGPointMake([g locationInView:g.view].x - 512, 384-[g locationInView:g.view].y);
        if(HEIGHT==1024){
             P = CGPointMake([g locationInView:g.view].x - 512-342, 384-[g locationInView:g.view].y+128);
            
        }
        
        if (P.x < (- WIDTH + recentInst.node.size.width) /2)
            P.x = (- WIDTH + recentInst.node.size.width) /2;
        else if ( (  WIDTH - recentInst.node.size.width) /2 < P.x)
            P.x = (  WIDTH - recentInst.node.size.width) /2;
        
        if (P.y < (- HEIGHT + recentInst.node.size.height) /2)
            P.y = (- HEIGHT + recentInst.node.size.height) /2;
        else if ( (  HEIGHT - recentInst.node.size.height) /2 < P.y)
            P.y = (  HEIGHT - recentInst.node.size.height) /2;
        
        recentInst.node.position = P;
        [self addGhostRepresentationNodeWith:recentInst ghostIcon:[MTGhostIconNode getSelectedIconNode]];
    }
    
}

-(void) tapGesture:(UIGestureRecognizer *)g
{
    if(self.ghostsRepresentations.count < MAX_REAL_GHOST_REP)
    {
        if(self.addOneCloneMode)
        {
            [self addNewGhostInstance:g];
            [self addOneCloneModeOff];
        }
        if(self.addMultiCloneMode)
        {
            [self addNewGhostInstance:g];
        }
        
        if(self.ghostsRepresentations.count == MAX_REAL_GHOST_REP)
        {
            [(MTGhostsBarNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTGhostsBarNode"]showBar];
        }
    }
    else
    {
        [(MTGhostsBarNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTGhostsBarNode"]showBar];
        if(self.addMultiCloneMode == true)
        {
            [self addMultiCloneModeOff];
        }
    }
}

-(void) menuModeOn
{
    [[MTGhostRepresentationNode getSelectedRepresentationNode] makeMeUnselected];
    self.menuMode = true;
}

-(void) menuModeOff
{
    [[MTGhostRepresentationNode getSelectedRepresentationNode] makeMeUnselected];
    self.menuMode = false;
}

-(void)addEndCloneButton{
    self.ecbn = [[MTEndCloneButtonNode alloc]init];
    [self.scene addChild:self.ecbn];
    self.endCloneButtonExists = true;
    self.ecbn.xScale=0.5;
    self.ecbn.yScale=0.5;
    if(HEIGHT==1024){
        self.ecbn.position=CGPointMake(380, 80);
    }else{
        self.ecbn.position=CGPointMake(80, 80);
    }
}

-(void)addOneCloneModeOn
{
    self.addOneCloneMode = true;
    [self addEndCloneButton];
}
-(void)addOneCloneModeOff
{
    [self.ecbn destroyMe];
    [(MTGhostsBarNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTGhostsBarNode"]showBar];
   
    self.addOneCloneMode = false;
}

-(void)addMultiCloneModeOn
{
    self.addMultiCloneMode = true;
    [self addEndCloneButton];
}

-(void)addMultiCloneModeOff
{
    self.addMultiCloneMode = false;
}
-(void)addBinForGhostRep:(MTGhostRepresentationNode *)ghostRep{
    
}
-(void)addBinForGhostRep2:(MTGhostRepresentationNode *)ghostRep
{
    MTGhostsBarNode * ghostBar = ((MTGhostsBarNode *)[(SKNode *)self.scene.children[0] childNodeWithName:@"MTGhostsBarNode"]);
    self.bin = [[MTTrashNode alloc] init];
    self.bin.position = CGPointMake(-512+40, -384+40);
    
    //ghostRep.myGhostIcon
    //+(ghostRep.size.width - self.bin.size.width)  +(ghostRep.size.height - self.bin.size.height)
    
    //self.bin.size = CGSizeMake(ghostRep.size.width, ghostRep.size.height); //myGhostIcon.
    
    if (ghostBar.ghostIconQuota > 1 || ghostRep.myGhostIcon.myGhost.ghostInstances.count > 1) {
        [self addChild:self.bin];
        
        if(ANIMATIONS)
            [self.bin runAction:self.bin.showBin];
    }
}

-(void)removeBin
{
    if(ANIMATIONS)
        [self.bin runAction:self.bin.hideBin completion:^{
           [self.bin removeFromParent];
        }];
    else
        [self.bin removeFromParent];
    
    self.bin = nil;
}

-(void)saveRepresentationNodes
{
    NSArray *reps = [self getAllGhostRepresentationNodes];
    for (MTGhostRepresentationNode* rep in reps) {
        [rep setAttributesToInstance];
    }
}

-(void)refreshMassNodeOfGhostInstance:(MTGhostInstance *)ghostInst andMass:(int)m{
   ////NSLog(@"referesz mass");
    for (MTGhostRepresentationNode* rep in self.children)//ghostsRepresentations)
    {
        if ([rep.name isEqualToString:@"MTGhostRepresentationNode"] &&
            rep.myGhostInstance == ghostInst)
        {
            rep.myGhostIcon.myGhost.mass=m;
            [rep physicBodyForGhostRep:rep width:rep.size.width height:rep.size.height scale:rep.xScale];
        }
    }
}

-(void)refreshRepresentationNodeOfGhostInstance:(MTGhostInstance *)ghostInst
{
    ////NSLog(@"referes");
    for (MTGhostRepresentationNode* rep in self.children)//ghostsRepresentations)
    {
        if ([rep.name isEqualToString:@"MTGhostRepresentationNode"] &&
            rep.myGhostInstance == ghostInst)
        {
            [[NSNotificationCenter defaultCenter]removeObserver:rep];
            [rep removeFromParent];
            
            
            [self.ghostsRepresentations removeObject:rep];
            
            [self addGhostRepresentationNodeWith:ghostInst
                                       ghostIcon:rep.myGhostIcon];
        }

        //float s  =pow(2,ghostInst.) * (1 * 10);
       // rep.physicsBody.mass =  s;

    }
}



-(void) deleteAllClones
{
    MTGhost *selectedGhost = [MTGhostIconNode getSelectedIconNode].myGhost;
    MTGhostsBarNode *ghostBar = ((MTGhostsBarNode *)[(SKNode *)self.scene.children[0] childNodeWithName:@"MTGhostsBarNode"]);
    
    //if(ghostBar.ghostQuota > 1)
    //{
    for(int i=0; i < self.ghostsRepresentations.count; i++)
    {
        for(int j=0; j < selectedGhost.ghostInstances.count; j++)
        {
            MTGhostInstance *instanceFromRepresentation = (MTGhostInstance*)(((MTGhostRepresentationNode*)self.ghostsRepresentations[i]).myGhostInstance);
            MTGhostInstance *instanceFromCurrentGhost = (MTGhostInstance*)(((MTGhost*)selectedGhost).ghostInstances[j]);
            if(instanceFromRepresentation == instanceFromCurrentGhost)
            {
                [((MTGhostRepresentationNode*)self.ghostsRepresentations[i]).myFlags removeNotifications];
                [[NSNotificationCenter defaultCenter] removeObserver: self.ghostsRepresentations[i]];
                [self.ghostsRepresentations[i] removeFromParent];
                [self.ghostsRepresentations removeObjectAtIndex:i];
            }
        }
    }
    
    [ghostBar removeGhostIcon:[MTGhostIconNode getSelectedIconNode]];
    MTStorage *storage = [MTStorage getInstance];
    [storage removeGhostAt:selectedGhost.myNumber];
    
    if(ghostBar.ghostIconQuota == 0)
    {
        [ghostBar addNewGhostIcon];
    }
    //}
}

-(void)addMenu:(MTGhostMenuNode *)menu
{
    self.ghostMenu = menu;
    [self addChild:self.ghostMenu];
    [self.ghostMenu addGhostIcons];
}

-(void) addJoystick
{
    self.joystickElements = [[NSMutableArray alloc] init];
    MTJoystickNode * mj = [[MTJoystickNode alloc]init];
    
    [self.joystickElements addObject:mj];
    
    [self.scene addChild:mj];
    
    
    MTJoystickAButtonNode *aButton = [[MTJoystickAButtonNode alloc] init];
    [self.joystickElements addObject:aButton];
    [self addChild:aButton];
    //upArrow.position=CGPointMake(120, 904);
    
    
    MTJoystickBButtonNode *bButton = [[MTJoystickBButtonNode alloc] init];
    [self.joystickElements addObject:bButton];
    [self addChild:bButton];
    //upArrow.position=CGPointMake(40, 986);
    
}

-(void) removeJoystick
{
    for(int i = 0; i < self.joystickElements.count; i++)
    {
        [self.joystickElements[i] removeFromParent];
        
    }
    [backgroundB runAction:[SKAction moveByX:0 y:-280 duration:0.2]];
    [backgroundA runAction:[SKAction moveByX:0 y:-280 duration:0.2]];

}

-(void) addDebugAddons
{
    float size = 30;
    
    self.debugElements = [[NSMutableArray alloc] init];
    
    MTDebugLabel *globalVar1 = [[MTDebugLabel alloc] initWithPosition:CGPointMake(-400, HEIGHT/2-size) numberGlobalVar:1 andString:@"G1: "];
    [self.debugElements addObject:globalVar1];
    [self addChild:globalVar1];
    
    MTDebugLabel *globalVar2 = [[MTDebugLabel alloc] initWithPosition:CGPointMake(-300, HEIGHT/2-size) numberGlobalVar:2 andString:@"G2: "];
    [self.debugElements addObject:globalVar2];
    [self addChild:globalVar2];
    
    MTDebugLabel *globalVar3 = [[MTDebugLabel alloc] initWithPosition:CGPointMake(-200, HEIGHT/2-size) numberGlobalVar:3 andString:@"G3: "];
    [self.debugElements addObject:globalVar3];
    [self addChild:globalVar3];
    
    MTDebugLabel *globalVar4 = [[MTDebugLabel alloc] initWithPosition:CGPointMake(-100, HEIGHT/2-size) numberGlobalVar:4 andString:@"G4: "];
    [self.debugElements addObject:globalVar4];
    [self addChild:globalVar4];
    
    MTDebugLabel *positionX = [[MTDebugLabel alloc] initXWithPosition:CGPointMake(-200, -(HEIGHT/2-size))];
    [self.debugElements addObject:positionX];
    [self addChild:positionX];
    
    MTDebugLabel *positionY = [[MTDebugLabel alloc] initYWithPosition:CGPointMake(-100, -(HEIGHT/2-size))];
    [self.debugElements addObject:positionY];
    [self addChild:positionY];
    
    MTDebugLabel *positionHP = [[MTDebugLabel alloc] initHPWithPosition:CGPointMake(0, -(HEIGHT/2-size))];
    [self.debugElements addObject:positionHP];
    [self addChild:positionHP];
    
    MTDebugLabel *positionMASS = [[MTDebugLabel alloc] initMASSWithPosition:CGPointMake(100, -(HEIGHT/2-size))];
    [self.debugElements addObject:positionMASS];
    [self addChild:positionMASS];
    
}

-(void) addGlobalVar1
{
    float size = 50;
    
    if (![MTStorage getInstance].DebugEnabled  && !self.globalVar1Cart)
    {
        self.globalVar1Cart = true;
        MTSpriteNode *globalVar1img = [[MTSpriteNode alloc] initWithImageNamed:@"varG1.png"];
        globalVar1img.position = CGPointMake((self.debugElements.count+1)*100, HEIGHT/2-size);
        globalVar1img.size = CGSizeMake(90, 90);
        globalVar1img.alpha = 0.5;
        MTDebugLabel *globalVar1 = [[MTDebugLabel alloc] initWithPosition:CGPointMake(0, 0) numberGlobalVar:1 andString:@""];
        [globalVar1img addChild:globalVar1];
        [self.debugElements addObject:globalVar1img];
        [self addChild:globalVar1img];
        
    }
}

-(void) addGlobalVar2
{
    float size = 50;
    
    if (![MTStorage getInstance].DebugEnabled  && !self.globalVar2Cart)
    {
        self.globalVar2Cart = true;
        MTSpriteNode *globalVar2img = [[MTSpriteNode alloc] initWithImageNamed:@"varG2.png"];
        globalVar2img.position = CGPointMake((self.debugElements.count+1)*100, HEIGHT/2-size);
        globalVar2img.size = CGSizeMake(90, 90);
        globalVar2img.alpha = 0.7;
        MTDebugLabel *globalVar2 = [[MTDebugLabel alloc] initWithPosition:CGPointMake(0, 0) numberGlobalVar:2 andString:@""];
        [globalVar2img addChild:globalVar2];
        [self.debugElements addObject:globalVar2img];
        [self addChild:globalVar2img];
    }
}

-(void) addGlobalVar3
{
    float size = 50;
    
    if (![MTStorage getInstance].DebugEnabled  && !self.globalVar3Cart)
    {
        self.globalVar3Cart = true;
        MTSpriteNode *globalVar3img = [[MTSpriteNode alloc] initWithImageNamed:@"varG3.png"];
        globalVar3img.position = CGPointMake((self.debugElements.count+1)*100, HEIGHT/2-size);
        globalVar3img.size = CGSizeMake(90, 90);
        globalVar3img.alpha = 0.6;
        MTDebugLabel *globalVar3 = [[MTDebugLabel alloc] initWithPosition:CGPointMake(0, 0) numberGlobalVar:3 andString:@""];
        [globalVar3img addChild:globalVar3];
        [self.debugElements addObject:globalVar3img];
        [self addChild:globalVar3img];
    }
}

-(void) addGlobalVar4
{
    float size = 50;
    
    if (![MTStorage getInstance].DebugEnabled  && !self.globalVar4Cart)
    {
        self.globalVar4Cart = true;
        MTSpriteNode *globalVar4img = [[MTSpriteNode alloc] initWithImageNamed:@"varG4.png"];
        globalVar4img.position = CGPointMake((self.debugElements.count+1)*100, HEIGHT/2-size);
        globalVar4img.size = CGSizeMake(90, 90);
        globalVar4img.alpha = 0.7;
        MTDebugLabel *globalVar4 = [[MTDebugLabel alloc] initWithPosition:CGPointMake(0, 0) numberGlobalVar:4 andString:@""];
        [globalVar4img addChild:globalVar4];
        [self.debugElements addObject:globalVar4img];
        [self addChild:globalVar4img];
    }
}

-(void) addHPVar
{
    float size = 50;
    
    if (![MTStorage getInstance].DebugEnabled  && !self.HPCart)
    {
        MTDebugLabel *HPVar = [[MTDebugLabel alloc] initHPWithPosition:CGPointMake(100, -(HEIGHT/2-size))];
        [self.debugElements addObject:HPVar];
        [self addChild:HPVar];
    }
}

-(void) removeDebugAddons
{
    //////NSLog(@"DEBUG_NSLog: %i", self.debugElements.count);
    for(int i = 0; i < self.debugElements.count; i++)
    {
        if([MTStorage getInstance].DebugEnabled == true)
        {
            [self.debugElements[i] stopRefreshText];
            
        } else {
            
            MTSpriteNode *tmpsn = self.debugElements[i];
            
            if([tmpsn.children[0] isKindOfClass:[MTDebugLabel class]])
            {
                MTDebugLabel *tmpdl = tmpsn.children[0];
                [tmpdl stopRefreshText];
            }
        }
        
        
        [self.debugElements[i] removeFromParent];
    }
    
    self.globalVar1Cart = false;
    self.globalVar2Cart = false;
    self.globalVar3Cart = false;
    self.globalVar4Cart = false;
}

-(void) removeMenu
{
    [self.ghostMenu removeFromParent];
}

-(void) addTextGameOver
{
    self.textGameOver.text = @"GAME OVER";
    self.textGameOver.position = CGPointMake(0, 0);
    self.textGameOver.fontSize = 100;
    self.textGameOver.alpha = 0.7;

    if(self.textGameOver.parent == nil)
    {
        [self addChild:self.textGameOver];
    }
}

-(void) removeTextGameOver
{
    if(self.textGameOver.parent != nil)
    {
        [self.textGameOver removeFromParent];
    }
}

-(void) removeTextVictory
{
    if(self.textVictory.parent != nil)
    {
        [self.textVictory removeFromParent];
    }
}

-(void) addTextVictory
{
    self.textVictory.size = CGSizeMake(500, 500);
    self.textVictory.position = CGPointMake(0, 0);
    self.textVictory.alpha = 0.7;
    
    if(self.textVictory.parent == nil)
    {
        [self addChild:self.textVictory];
    }
}
/**
 *  Metoda zbierająca reprezentacje duszków ze sceny.
 * Potrzebna do zmiany stanu wszystkich reprezentacji duszkow.
 *
 * @return Tablica reprezentacji duszków które są aktualnie zamontowane w scenie;
 *
 */
-(NSArray *) getAllGhostRepresentationNodes
{
    NSMutableArray *GhostRepresentationNodes = [[NSMutableArray alloc] init];
    
    for (int i = 0;
         i < self.children.count ;
         i++)
    {
        if ([((SKNode *)self.children[i]).name isEqualToString:@"MTGhostRepresentationNode"])
            [GhostRepresentationNodes addObject: self.children[i]];
    }
    
    return GhostRepresentationNodes;
}

@end
