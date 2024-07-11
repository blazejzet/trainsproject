
//
//  MTMainScene.m
//  testNodow
//
//  Created by Dawid Skrzypczyński on 18.12.2013.
//  Copyright (c) 2013 UMK. All rights reserved.
//

#import "MTGUI.h"

#import "MTStorage.h"

#import "MTStrategyOfAvailabilityGestures.h"
#import "MTStrategyOfAvailabilityAllGestures.h"
#import "MTStrategyOfAvailabilityNoneGestures.h"

#import "MTStrategyOfSimultanousGestures.h"
#import "MTStrategyOfSimultanousNoneGestures.h"
#import "MTStrategyOfSimultanousPinchRotateGestures.h"
#import "MTStrategyOfSimultanousPanPinchRotateGestures.h"

#import "MTExecutor.h"
#import "MTMainScene.h"
#import "MTExecutionIconNode.h"
#import "MTGhostsBarNode.h"
#import "MTCodeAreaNode.h"
#import "MTCategoryBarNode.h"
#import "MTBlocksAreaNode.h"
#import "MTPlusButtonNode.h"
#import "MTGestureDelegate.h"
#import "MTSpriteNode.h"
#import "MTCategoryIconNode.h"
#import "MTLocomotive.h"
#import "MTBlockNode.h"
#import "MTCodeTabNode.h"
#import "MTTrashNode.h"
#import "MTWheelNode.h"
#import "MTHelpView.h"
#import "MTResources.h"

#import "MTGhostMenuView.h"
#import "MTPhysicsManagement.h"


@interface MTMainScene() <SKPhysicsContactDelegate>

@property CFTimeInterval lastFrameTime;
@property MTExecutor* executor;
@end

@implementation MTMainScene
@synthesize blocked;
@synthesize sceneAreaNode;

static const uint32_t wall  =  0x1 << 0;
static const uint32_t ghost =  0x1 << 1;


-(void)setIsBlocked:(BOOL) y{
    self.blocked=y;
}
-(id)init
{
    self.root = [[MTSpriteNode alloc]init];
    self.root.name = @"MTRoot";
    self.blendMode = SKBlendModeSubtract;
    self.executor = [MTExecutor getInstance];
    //potrzebne do kolizji jak bedziesz Dawidzie je wylanczal to prosze nie usuwaj tej linijki
    self.physicsWorld.contactDelegate = self;
    
    /*Pierwsze strategie*/
    [self prepareSimultaneousNone];
    [self prepareAvailabilityAllGestures];
    
    self.scaleMode=SKSceneScaleModeAspectFill;
    
    return self;
}

-(id)initWithSize:(CGSize)size
{
    
    if(self = [super initWithSize:size])
    {
        self = [self init];
    }
    
    return self;
}

//zwraca pozycje roota 0-startowa, 1-widoczna scena
-(int)rootPosition
{
    if (self.root.position.x == 0)
        return 0;
    else
        return 1;
}
-(MTSceneAreaNode*) prepareSceneArea: (MTSceneAreaNode*) sceneAreaNode
{
    return [self prepareSceneArea:sceneAreaNode :NO];
}
-(MTSceneAreaNode*) prepareSceneArea: (MTSceneAreaNode*) sceneAreaNode :(BOOL)blocked
{
    
    MTHelpView.helpScreen = hs_desktop_empty;
    
    sceneAreaNode = [[MTSceneAreaNode alloc] init];
    sceneAreaNode.blocked=blocked;
    sceneAreaNode.size = CGSizeMake(1024, 768);
    sceneAreaNode.anchorPoint = CGPointMake(0.5, 0.5);
    sceneAreaNode.position = CGPointMake(-432, HEIGHT/2);
    sceneAreaNode.color = [UIColor whiteColor];
    //sceneAreaNode.xScale=1.5;
    // sceneAreaNode.yScale=1.5;
    
    
    MTSpriteNode *leftWall = [[MTSpriteNode alloc] init];
    leftWall.name = @"leftWall";
    leftWall.alpha = 0.0;    leftWall.color = [UIColor redColor];
    leftWall.size = CGSizeMake(50, 768);
    leftWall.position = CGPointMake(-(1024/2)-15, 0);
    leftWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 768)];
    leftWall.physicsBody.dynamic = NO;
    leftWall.physicsBody.categoryBitMask = wall;
    leftWall.physicsBody.contactTestBitMask = ghost;
    leftWall.physicsBody.collisionBitMask = ghost;
    leftWall.physicsBody.mass = 100;
    leftWall.physicsBody.usesPreciseCollisionDetection = NO;
    //tarcie
    leftWall.physicsBody.friction = 0.9f;
    //spowalnianie przesuwania bo nastapilo tarcie
    leftWall.physicsBody.linearDamping = 0.9f;
    [sceneAreaNode addChild:leftWall];
    
    MTSpriteNode *rightWall = [[MTSpriteNode alloc] init];
    rightWall.name= @"rightWall";
    rightWall.alpha = 0.0;    rightWall.color = [UIColor redColor];
    rightWall.size = CGSizeMake(50, 768);
    rightWall.position = CGPointMake(1024/2+15, 0);
    rightWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 768)];
    rightWall.physicsBody.dynamic = NO;
    rightWall.physicsBody.categoryBitMask = wall;
    rightWall.physicsBody.contactTestBitMask = ghost;
    rightWall.physicsBody.collisionBitMask = ghost;
    rightWall.physicsBody.mass = 100;
    rightWall.physicsBody.usesPreciseCollisionDetection = NO;
    //tarcie
    rightWall.physicsBody.friction = 0.9f;
    //spowalnianie przesuwania bo nastapilo tarcie
    rightWall.physicsBody.linearDamping = 0.9f;
    [sceneAreaNode addChild:rightWall];
    
    MTSpriteNode *topWall = [[MTSpriteNode alloc] init];
    topWall.name = @"topWall";
    topWall.color = [UIColor redColor];
    topWall.alpha =0.0;
    topWall.size = CGSizeMake(1048, 50);
    topWall.position = CGPointMake(0, (768/2)+15 );
    topWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1048, 50)];
    topWall.physicsBody.dynamic = NO;
    topWall.physicsBody.categoryBitMask = wall;
    topWall.physicsBody.contactTestBitMask = ghost;
    topWall.physicsBody.collisionBitMask = ghost;
    topWall.physicsBody.mass = 100;
    topWall.physicsBody.usesPreciseCollisionDetection = NO;
    //tarcie
    topWall.physicsBody.friction = 0.9f;
    //spowalnianie przesuwania bo nastapilo tarcie
    topWall.physicsBody.linearDamping = 0.9f;
    [sceneAreaNode addChild:topWall];
    
    MTSpriteNode *bottomWall = [[MTSpriteNode alloc] init];
    bottomWall.name = @"bottomWall";
    bottomWall.color = [UIColor greenColor];
    bottomWall.alpha = 0.0;    bottomWall.size = CGSizeMake(1048, 300);
    bottomWall.position = CGPointMake(0, - (768/2)-(300/2-25) );
    bottomWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1048, 300)];
    bottomWall.physicsBody.dynamic = NO;
    bottomWall.physicsBody.categoryBitMask = wall;
    bottomWall.physicsBody.contactTestBitMask = ghost;
    bottomWall.physicsBody.collisionBitMask = ghost;
    bottomWall.physicsBody.mass = 12200;
    bottomWall.physicsBody.usesPreciseCollisionDetection = NO;
    //tarcie
    bottomWall.physicsBody.friction = 0.9f;
    bottomWall.physicsBody.restitution = 0.0f;
    
    //spowalnianie przesuwania bo nastapilo tarcie
    bottomWall.physicsBody.linearDamping = 0.9f;
    [sceneAreaNode addChild:bottomWall];
    
    sceneAreaNode.zPosition = 0;
    

    
    self.sceneAreaNode = sceneAreaNode;
    return sceneAreaNode;
}
-(MTGhostsBarNode*) prepareGhostBar: (MTGhostsBarNode*) ghostsBarNode
{
    ghostsBarNode = [[MTGhostsBarNode alloc] init];
    
    ghostsBarNode.size = CGSizeMake(GHOST_BAR_WIDTH, HEIGHT);
    ghostsBarNode.anchorPoint = CGPointMake(0, 0);
    ghostsBarNode.position = CGPointMake(0, 0);
    ghostsBarNode.color = [UIColor blueColor];
    
    ghostsBarNode.zPosition = 500;
    
    
    MTSpriteNode* dings=[MTSpriteNode spriteNodeWithImageNamed:@"ghostsBarHakBG"];
    
    if(HEIGHT==1024){
         dings=[MTSpriteNode spriteNodeWithImageNamed:@"ghostsBarHak1024BG"];

    }
    [ghostsBarNode addChild:dings];
    dings.position=CGPointMake(dings.size.width/2, HEIGHT-dings.size.height/2);
    //self.dings.position=CGPointMake(40, self.size.height/2-newPos.y-50);
    //[dings setScale:0.5];
    dings.zPosition=10;

    
    MTExecutionIconNode* compilationIconNode = [[MTExecutionIconNode alloc] init];
    compilationIconNode.position = CGPointMake(0, HEIGHT - 109);
    compilationIconNode.zPosition = 11;
    [ghostsBarNode addChild:compilationIconNode];
    
    return ghostsBarNode;
}
-(MTCodeAreaNode*) prepareCodeArea: (MTCodeAreaNode*) codeAreaNode Parent:(SKNode*) parent
{
    codeAreaNode = [[MTCodeAreaNode alloc] init];
    codeAreaNode.size = CGSizeMake(CODE_AREA_WIDTH, HEIGHT);
    codeAreaNode.anchorPoint = CGPointMake(0, 0);
    codeAreaNode.position = CGPointMake(GHOST_BAR_WIDTH, 0);
    [codeAreaNode initCanvas];
    [codeAreaNode initCodeTabsWithParent: parent];
    
    return codeAreaNode;
}

-(MTCategoryBarNode*) prepareCategoryBar: (MTCategoryBarNode*) categoryBarNode
{
    categoryBarNode = [[MTCategoryBarNode alloc] init];
    categoryBarNode.inactiveCartList=self.inactiveCartList;
    categoryBarNode.size = CGSizeMake(CATEG_BAR_WIDTH, HEIGHT);
    categoryBarNode.anchorPoint = CGPointMake(0, 0);
    categoryBarNode.color = [UIColor greenColor];
    categoryBarNode.position = CGPointMake(WIDTH - categoryBarNode.size.width, 0);
    
    return categoryBarNode;
}

-(MTBlocksAreaNode*) prepareBlocksArea: (MTBlocksAreaNode*) blocksAreaNode
{
    blocksAreaNode = [[MTBlocksAreaNode alloc] initWithImageNamed:@"categoryBG.png"];
    blocksAreaNode.size = CGSizeMake(BLOCK_AREA_WIDTH, HEIGHT);
    blocksAreaNode.anchorPoint = CGPointMake(0, 0);
    blocksAreaNode.position = CGPointMake(CATEG_BAR_WIDTH, 0);
    
    return blocksAreaNode;
}

-(void) prepareGUI{
    [self prepareGUI:nil];
}
-(void)prepareGUI:(NSArray*)lista


{
    ////NSLog(@"Start preparing gui");
    if(!lista){
        self.blocked=NO;
        lista=[NSArray array];}
    else{
        self.blocked=YES;
        [MTResources getInstance:lista];
    }
    self.inactiveCartList = lista;
    
    MTSceneAreaNode *sceneAreaNode;
    sceneAreaNode = [self prepareSceneArea:sceneAreaNode :self.blocked];
    [self.root addChild:sceneAreaNode];
    
    MTGhostsBarNode *ghostsBarNode;
    ghostsBarNode = [self prepareGhostBar: ghostsBarNode];
    [sceneAreaNode addGhostRepresentationNodesWithGhostBar:ghostsBarNode];
    
    MTCodeAreaNode  *codeAreaNode;
    codeAreaNode = [self prepareCodeArea: codeAreaNode Parent: self.root];
    
    MTTrashNode *codeBin;
    codeBin = [[MTTrashNode alloc] init];
    [codeBin setPosition:CGPointMake(50, 50)];
    [codeBin setHidden: true];
    [codeAreaNode setBin:codeBin];
    [self.root addChild:codeAreaNode];
    
    [self.root addChild:ghostsBarNode];
    MTCategoryBarNode *categoryBarNode;
    categoryBarNode = [self prepareCategoryBar: categoryBarNode];
    
    MTBlocksAreaNode *blocksAreaNode;
    blocksAreaNode = [self prepareBlocksArea: blocksAreaNode];
    
    [categoryBarNode addChild:blocksAreaNode];
    
    MTCategoryIconNode *categoryIconNode = [[MTCategoryIconNode alloc] initWithImageNamed:@"categoryLocomotives.png"];
    
    categoryIconNode.size = CGSizeMake(CATEG_BAR_WIDTH*0.8, CATEG_BAR_WIDTH);
    categoryIconNode.anchorPoint = CGPointMake(0,1);
    categoryIconNode.position = CGPointMake(CATEG_BAR_WIDTH*0.1, HEIGHT);
    categoryIconNode.CategoryNumber = 1;
    categoryIconNode.isActive = true;
    categoryIconNode.color = [UIColor colorWithHue:(CGFloat)(categoryIconNode.CategoryNumber)/COLOR_DELIVER saturation:1.0 brightness:0.9 alpha:1.0];
    [categoryBarNode addChild:categoryIconNode];
    
    categoryIconNode = [[MTCategoryIconNode alloc] initWithImageNamed:@"categoryMove.png"];
    categoryIconNode.size = CGSizeMake(CATEG_BAR_WIDTH*0.8, CATEG_BAR_WIDTH);
    categoryIconNode.anchorPoint = CGPointMake(0,1);
    categoryIconNode.position = CGPointMake(CATEG_BAR_WIDTH*0.1, HEIGHT - HEIGHT / 8 );
    categoryIconNode.CategoryNumber = 2;
    categoryIconNode.isActive = true;
    categoryIconNode.color = [UIColor colorWithHue:(CGFloat)(categoryIconNode.CategoryNumber)/COLOR_DELIVER saturation:1.0 brightness:0.9 alpha:1.0];
    [categoryBarNode addChild:categoryIconNode];
    
    categoryIconNode = [[MTCategoryIconNode alloc] initWithImageNamed:@"categoryLoop.png"];
    categoryIconNode.size = CGSizeMake(CATEG_BAR_WIDTH*0.8, CATEG_BAR_WIDTH);
    categoryIconNode.anchorPoint = CGPointMake(0,1);
    categoryIconNode.position = CGPointMake(CATEG_BAR_WIDTH*0.1, HEIGHT - HEIGHT * 2/ 8);
    categoryIconNode.CategoryNumber = 3;
    categoryIconNode.isActive = true;
    categoryIconNode.color = [UIColor colorWithHue:(CGFloat)(categoryIconNode.CategoryNumber)/COLOR_DELIVER saturation:1.0 brightness:0.9 alpha:1.0];
    [categoryBarNode addChild:categoryIconNode];
    
    /*Kategoria MTCategoryControl - powinna byc razem z petlami (MTCategoryLoop)*/
    categoryIconNode = [[MTCategoryIconNode alloc] initWithImageNamed:@"categoryControl.png"];
    categoryIconNode.size = CGSizeMake(CATEG_BAR_WIDTH*0.8, CATEG_BAR_WIDTH);
    categoryIconNode.anchorPoint = CGPointMake(0,1);
    categoryIconNode.position = CGPointMake(CATEG_BAR_WIDTH*0.1, HEIGHT - HEIGHT * 3/ 8);
    categoryIconNode.CategoryNumber = 4;
    categoryIconNode.isActive = true;
    categoryIconNode.color = [UIColor colorWithHue:(CGFloat)(categoryIconNode.CategoryNumber)/COLOR_DELIVER saturation:1.0 brightness:0.9 alpha:1.0];
    [categoryBarNode addChild:categoryIconNode];
    
    /*Kategoria MTCategoryGhost*/
    categoryIconNode = [[MTCategoryIconNode alloc] initWithImageNamed:@"categoryGhost.png"];
    categoryIconNode.size = CGSizeMake(CATEG_BAR_WIDTH*0.8, CATEG_BAR_WIDTH);
    categoryIconNode.anchorPoint = CGPointMake(0,1);
    categoryIconNode.position = CGPointMake(CATEG_BAR_WIDTH*0.1, HEIGHT - HEIGHT * 4/ 8);
    categoryIconNode.CategoryNumber = 5;
    categoryIconNode.isActive = true;
    categoryIconNode.color = [UIColor colorWithHue:(CGFloat)(categoryIconNode.CategoryNumber)/COLOR_DELIVER saturation:1.0 brightness:0.9 alpha:1.0];
    [categoryBarNode addChild:categoryIconNode];
    
    /*Kategoria MTCategoryGhost*/
    categoryIconNode = [[MTCategoryIconNode alloc] initWithImageNamed:@"categoryLogic.png"];
    categoryIconNode.size = CGSizeMake(CATEG_BAR_WIDTH*0.8, CATEG_BAR_WIDTH);
    categoryIconNode.anchorPoint = CGPointMake(0,1);
    categoryIconNode.position = CGPointMake(CATEG_BAR_WIDTH*0.1, HEIGHT - HEIGHT * 5/ 8);
    categoryIconNode.CategoryNumber = 6;
    categoryIconNode.isActive = true;
    categoryIconNode.color = [UIColor colorWithHue:(CGFloat)(categoryIconNode.CategoryNumber)/COLOR_DELIVER saturation:1.0 brightness:0.9 alpha:1.0];
    [categoryBarNode addChild:categoryIconNode];
    
    /*Kategoria SETTINGS*/
    categoryIconNode = [[MTCategoryIconNode alloc] initWithImageNamed:@"categoryOptions.png"];
    categoryIconNode.size = CGSizeMake(CATEG_BAR_WIDTH*0.8, CATEG_BAR_WIDTH);
    categoryIconNode.anchorPoint = CGPointMake(0,1);
    categoryIconNode.position = CGPointMake(CATEG_BAR_WIDTH*0.1, HEIGHT - HEIGHT * 7/ 8);
    categoryIconNode.CategoryNumber = 50;
    categoryIconNode.isActive = true;
    categoryIconNode.color = [UIColor colorWithRed:0.7 green:0.3 blue:0.7 alpha:0.4];
    categoryIconNode.name = @"MTCategoryIconNode50"; //Nazwa uzywana do wyszukania konkretnej ikonki po nazwach dzieci
    [categoryBarNode addChild:categoryIconNode];
    
    SKNode *blockRoot = [[SKNode alloc] init];
    blockRoot.name = @"MTBlockRoot";
    blockRoot.position = CGPointMake(GHOST_BAR_WIDTH, 0);
     
    [self.root addChild:categoryBarNode];
    [self.root addChild:blockRoot];
    [blockRoot addChild:codeBin];
    
    categoryBarNode.positionWhenOpened = WIDTH - (categoryBarNode.size.width + blocksAreaNode.size.width);

    //dodanie pierwszego duszka
    if (ghostsBarNode.icons.count == 0)
        [ghostsBarNode addNewGhostIcon];

    [(MTCodeAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCodeAreaNode"] selectFirstTab];
    [(MTCodeAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCodeAreaNode"] categoryBarInit];
    
    [self addChild:self.root];
    [self.root setPosition:CGPointMake(self.frame.size.width-GHOST_BAR_WIDTH, 0)];
    
    [self performSelector:@selector(setSceneHelp) withObject:nil afterDelay:2.0];
    [[MTGhostIconNode getSelectedIconNode] makeMeSelected];
     [[MTGhostIconNode getSelectedIconNode] makeMeSelectedE];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: N_MTMainSceneDidInit object:self];
    ////NSLog(@"End preparing gui");

}

-(void)setSceneHelp{
    MTHelpView.helpScreen=hs_main_scene;
}

/*funkcja wykonująca się przed pierwszym wyswietleniem klatki obrazu*/

-(void) didMoveToView: (SKView *) view
{
    
    UITapGestureRecognizer* tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(findTouchedNode:)];
    
    UITapGestureRecognizer* tgr2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(findDTappedNode:)];
    tgr2.numberOfTapsRequired=2;
    
    UIPanGestureRecognizer* sgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(findPannedNode:)];
    UIPinchGestureRecognizer* pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(findPinchedNode:)];
    UIRotationGestureRecognizer* rot = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(findRotatedNode:)];
    UISwipeGestureRecognizer* swp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(findSwipeNode:)];
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(findVeryHoldedNode:)];
   
    
    
    longPressGestureRecognizer.minimumPressDuration = 0.32;
    
    
   // UILongPressGestureRecognizer *verylongPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(findVeryHoldedNode:)];
    
    
   // verylongPressGestureRecognizer.minimumPressDuration = 1.0;
   // verylongPressGestureRecognizer.cancelsTouchesInView=NO;
    swp.cancelsTouchesInView=NO;
    sgr.cancelsTouchesInView=NO;
    tgr.cancelsTouchesInView=NO;
    longPressGestureRecognizer.cancelsTouchesInView=NO;
    
    pin.delegate = self;
    rot.delegate= self;
    sgr.minimumNumberOfTouches =1;
    sgr.delegate = self;
    tgr.delegate = self;
    swp.delegate = self;
    
    [view addGestureRecognizer:tgr]; //tap
    [view addGestureRecognizer:tgr2]; //tap2
    
    [view addGestureRecognizer:sgr]; //pan
    [view addGestureRecognizer:pin]; //pinch
    [view addGestureRecognizer:rot]; //rotate
    [view addGestureRecognizer:swp]; //swipe
    [view addGestureRecognizer:longPressGestureRecognizer]; // hold
    //[view addGestureRecognizer:verylongPressGestureRecognizer]; // veryLongHold

    //verylongPressGestureRecognizer.delegate= self;
    //verylongPressGestureRecognizer
    longPressGestureRecognizer.delegate=self;
    
    self.physicsManagement = [[MTPhysicsManagement alloc] initWithScene:self];
    
}


/* funkcja wywoywana przed wyrysowaniem kazdej klatki obrazu */
-(void)update:(CFTimeInterval)currentTime {
    //static int M = 0;
    CFTimeInterval timeSinceLastUpdate = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Update" object:self];
    if ([self.executor simulationStarted])
    {
        {
            if (self.lastFrameTime != 0)
            {
                timeSinceLastUpdate = currentTime - self.lastFrameTime;
            }
            [self.executor processFrameOfSimulationWithTime:timeSinceLastUpdate];
        }
        
    }
    self.lastFrameTime=currentTime;
}

-(void)didEvaluateActions
{

}

//-------------------------------
//     GESTY
//-------------------------------
//wykonywanie kilku gestow jednoczesnie
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return[self.simultaneousGesturesStrategy
           gestureRecognizer: gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer: otherGestureRecognizer];
    //return self.simultaneousGestures;
}

-(void)prepareSimultaneousPanPinchRotate;
{
    self.simultaneousGesturesStrategy = [MTStrategyOfSimultanousPanPinchRotateGestures getInstance];
}
-(void)prepareSimultaneousNone
{
    self.simultaneousGesturesStrategy = [MTStrategyOfSimultanousNoneGestures getInstance];
}
-(void)prepareSimultaneousPinchRotate;
{
    self.simultaneousGesturesStrategy = [MTStrategyOfSimultanousPinchRotateGestures getInstance];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return [self.availabilityGesturesStrategy gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
}

-(void)prepareAvailabilityAllGestures
{
    self.availabilityGesturesStrategy = [MTStrategyOfAvailabilityAllGestures getInstance];
}

-(void)prepareAvailabilityNoneGestures
{
    self.availabilityGesturesStrategy = [MTStrategyOfAvailabilityNoneGestures getInstance];
}

/* funkcja znajduje dotkniety wezel po dotknieciu MainScene*/
- (SKSpriteNode *)findNode:(UIGestureRecognizer *)g
{
    
    CGPoint ourLocation = CGPointMake([g locationInView:self.view].x, HEIGHT - [g locationInView:self.view].y);
    MTSpriteNode * newNode = (MTSpriteNode *)[self nodeAtPoint:ourLocation];
    
    if(newNode!=self.selectedNode && [newNode isKindOfClass: [MTSpriteNode class] ]){
        self.selectedNode.selected=false;
        self.selectedNode = newNode;
    }
    
    if ([g locationInView:self.view].x <= WIDTH - CATEG_BAR_WIDTH - BLOCK_AREA_WIDTH && // jezeli wykonano gest po lewej stronie ekranu
        [(MTCategoryBarNode*)[[self childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"] isOpened]&& // przy otwartym CategoryBar
        ! [g isKindOfClass: [UILongPressGestureRecognizer class]]) //dla każdego gestu oprócz hold'a
    {
        [(MTCategoryBarNode*)[[self childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"] closeBlocksArea];
        
        if ([(MTCategoryBarNode*)[[self childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"] isAppOptionsOpened])
            [(MTCategoryBarNode*)[[self childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"] closeAppOptions];
    }
    
    return self.selectedNode;
}


/* funkcja znajduje dotkniety wezel po dotknieciu MainScene*/
- (SKSpriteNode *)find2Node:(UIGestureRecognizer *)g
{
    
    CGPoint ourLocation = CGPointMake([g locationInView:self.view].x, HEIGHT - [g locationInView:self.view].y);
    MTSpriteNode * newNode = (MTSpriteNode *)[self nodeAtPoint:ourLocation];
    
    
    return newNode;
}


- (SKSpriteNode *)findNodeWhenGestureBegins:(UIGestureRecognizer *)g
{
    if(g.state == UIGestureRecognizerStateBegan)
        [self findNode: g ];
    
    return self.selectedNode;
}



- (void) findDTappedNode:(UIGestureRecognizer*)g
{
    
    @try {
        SKSpriteNode * s =[self find2Node: g];
        ////NSLog(@"NODE 2tapped: %@",s);
        
        NSString *description = [s.texture description];
        NSRange range = [description rangeOfString:@"'"];
        NSString *textureName = [description substringFromIndex:NSMaxRange(range)];
        range = [textureName rangeOfString:@"'"];
        textureName = [textureName substringToIndex:NSMaxRange(range) - 1];
        
        [MTHelpView showInstantHelp:s.name icon:textureName scenePosition:CGPointMake(s.frame.origin.x+s.size.width/2, s.frame.origin.y+s.size.height/2) node:s];
        

    } @catch (NSException *exception) {
        //<#Handle an exception thrown in the @try block#>
    } @finally {
        //<#Code that gets executed whether or not an exception is thrown#>
    }
    //if ([self.selectedNode isKindOfClass: [MTSpriteNode class]]){
       // [((MTSpriteNode* ) self.selectedNode) tapGesture:g];
        //[((MTSpriteNode* ) self.selectedNode) animateTap];
    //}
    
    
}
- (void) findTouchedNode:(UIGestureRecognizer*)g
{
    [self findNode: g];
    
    if ([self.selectedNode isKindOfClass: [MTSpriteNode class]]){
        [((MTSpriteNode* ) self.selectedNode) tapGesture:g];
        //[((MTSpriteNode* ) self.selectedNode) animateTap];
    }
}

- (void) findPannedNode:(UIGestureRecognizer*)g
{
    [self findNodeWhenGestureBegins:g];
    
    if ([self.selectedNode isKindOfClass: [MTSpriteNode class]])
        [((MTSpriteNode* ) self.selectedNode) panGesture:g :self.view];
}

- (void) findPinchedNode:(UIGestureRecognizer*)g
{
    [self findNodeWhenGestureBegins:g];
    [((MTSpriteNode* ) self.selectedNode) pinchGesture:g :self.view];
}

- (void) findRotatedNode:(UIGestureRecognizer*)g
{
    [self findNodeWhenGestureBegins:g];
    [((MTSpriteNode* ) self.selectedNode) rotateGesture:g :self.view];
    
}

- (void) findSwipeNode:(UISwipeGestureRecognizer*)g
{
    [self findNodeWhenGestureBegins:g];
    [((MTSpriteNode* ) self.selectedNode) swipe:g :self.view];
}

-(void) findHoldedNode:(UIGestureRecognizer*)g
{
    ////NSLog(@"SREDNIO!!!!");
    [self findNodeWhenGestureBegins:g];
    MTSpriteNode* sel = (MTSpriteNode* ) self.selectedNode;
    if(!sel.selected){
        sel.selected=true;
        //[sel animateTap];
    }

    [((MTSpriteNode* ) self.selectedNode) hold:g :self.view];
}


-(void) findVeryHoldedNode:(UIGestureRecognizer*)g
{
    if (g.state==UIGestureRecognizerStateBegan){
        ////NSLog(@"DLUGO!!!!");
        [self findNodeWhenGestureBegins:g];
        [((MTSpriteNode* ) self.selectedNode) holdGesture:g :self.view];
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    [self.physicsManagement manageCollision:contact];
}

@end
