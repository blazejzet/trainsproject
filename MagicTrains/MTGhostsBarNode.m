//
//  MTGhostsBarNode.m
//  testNodow
//
//  Created by Dawid Skrzypczyński on 18.12.2013.
//  Copyright (c) 2013 UMK. All rights reserved.
//
#import "MTMainScene.h"
#import "MTGhostsBarNode.h"
#import "MTPlusButtonNode.h"
#import "MTGhostIconNode.h"
#import "MTSceneAreaNode.h"
#import "MTViewController.h"

#import "MTGhost.h"
#import "MTStorage.h"
#import "MTGlowFilter.h"
#import "MTCodeAreaNode.h"
#import "MTGUI.h"
#import "MTGhostMenuView.h"
#import "MTGhostBarPickerNode.h"
#import "MTGhostRepresentationNode.h"
#import "MTAudioPlayer.h"

@implementation MTGhostsBarNode

@synthesize ribbon;

-(id) init {
    if ((self = [super init]))
    {
        self = [self initWithImageNamed:@"ghostsBarBG-6.png"];
        self.name = @"MTGhostBarNode";
        
        
        SKAction * s =
        
            [SKAction sequence:@[
                                            [SKAction waitForDuration:5.0],
                                            [SKAction animateWithTextures:@[
                                                                    [SKTexture textureWithImageNamed:@"ghostsBarBG-1"],
                                                                    [SKTexture textureWithImageNamed:@"ghostsBarBG-2"],
                                                                    [SKTexture textureWithImageNamed:@"ghostsBarBG-3"],
                                                                    [SKTexture textureWithImageNamed:@"ghostsBarBG-4"],
                                                                    [SKTexture textureWithImageNamed:@"ghostsBarBG-5"],
                                                                    [SKTexture textureWithImageNamed:@"ghostsBarBG-6"]
                                                                            ] timePerFrame:0.1]
                                            ]];
        
        [self runAction:[SKAction repeatActionForever:s]];
        self.picker = [[MTGhostBarPickerNode alloc] init];
        self.picker.position = CGPointMake(0, +HEIGHT/2 + (self.picker.sizeEl/2));
        [self addChild:self.picker];
        
        
        self.ribbon = [[MTRibbon alloc]init];
        //[self.ribbon setScale:0.5];
        [self addChild:self.ribbon];
        self.ribbon.position=CGPointMake(-self.ribbon.size.width/2, HEIGHT-self.ribbon.size.height/2);
        
        
        
        MTRibbon *ribbon2 = [[MTRibbon alloc]initR];
        //[ribbon2 setScale:0.5];
        [self addChild:ribbon2];
        ribbon2.position=CGPointMake(95, HEIGHT-self.ribbon.size.height/2);
        
         MTSpriteNode* dings=[MTSpriteNode spriteNodeWithImageNamed:@"dings.png"];
        [self addChild:dings];
        dings.position=CGPointMake(101, HEIGHT/2);
        //self.dings.position=CGPointMake(40, self.size.height/2-newPos.y-50);
        //[dings setScale:0.5];
        dings.zPosition=2000;

        MTPlusButtonNode *plusButton = [[MTPlusButtonNode alloc] init];
        self.icons = [[NSMutableArray alloc] init];
        [self addChild: plusButton];
        
        MTStorage *storage = [MTStorage getInstance];
        if(storage.ProjectType == MTProjectTypeLearn || storage.ProjectType == MTProjectTypeQuest)
            [plusButton makeMeUnActive];
        
        self.ghostIconQuota = 0;
        [MTGhostRepresentationNode resetSelectedRepresentationNode];
        [self reloadGhostsFromStorage];
        
        self.isGhostBarOpened = true;
    }
    return self;
}

-(MTGhost*) getSelectedGhost
{
    return [MTGhostIconNode getSelectedIconNode].myGhost;
}

-(void)moveCompilationIconToLastPlaceOnTheList
{
    SKNode* CompNode;
    CompNode = [self childNodeWithName:@"MTCompilationIconNode"];
    [CompNode removeFromParent];
    [self insertChild:CompNode atIndex: self.children.count];
}

-(CGPoint)positionOfNewGhostIconWithNr:(int) i
{
    return CGPointMake(GHOST_BAR_WIDTH/2, HEIGHT - ( GHOST_ICON_HEIGHT/2 + 70 + ( GHOST_ICON_HEIGHT+2.5) * i ));
}

-(void) reloadGhostsFromStorage
{
    MTStorage* storage = [MTStorage getInstance];
    MTSceneAreaNode* sceneAreaNode =(MTSceneAreaNode*) [[[[MTViewController getInstance] mainScene] childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"];
    
    for (int i=0;i<MAX_GHOST_COUNT;i++)
    {
        MTGhostIconNode* newIcon = [self addGhostIconWithGhost: [storage getGhostAt:i]];
        if (newIcon)
        {
            [sceneAreaNode addGhostRepresentationNodesWithGhostIcon: newIcon];
            
#if DEBUG_NSLog
            ////NSLog(@" => %@",[MTGhostIconNode getSelectedIconNode].myGhost);
#endif
            
            //[newIcon tapGesture:nil];
        }
    }
    
    [self _selectLastIcon];
}

-(id) addGhostIconWithGhost:(MTGhost*) ghost
{
    if (ghost)
    {
        MTGhostIconNode *NewGhostIcon = [[MTGhostIconNode alloc] initWithGhost:ghost];
        NewGhostIcon.myGhost = ghost;
        if ([ghost ghostInstances].count == 0)
        {
            MTGhostInstance * ghostInstance = [ghost CreateNewGhostInstance];
            [((MTSceneAreaNode *)[self.parent childNodeWithName:@"MTSceneAreaNode"]) addGhostRepresentationNodeWith: ghostInstance ghostIcon: NewGhostIcon];
        }else
        {
            for (MTGhostInstance * ghostInstance in ghost.ghostInstances) {
                [((MTSceneAreaNode *)[self.parent childNodeWithName:@"MTSceneAreaNode"]) addGhostRepresentationNodeWith: ghostInstance ghostIcon: NewGhostIcon];
            }
        }
        
        [self.picker addNewElementToPicker:NewGhostIcon];
        
        self.ghostIconQuota++;
        if (self.ghostIconQuota == MAX_GHOST_COUNT)
            [self childNodeWithName:@"MTPlusButtonNode"].hidden = true;
        
        [self.icons addObject:NewGhostIcon];
        //[NewGhostIcon tapGesture:nil];
        return NewGhostIcon;
    }
    return nil;
}

/* Dodawanie nowej ikonki do paska duszkow */
-(void) addNewGhostIcon
{
    if ( self.ghostIconQuota < MAX_GHOST_COUNT)
    {
        MTStorage *Storage = [MTStorage getInstance];
        
        MTGhost * g = [Storage addGhost];
        
        [self addGhostIconWithGhost: g];
        
        [(MTCodeAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCodeAreaNode"] selectFirstTab];
        [(MTCodeAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCodeAreaNode"] categoryBarInit];
        
        [self _selectLastIcon];
    }
}

// Usuwa ikonke z bara i duszka ze Storage
// Dodanie przycisku plus po usunieciu
-(void) removeGhostIcon:(MTGhostIconNode*) icon
{
    MTStorage *storage =[MTStorage getInstance];
    int ghostNumber = [MTGhostIconNode getSelectedIconNode].myGhost.myNumber;
    
    /* usuniecie efektu */
    //[[MTGhostIconNode getSelectedIconNode].parent removeFromParent];
    //usuwanie tej ikonki
    [[MTGhostIconNode getSelectedIconNode] removeFromParent];
    
    //[storage getGhostAt:ghostNumber];
    
    [storage removeGhostAt:ghostNumber];
    
    self.ghostIconQuota--;
    MTGhostIconNode *currentIcon = [MTGhostIconNode getSelectedIconNode];
    
    for(int i = 0; i < self.icons.count; i++)
    {
        if(self.icons[i] == currentIcon)
        {
            [self.icons removeObject:currentIcon];
            [[NSNotificationCenter defaultCenter] removeObserver:currentIcon];
        }
    }
    
    if(self.ghostIconQuota != 0)
    {
        [self.picker removeIconFromPicker:currentIcon];
//        [((MTGhostIconNode *)self.children[2]) makeMeSelected];
    }
    
    if(self.ghostIconQuota == MAX_GHOST_COUNT-1) {
        [self childNodeWithName:@"MTPlusButtonNode"].hidden = false;
    }
    [self _selectLastIcon];
}

- (void)_selectLastIcon
{
    if (_icons.count > 0)
        [(MTGhostIconNode *)_icons[_icons.count-1] makeMeSelected];
}

- (void)moveRoot:(UIGestureRecognizer *)g v:(UIView *)v
{
    UIPanGestureRecognizer *p = (UIPanGestureRecognizer * ) g;
    static CGPoint t;
    
    //CGPoint point = [p locationInView : v];
    if ([p numberOfTouches] > 0 && [p numberOfTouches] <4)
    {
        CGPoint point = [p locationOfTouch: 0 inView:v];
        
        point = CGPointMake(point.x - 0,0);
        
        if(g.state == UIGestureRecognizerStateBegan)
        {
            t = CGPointMake(point.x -  ((SKNode *) self.scene.children[0]).position.x,0);
        }
        
        CGPoint r = self.position;
        r.x =  point.x - t.x;
        //if (r.x >= 0)
        ((SKNode *)self.scene.children[0]).position = r;
    
    }
}

-(void) panGestureForGhostIcon:(UIGestureRecognizer *)g :(UIView *)v
{
    [self panGestureMain:g :v];
}

-(void) panGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    [self panGestureMain:g :v];
}

-(void) panGestureMain:(UIGestureRecognizer *)g :(UIView *)v
{
    SKNode * root = [self.scene childNodeWithName:@"MTRoot"];
    
    static CGPoint StartPosition;
    if (g.state == UIGestureRecognizerStateBegan)
    {
        StartPosition = root.position;
    }
    
    [self moveRoot:(UIGestureRecognizer *)g v:(UIView *)v];

    
    float positionWhenOpened = WIDTH - GHOST_BAR_WIDTH;
    float pktGraniczny = (positionWhenOpened)/ 6 ;
    
    if (g.state == UIGestureRecognizerStateEnded)
    {
        /* jesli przeciaganie zaczyna sie w poblizu zera*/
        
        float rootpos = root.position.x;
        float pktZamkniecia = positionWhenOpened - pktGraniczny;
        float pktOtwarcia = pktGraniczny;
        if (StartPosition.x < 10)
        {
            if (rootpos < pktGraniczny )
            {
                /* przesuniecie w kierunkiu 0 (zamykanie sceneArea)*/
                [self shutSceneArea];
            }else{
                [self showSceneArea];
            }
        }
        else
        {
            if (positionWhenOpened - pktGraniczny < rootpos)
            {
                /* przesuniecie w kierunkiu positionWhenOpened */
                [self showSceneArea];
            }else{
                [self shutSceneArea];
            }
        }
    }

}

-(void) shutSceneArea
{
    SKNode * root = [self.scene childNodeWithName:@"MTRoot"];
    
    MTHelpView.helpScreen=hs_desktop_empty;
    SKAction *act = [SKAction moveToX: 0 duration:0.3 ];
    for(UIView * u in self.scene.view.superview.subviews){
        if ([u isKindOfClass:[MTGhostMenuView class]]){
            [(MTGhostMenuView*)u removeFromParent];
        }
    }
    [(MTMainScene *)self.scene prepareSimultaneousNone];
    [self.parent runAction: act
                completion:^{[self.picker fitIconsPPQ];}];
}

-(void) showSceneArea
{
    SKNode * root = [self.scene childNodeWithName:@"MTRoot"];
    float positionWhenOpened = WIDTH - GHOST_BAR_WIDTH;
    
    
    MTHelpView.helpScreen=hs_main_scene;
    [[MTGhostIconNode getSelectedIconNode] makeMeSelectedE];
    SKAction *act = [SKAction moveToX: positionWhenOpened duration:0.3 ];
    [(MTMainScene *)self.scene prepareSimultaneousPinchRotate];
    
    [self.parent runAction: act];
}

-(void) hideBar
{
    
    SKAction * a = [SKAction moveTo: CGPointMake (self.size.width, 0) duration:0.2];
//    self.position = CGPointMake (self.size.width, 0);
    [self runAction:a];
    
    self.isGhostBarOpened = false;
}

-(void) showBar
{
    [[MTAudioPlayer instanceMTAudioPlayer] play:@"background_codeloop"];
    //jezeli okienko z opcjami duszka jest otwarte nie mozna wysunac ghostsBara

    if (!((MTSceneAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"]).menuMode)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MTGhostsBarNode Shown"
                                                            object:self];
        //self.position = CGPointMake (0, 0);
        SKAction * a = [SKAction moveTo: CGPointMake(0, 0) duration:0.2];
        //    self.position = CGPointMake (self.size.width, 0);
        [self runAction:a];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MTGhostIconNode RunAnimation"
                                                            object: self];
        
        self.isGhostBarOpened = true;
        //[self.picker fitIcons];
    }
}


-(void) showBarNM
{
    
    //bez muzyki
    //jezeli okienko z opcjami duszka jest otwarte nie mozna wysunac ghostsBara
    if (!((MTSceneAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"]).menuMode)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MTGhostsBarNode Shown"
                                                            object:self];
        //self.position = CGPointMake (0, 0);
        SKAction * a = [SKAction moveTo: CGPointMake(0, 0) duration:0.2];
        //    self.position = CGPointMake (self.size.width, 0);
        [self runAction:a];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MTGhostIconNode RunAnimation"
                                                            object: self];
        
        self.isGhostBarOpened = true;
    }
}

@end
