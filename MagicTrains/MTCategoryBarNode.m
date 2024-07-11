//
//  MTCategoryBarNode.m
//  testNodow
//
//  Created by Dawid Skrzypczyński on 18.12.2013.
//  Copyright (c) 2013 UMK. All rights reserved.
//
#import "MTGUI.h"
#import "MTCategoryBarNode.h"
#import "MTBlocksAreaNode.h"
#import "MTBlockNode.h"
#import "MTMainScene.h"
#import "MTCategoryIconNode.h"
#import "MTResources.h"
#import "MTCodeTabNode.h"
#import "MTAppOptionNode.h"
#import "MTCodeBlockNode.h"
#import "MTCodeAreaNode.h"

#import "MTWheelNode.h"
#import "MTGlobalVar.h"
#import "MTVisibleGlobalVar.h"
#import "MTGlobalVarForSetNode.h"
#import "MTConditionNode.h"
#import "MTRibbon.h"

@implementation MTCategoryBarNode

@synthesize inactiveCartList;
@synthesize cartsInCategories;

-(id) init {
    if ((self = [super init]))
    {
        self = [self initWithImageNamed:@"categoryBarBG.png"];
        self.name = @"MTCategoryBarNode";
        self.positionWhenOpened = WIDTH - CATEG_BAR_WIDTH - BLOCK_AREA_WIDTH;
        MTBlocksAreaNode  *blocksAreaNode = [[MTBlocksAreaNode alloc] init];
        
        [self addChild:blocksAreaNode];
        
        self.someOptionsOpened = false;
        
        self.zPosition = 500;
        
        MTRibbon *ribbon3 = [[MTRibbon alloc]init];
        //[ribbon2 setScale:0.5];
        [self addChild:ribbon3];
        ribbon3.position=CGPointMake(-ribbon3.size.width/2, HEIGHT-ribbon3.size.height/2);
        
        

    }
    return self;
}

/* obsluga gestu */
-(void) tapGesture:(UIGestureRecognizer *)g {

}

- (void)move:(UIGestureRecognizer *)g v:(UIView *)v
{
    
    float positionWhenClosed = (WIDTH - self.size.width);
    
    CGPoint r;
    r = [self newPositionHorizontallyWithGesture:g inView:v inReferenceTo:self.parent];
    if (r.x >= self.positionWhenOpened && r.x <= positionWhenClosed)
        self.position = r;
}

-(void) openBlocksArea
{
   // if (self.someOptionsOpened == false) {
    
    [self refreshBlocks];
    
    if (!self.isOpened)
    {
        self.isOpened = true;
        SKAction *act;
        act = [SKAction moveByX: self.positionWhenOpened - self.position.x
                              y:0.0
                       duration:0.2 ];
        [self runAction: act];
    }
    
    //} else [self removeAllActions];
}

-(void) openBlocksAreaWithOptionsForBlock :(MTBlockNode*) block
{
    //if (self.someOptionsOpened == false) {
   
        [self closeAppOptions];
        [self openBlocksArea];
        self.optionsBlock = block;
        [((MTCategoryIconNode*)[self childNodeWithName:@"MTCategoryIconNode50"]) makeMeSelected];
        
   // }
}

-(void) closeBlocksArea
{
    if (self.isOpened && !self.hasActions)
    {
        //[self removeallBlocks];
        
        float positionWhenClosed = (WIDTH - CATEG_BAR_WIDTH);
        
        [[MTCategoryIconNode getSelectedIconNode] makeMeUnselected];
        
        SKAction *act;
        act = [SKAction moveByX: positionWhenClosed - self.position.x
                              y:0.0
                       duration:0.2 ];
        [self runAction: act];
        
        for (MTSpriteNode* child in self.children)
        {
            if ([child isKindOfClass:[MTCategoryIconNode class]])
                child.colorBlendFactor = 0.0;
        }
        
        self.isOpened = false;
        
    }
    
    if (self.optionsBlock != nil)
    {
        [[MTCodeBlockNode getSelectedBlockForOptions] makeMeUnselected];
        [self.optionsBlock.myCart hideOptions];
        [(MTMainScene *) self.scene prepareSimultaneousNone];
    }
}

-(void) panGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    /*  Wywolanie funkcji ktora przesowa CatergoryBar na pozycje kursora na ekranie. */
    if (g.state == UIGestureRecognizerStateBegan)
    {
        [self refreshBlocks];
    }
    
    /*Warunek blokujacy przesuwanie CategoryBarNode kiedy nie ma aktywnej kategorii*/
    if ([MTCategoryIconNode getSelectedIconNode] != nil)
    {
        //[self move:(UIGestureRecognizer *)g v:(UIView *)v];

    
        //float avg = (1024 - CATEG_BAR_WIDTH + self.positionWhenOpened) / 2 ;
    
        if (g.state == UIGestureRecognizerStateEnded)
        {
            if (!self.isOpened)
            {
                [self openBlocksArea];
            }
                else
                {
                    [self closeBlocksArea];
                }
        }
    }
}

-(CGPoint)calculatePositionWithBlockNr:(uint)B
{
    if ([MTCategoryIconNode getSelectedIconNode].CategoryNumber==5)
    {
        
        return CGPointMake( 1+ B%5 * ( BLOCK_WIDTH -12) + BLOCK_WIDTH /2 + 2.5 + CATEG_BAR_WIDTH,
                           -20+HEIGHT - BLOCK_HEIGHT /2 - 2.5 - B/5 * ( BLOCK_HEIGHT + 5));
        
    } else {
        
        return CGPointMake( 1+ B%5 * ( BLOCK_WIDTH - 12) + BLOCK_WIDTH /2 + 2.5 + CATEG_BAR_WIDTH,
                           -20+HEIGHT - BLOCK_HEIGHT /2 - 2.5 - B/5 * ( BLOCK_HEIGHT + 15));
    }
}

-(void)removeAllBlocks
{
    for(MTSpriteNode* child in self.children)
    {
        if([child.name isEqualToString:@"MTBlockNode"])
            [child runAction:[SKAction sequence:@[[SKAction moveToX:2000 duration:0.5],\
                                                  [SKAction removeFromParent]]\
                              ]];
    }
}

-(void)refreshBlocks
{

    [self removeAllBlocks];
    
    int count = 0;
    bool showCart;
    
    for (NSString * sourceCartType in [MTResources getInstance].keys)
    {
        MTCart* sourceCart = [[MTResources getInstance].carts valueForKey:sourceCartType];

        if ([sourceCart getCategory] == [MTCategoryIconNode getSelectedIconNode].CategoryNumber )
        {
                [self addBlockWithCart: sourceCart  AtPosition: [self calculatePositionWithBlockNr:count]];
                count++;
            
        }
    }
}

-(void)addBlockWithCart:(MTCart *)cart AtPosition: (CGPoint) pos
{
    MTBlockNode *blockNode = [[MTBlockNode alloc] initWithCart:cart];
    blockNode.position = CGPointMake(pos.x+WIDTH+BLOCK_WIDTH, pos.y);
    blockNode.alpha = 0.0;
    
    [self addChild:blockNode];
    
    SKAction *element1;
    if ([cart isActive])
    {
        element1 = [SKAction fadeAlphaTo:1.0 duration:0.1];
    }
    else
    {
        //TU TRZEBA COS FAJNEGO ZROBIC
        element1 = [SKAction fadeAlphaTo:0.5 duration:0.1];
        blockNode.color = [UIColor grayColor];
        blockNode.blendMode = SKBlendModeAdd;
        blockNode.colorBlendFactor = 1.0;

    }
    SKAction *element2 = [SKAction moveToX:pos.x duration:0.4];
    SKAction *element3 = [SKAction fadeAlphaTo:0.1 duration:0.3];
    SKAction *element4 = [SKAction sequence:@[element3, element1]];
    
    [blockNode runAction:[SKAction group:@[element4, element2]]];
}

//zamkniecie opcji bloczku
-(void) closeOpenedOptions {
    if (self.optionsBlock != nil)
    {
        [[MTCodeBlockNode getSelectedBlockForOptions] makeMeUnselected];
        [self.optionsBlock.myCart hideOptions];
    }
}

-(void) openAppOptions
{
    if (!self.isAppOptionsOpened)
    {
        self.isAppOptionsOpened = true;
        
        //[((MTCategoryIconNode*)[self childNodeWithName:@"MTCategoryIconNode50"]) makeMeSelected];
        
        MTAppOptionNode *debugMode = [[MTAppOptionNode alloc] initDebugInPosition:CGPointMake(200 , HEIGHT-100)];
        [debugMode refleshOptions];
        [self addChild:debugMode];
        
        MTAppOptionNode *joystickMode = [[MTAppOptionNode alloc] initJoystickInPosition:CGPointMake(400, HEIGHT-100)];
        [joystickMode refleshOptions];
        [self addChild:joystickMode];
        
       /* MTAppOptionNode *saveProject = [[MTAppOptionNode alloc] initSaveInPosition:CGPointMake(200, HEIGHT-300)];
        [saveProject refleshOptions];
        [self addChild:saveProject];*/
    }
    
}

-(void) closeAppOptions
{
    /*Fajny warunek zapobiegajacy otwieraniu opcji aplikacji kilka razy (poprzez tapanie na trybik)*/
    //if(!([[MTCategoryIconNode getSelectedIconNode].name isEqualToString:@"MTCategoryIconNode50"] && self.isAppOptionsOpened) && self.optionsBlock == nil)
    //{
        [[self childNodeWithName:@"debugModeNode" ] removeFromParent];
        [[self childNodeWithName:@"joystickModeNode" ] removeFromParent];
        /*[[self childNodeWithName:@"saveProject" ] removeFromParent];*/
        self.isAppOptionsOpened = false;
    //}
}

/*Przeladowanie WAZNYCH funkcji! - dla animacji*/
/*addChild - animacje wszystkich elementow dodawanych do MTCategoryBarNode procz 'poczatkowych' ikonek*/
-(void) addChild:(SKNode *)node
{
    CGPoint pos;
    pos = node.position;
    
    /*Warunki sprawdzajace czy node nalezy do odpowiedniej klasy*/
    if ([node isKindOfClass:[MTWheelNode class]] || [node isKindOfClass:[MTGlobalVarForSetNode class]] || [node isKindOfClass:[MTVisibleGlobalVar class]])
    {
        if(node.position.y < HEIGHT/2)
        {
            node.position = CGPointMake(node.position.x, node.position.y-HEIGHT);
            [node runAction:[SKAction moveToY:pos.y duration:0.4]];
            [super addChild: node];
        } else {
            node.position = CGPointMake(node.position.x, node.position.y+HEIGHT);
            [node runAction:[SKAction moveToY:pos.y duration:0.4]];
            [super addChild: node];
        }
        
    } else if ([node isKindOfClass:[MTConditionNode class]]) {
        
        node.position = CGPointMake(node.position.x+WIDTH, node.position.y);
        [node runAction:[SKAction moveToX:pos.x duration:0.4]];
        [super addChild:node];
        
    } else if ([node isKindOfClass:[MTAppOptionNode class]]) {
        
        node.position = CGPointMake(node.position.x, node.position.y+HEIGHT);
        
        SKAction *element1 = [SKAction moveToY:pos.y duration:0.5];
        SKAction *element2 = [SKAction scaleTo:1.1 duration:0.15];
        SKAction *element3 = [SKAction scaleTo:1.0 duration:0.15];
        
        SKAction *seq = [SKAction sequence:@[element1, element2, element3, element2, element3, element2, element3]];
        
        [node runAction:seq];
        [super addChild:node];
        
    } else {/*W pozostalych rolach... */
        
        [super addChild:node];
        
    }
    
}

@end
