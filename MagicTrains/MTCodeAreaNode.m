
//
//  MTCodeAreaNode.m
//  testNodow
//
//  Created by Dawid Skrzypczyński on 18.12.2013.
//  Copyright (c) 2013 UMK. All rights reserved.
//

#import "MTCodeAreaNode.h"
#import "MTCodeAreaCanvasNode.h"
#import "MTCodeTabNode.h"
#import "MTCategoryBarNode.h"
#import "MTGhostsBarNode.h"
#import "MTGhostIconNode.h"
#import "MTGhost.h"
#import "MTCart.h"
#import "MTRecieveSignalLocomotiv.h"
#import "MTStorage.h"

#import "MTBlockNode.h"
#import "MTGUI.h"
#import "MTLabelNode.h"
#import "MTTrackInsideNode.h"
#import "MTTrackStartNode.h"
#import "MTTrainNode.h"
#import "MTTrashNode.h"
#import "MTSubTrain.h"
#import "MTSubTrainCart.h"
#import "MTMainScene.h"
#import "MTNotSandboxProjectOrganizer.h"

@interface MTCodeAreaNode ()
@property SKSpriteNode* dings;

@end

@implementation MTCodeAreaNode
@synthesize dings,tabParent;


-(void)deNotify{
    NSLog(@"Removing from NSNotificationCenter MTCodeAreaNode");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(id) init {
    if ((self = [super init]))
    {
           self = [self initWithImageNamed:@"scene_bg"];
        //self = [self initWithImageNamed:@"white"];
        
        self.name = CODE_AREA_NODE_NAME;
        self.color = [UIColor colorWithWhite:0.1 alpha:1];
        self.colorBlendFactor = 0.9;
        [MTCodeTabNode resetSelectedPointer];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(update:)
                                                     name:@"SelectedGhostIcon Changed"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(update:)
                                                     name:N_MTMainSceneDidInit
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onTrainRemoved:)
                                                    name:@"Train Removed"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onSubTrainChanged:)
                                                     name:@"Cart Removed"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onSubTrainChanged:)
                                                     name:@"SubTrain Changed"
                                                   object:nil];

       
    }
    return self;
}

-(int) getSelectedTabNumber
{
    int val = [MTCodeTabNode getSelectedTab].tabNumber;
    return val;
}

-(MTTrain *) addNewTrainIntoGhost:(MTGhost *) ghost AtPosition:(CGPoint) pt
{
    MTTrain *t = [[MTTrain alloc]initWithTabNr: [self getSelectedTabNumber]
                                         ghost: ghost
                                      position: pt];
    [ghost addTrain:t];
    
    [t setMyNumber: [ghost.trains indexOfObject:t]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(update:)
                                                 name:@"Train Changed"
                                               object:t];
    
    return t;
}

-(void) removeTrain:(MTTrain *) train FromGhost:(MTGhost *) ghost
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"Train Changed"
                                                  object:train];
    [ghost removeTrain:train];
}

///TODO Przemek sprawdzic montowanie spadającego tutaj bloczka

/* Funkcja wywołuje się gdy zostaje upuszczony bloczek na CodeArea*/
-(void) blockDrop:(MTBlockNode *) droppedBlock
{
    if ([self getSelectedTabNumber] == 0 && [MTStorage getInstance].ProjectType == MTProjectTypeLearn) return;
    MTCategoryBarNode * catBar = ( MTCategoryBarNode * ) [[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
    
    if (![catBar isOpened] && ([droppedBlock.parent.name isEqualToString:@"MTCodeAreaNode"] || [droppedBlock.parent.name isEqualToString:@"MTBlockRoot"]))
    {
        /* Stworzenie pociagu */
        MTGhost *gt = [MTGhostIconNode getSelectedIconNode].myGhost;
        MTTrain *t  = nil;
        CGPoint trainPosition = CGPointMake(droppedBlock.position.x, droppedBlock.position.y - self.position.y);
        
        t = [self addNewTrainIntoGhost: gt AtPosition: trainPosition];
        
        
        if(![t addCart:[droppedBlock.myCart getNewWithSubTrain:t.mainSubTrain]])
        {
            [self removeTrain:t FromGhost:gt];
        }
    }
}
/**********************************************/
/**                  GESTY!!!                **/
/**********************************************/


-(void) tapGesture:(UIGestureRecognizer *)g {
     [(MTCategoryBarNode *)([[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"]) closeBlocksArea];
}

-(void) panGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    static CGPoint firstpt;
    static CGPoint recpt;
    CGPoint pt = [g locationInView:v];
    
    if (g.state == UIGestureRecognizerStateBegan)
    {
        recpt = pt;
        firstpt = pt;
    }
    
    [self moveMeInYWithCurrentPoint: pt AndRecentPoint: recpt];
    
    [self moveMeInXWithCurrentPoint: pt AndRecentPoint: recpt];
    
    if (g.state == UIGestureRecognizerStateEnded)
    {
        SKAction *act = [SKAction moveToX: 0.0 duration:0.2];
        if(firstpt.x - pt.x < - DEAD_ZONE_GESTURE /2)//Przesuwanie w prawo
             act = [SKAction moveToX: WIDTH - GHOST_BAR_WIDTH duration:0.2 ];
        SKNode * root = [self.scene childNodeWithName:@"MTRoot"];
        //[root setPosition:firstpt];
        /* przesuniecie w kierunkiu positionWhenOpened */
        MTHelpView.helpScreen=hs_main_scene;
        [[MTGhostIconNode getSelectedIconNode] makeMeSelectedE];
        [root runAction:act];
    }
    
    recpt = pt;
    
    
}

/******/
/**  **/
/******/

/* Procedura inicjujaca zakladki*/
-(void) initCodeTabsWithParent:(SKNode*) parent
{
    int N = 5;
    self.tabParent= [[SKNode alloc] init];
    [tabParent setPosition:self.position];
    [tabParent setName:@"MTTabParentNode"];
    
    [parent addChild: tabParent];

    for (int i=0; i<N ; i++)
    {
        UIColor *col;
            col = [UIColor brownColor];
        
        MTCodeTabNode *tab;
        
        if(i<CLONE_TAB){
            tab = [[MTCodeTabNode alloc] initWithImageNamed:@"codeTab.png" ];
        } else {
            tab = [[MTCodeTabNode alloc] initWithImageNamed:@"cloneCodeTab.png" ];
        }
        
        tab.size = CGSizeMake(self.size.width/N , TAB_HEIGHT );
        tab.anchorPoint = CGPointMake(0,1);
        tab.position = CGPointMake(i * self.size.width/N, self.size.height);
        tab.zPosition = 200.0;
        tab.name = [NSString stringWithFormat:@"MTCodeTabNode%i" ,i];
        tab.tabNumber = i;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(update:)
                                                     name:@"Tab"
                                                   object:tab];
        [tabParent addChild:tab ];
    }
    
    [self selectFirstTab];
    
    [self categoryBarInit];
}

-(void) categoryBarInit
{
    MTStorage *storage = [MTStorage getInstance];
    if (storage.ProjectType == MTProjectTypeLearn)
    {
        MTCategoryBarNode* cbn = (MTCategoryBarNode*) ([[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"]);
        [cbn unactiveAllCategories];
    }
}

-(void) selectFirstTab
{
    //zaznaczenie pierwszego taba
    MTCodeTabNode* codeTab = (MTCodeTabNode*) [tabParent childNodeWithName:@"MTCodeTabNode0"];
    
    [codeTab makeMeSelected];
    
}

/******************************/
/*        Teksturowanie       */
/******************************/

-(void) initCanvas
{
    self.primaryCanvas = [[MTCodeAreaCanvasNode alloc]initWithTexture:self.texture Size:self.size];
    [self addChild: self.primaryCanvas];
    
    self.canvasCounter = 1;
}
-(void) addCanvas
{
    MTCodeAreaCanvasNode* secondaryCanv = [[MTCodeAreaCanvasNode alloc]initWithTexture:self.texture Size:self.primaryCanvas.size];
    secondaryCanv.position = CGPointMake(0, - ( (int) self.canvasCounter * HEIGHT));
    [self.primaryCanvas addChild:secondaryCanv];
    self.canvasCounter += 1;
    //self.dings.position=CGPointMake(22, self.frame.size.height/2-self.position.y-55);
      //self.dings.zPosition=2000;
    
}
-(void) resetCanvas
{
    [self.primaryCanvas removeAllChildren];
    self.canvasCounter = 1;
}
-(void) calculateUsedTexture
{
    [self resetCanvas];
    while (self.size.height > HEIGHT * self.canvasCounter)
    {
        [self addCanvas];
    }
}


 /****************************/
/**                          **/
/*      Strefa Refreshu       */
/**                          **/
 /****************************/

-(void) addNewBlockWithCart:(MTCart *)cart AtPosition:(CGPoint)pos
                  FromSubTrain:(MTSubTrain *)subtrain
{
    MTBlockNode *destiny = [[MTBlockNode alloc] initWithCart:cart];
    destiny.position = pos;
    destiny.myCart.mySubTrain = subtrain;
    
    [self addChild:destiny];
}

-(void) addNewBlockWithCart:(MTCart *) cart  AtPosition:(CGPoint) pos
                  FromSubTrain:(MTSubTrain *)subtrain     ToNode:(SKNode *) node
{
    MTBlockNode *destiny = [[MTBlockNode alloc] initWithCart:cart];
    destiny.position = pos;
    destiny.myCart.mySubTrain = subtrain;
    
    [node addChild:destiny];
}


-(CGPoint)calculateTrainPositionWithNr:(uint)T
{
    return CGPointMake( T * BLOCK_WIDTH + BLOCK_WIDTH/2,HEIGHT - TAB_HEIGHT - BLOCK_HEIGHT/2);
}

-(void) calculateMyHeight
{
    CGFloat min = 0;
    
    for (NSUInteger i = 0; i < [[self children] count]; i++)
    {
        float lenghtOfTrain = 0;
        
        if ([[self children][i] class] == [MTTrainNode class])
        {
            lenghtOfTrain = [(MTTrainNode*) [self children][i] getMyHeightRecursive];
            if (min > [[self children][i] position].y - lenghtOfTrain)
            {
                min = [[self children][i] position].y - lenghtOfTrain;
            }
        }
    }
    CGFloat NewHeight = HEIGHT + TRACK_HEIGHT - min ;

    if (NewHeight != self.size.height)
    {
        if (NewHeight > HEIGHT)
        {
            self.size = CGSizeMake(self.size.width, NewHeight);
            self.anchorPoint = CGPointMake(0, 1 - (HEIGHT / self.size.height));
        }
        else
        {
            self.size = CGSizeMake(self.size.width, HEIGHT);
            self.anchorPoint = CGPointMake(0, 1 - (HEIGHT / self.size.height));
        }
        
    }
    [self calculateUsedTexture];
}

-(void) updateCodeTabPositionWithName:(NSString *)str
{
    SKNode *tabNode = [self childNodeWithName:str ];
    if ( tabNode != nil )
    {
        tabNode.position = CGPointMake(tabNode.position.x, self.size.height);
    }
}
-(void) updateCanvasPosition
{
    if ( self.primaryCanvas != nil )
    {
        self.primaryCanvas.position = CGPointMake(self.primaryCanvas.position.x, self.size.height);
    }
}
-(void) removeTrainNode:(SKNode *) trainNode
{
    [trainNode removeAllChildren];
    [trainNode removeFromParent];
}
/* dodanie zestawu bloczków które są w hierarchii poniżej MTTrainNode*/
-(SKNode *) DoMakeTrainNodeOfBlocksFromTrain: (MTSubTrain *) subTrain AtPos:(CGPoint) pos
{
    MTTrainNode*  trainNode = [[MTTrainNode alloc] initWithPositon:pos];
    //[trainNode setMainTrainNode:nil];
    
    //Dodawanie poczatku torow
    MTTrackStartNode *trailStart = [[MTTrackStartNode alloc] initWithSubTrain: subTrain NextCartIndex:0];
    [trainNode addChild:trailStart];
    
    [trainNode showSubTrain:subTrain];
    return trainNode;
}

-(void) removeChildren
{
    /*usuwanie bloczkow */
    SKNode *trainNode = [self childNodeWithName: @"MTTrainNode"];
    while ( trainNode != nil )
    {
        @try {
            [trainNode removeAllChildren];
            [trainNode removeFromParent];
            trainNode = [self childNodeWithName: @"MTTrainNode"];
        } @catch (NSException *exception) {
        } @finally {
        }
    }
    
}


/**********************************************/
/**********************************************/
/*****             REFRESH!!!             *****/
/**********************************************/
/**********************************************/


-(void) showArrayOfTrains:(NSArray*)trains
{
    //MTGhost *selectedGhost = [(MTGhostsBarNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTGhostsBarNode"] getSelectedGhost];
    for(int i=0; i<trains.count; i++)
    {
        ////NSLog(@"Train nr:%i",i);
        if (trains[i] ){
            MTHelpView.helpScreen=hs_desktop_notempty;
            [self showTrain:(id) trains[i]];
        }
    }
}
-(void) showTrain:(MTTrain *)train
{
    if(train.tabNr == [MTCodeTabNode getSelectedTab].tabNumber)
    {
        if (! iPadPro && train.positionInCodeArea.y > [self maxTrainYPos ] )
            train.positionInCodeArea = CGPointMake(train.positionInCodeArea.x, [self maxTrainYPos ]);
        [self addChild:
         [self DoMakeTrainNodeOfBlocksFromTrain: train.mainSubTrain
                                          AtPos:train.positionInCodeArea]];
    }
}
-(CGFloat) maxTrainYPos
{
    return /*self.size.height*/ HEIGHT - (TRACK_HEIGHT + 50 + TAB_HEIGHT);
}

-(void) refreshCode
{
    NSLog(@"refresh");
    SKNode * root = [self.scene childNodeWithName:@"MTRoot"];
    SKNode * gbar = [root childNodeWithName:@"MTGhostsBarNode"];
    MTGhost *selectedGhost = [(MTGhostsBarNode *)gbar getSelectedGhost];
    
    if(selectedGhost)
    {
        /* przegladanie pociagow */
        
        for(int i=0; i<selectedGhost.trains.count; i++)
        {
            //////NSLog(@"Train nr:%i",i);
            if (selectedGhost.trains[i] ){
                if(MTHelpView.helpScreen != hs_characters){
                    MTHelpView.helpScreen=hs_desktop_notempty;
                }
                [self showTrain: (MTTrain *) selectedGhost.trains[i]];
            }
        }
        
        [self calculateMyHeight];
    }else{
        ////NSLog(@"No Selected Ghost");
    }
    
}



-(void) update:(NSNotification *) notif
{
    //////NSLog(@"notyfa do update'u: %@",notif.name);
    [self removeChildren];
    [self refreshCode];
    //[self calculateMyHeight];
    [self putMeIntoGoodPosition:self.position];
    [[MTNotSandboxProjectOrganizer getInstance] preprareCategoryIconsForThisTap];
    [[MTNotSandboxProjectOrganizer getInstance] updateTabTextures];
    
    
}

-(void)closeBlocksArea
{
    MTCategoryBarNode * catbar = (id) [[self.scene childNodeWithName:@"MTRoot" ] childNodeWithName:@"MTCategoryBarNode"];
    
    [catbar closeBlocksArea ];
}

-(void) holdedBlock : (MTBlockNode *)block
{
    //self.block = block;
}

-(void) onTrainRemoved:(NSNotification *)notify
{
    MTTrain* train = (MTTrain*) notify.object;
    for (SKNode* child in [self children]) {
        if (child && [child isKindOfClass:[MTTrainNode class]])
        {
            MTTrainNode * trainNode = (MTTrainNode *)child;
            if([[trainNode myTrain] isEqual: train]){
                
                [self removeTrainNode:trainNode];
                trainNode = nil;
            }
            
        }
    }
}

-(void) onSubTrainChanged:(NSNotification *)notify
{
    MTTrain* train = (MTTrain*) notify.object;
    for (SKNode* child in [self children]) {
        if (child && [child isKindOfClass:[MTTrainNode class]])
        {
            MTTrainNode * trainNode = (MTTrainNode *)child;
            if([[trainNode myTrain] isEqual: train]){
                [self removeTrainNode:trainNode];
                [self showTrain:trainNode.myTrain];
                trainNode = nil;
                [self calculateMyHeight];
            }
            
        }
    }
}
////
// IMPLEMENTACJA PRZESOWANIA
////
-(void) moveMeInXWithCurrentPoint:(CGPoint) pt AndRecentPoint:(CGPoint) recpt
{
    if ([[self parent] position].x + (pt.x - recpt.x) >= 0.0)
    {
       [[self parent]runAction:[SKAction moveByX: pt.x - recpt.x y:0 duration:0]];
    }
}
- (void) moveMeInYWithCurrentPoint:(CGPoint) pt AndRecentPoint:(CGPoint) recpt
{
    [self runAction:[SKAction moveByX:0
                                    y:recpt.y - pt.y
                             duration:0]
         completion:^{
             [self putMeIntoGoodPosition: [self position]];
         }
     ];
}

-(void) putMeIntoGoodPosition:(CGPoint) newPos
{
    //////NSLog(@"ss");
    
    SKAction * act;
    SKAction * act2;
    
    CGFloat lowestPosition = 0.0;
    CGFloat heighestPosition = self.size.height - HEIGHT;
    //if (newPos.y > lowestPosition && newPos.y < heighestPosition ){
    //self.dings.position=CGPointMake(22, self.size.height/2-newPos.y-55);
    
    //}
    
    if (newPos.y < lowestPosition)
    {
        act =[SKAction moveToY:lowestPosition
                      duration:0.1];
        act2 =[SKAction moveToY:self.size.height/2-lowestPosition-55
                       duration:0.1];
        
    }
    else if(newPos.y > heighestPosition)
    {
        act =[SKAction moveToY:heighestPosition
                      duration:0.1];
        act2 =[SKAction moveToY:self.size.height/2-heighestPosition-55
                       duration:0.1];
    }
    [self runAction:act];
    //[dings runAction:act2];
    
}
@end
