//
//  MTBlockNode.m
//  MagicTrains
//
//  Created by Mateusz Wieczorkowski on 06.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTBlockNode.h"
#import "MTCodeBlockNode.h"
#import "MTCategoryBarNode.h"
#import "MTCodeAreaNode.h"
#import "MTCart.h"
#import "MTLocomotive.h"
#import "MTGhostIconNode.h"
#import "MTCartFactory.h"
#import "MTCodeTabNode.h"
#import "MTTrainNode.h"
#import "MTTrashNode.h"
#import "MTGUI.h"
#import "MTCategoryIconNode.h"
#import "MTMainScene.h"
#import "MTCloneMeCart.h"
#import "MTBlockingBackground.h"
#import "MTViewController.h"
#import "MTCodeRailroadNode.h"
#import "MTWindowAlert.h"


@implementation MTBlockNode
@synthesize oldposition;

static MTCategoryBarNode* categoryBar;
-(id)init
{
    if (self = [super init])
    {
        self.name = @"MTBlockNode";
        self.anchorPoint = CGPointMake(0.5,0.5);
        self.size = CGSizeMake(BLOCK_WIDTH,BLOCK_HEIGHT);
        self.color = [UIColor blackColor];
    }
    return self;
}
-(MTSubTrain *) getMySubTrain
{
    return self.myCart.mySubTrain;
}

-(id)initWithCart: (MTCart *) cart
{
    if (self = [self init])
    {
        self.texture = [SKTexture textureWithImageNamed:[cart getImageName]];
        self.size = CGSizeMake(BLOCK_WIDTH,BLOCK_HEIGHT);
        self.myCart = cart;
    }
    return self;
}

-(void)changeMyParentTo:(SKNode *) newParent
{
    [self removeFromParent];
    [newParent addChild:self];
}

-(SKNode *) checkWhatIsBelowMeWithGesture: g
                                   inView: v
{
    CGPoint pt = CGPointMake([g locationInView:v].x,
                             HEIGHT - [g locationInView:v].y);
    NSArray *nodes = [NSArray alloc];
    nodes = [self.scene nodesAtPoint:pt];
    //[self logNodes: nodes];
    if (nodes.count >= 4)
    {
        if ([nodes[0] isKindOfClass: [MTTrashNode class]])
            return nodes [0];
        else
        if ([nodes[1] isKindOfClass: [MTCodeAreaNode class]] ||
            //[nodes[1] isKindOfClass:    [MTBlockNode class]] ||
            [nodes[1] isKindOfClass: [MTCodeRailroadNode class]])
            return nodes [1];
        else
        if ([nodes[2] isKindOfClass: [MTCodeAreaNode class]] ||
            //[nodes[2] isKindOfClass:    [MTBlockNode class]] ||
            [nodes[2] isKindOfClass: [MTCodeRailroadNode class]])
            return nodes [2];
        else
        if ([nodes[3] isKindOfClass: [MTCodeAreaNode class]] ||
            //[nodes[3] isKindOfClass:    [MTBlockNode class]] ||
            [nodes[3] isKindOfClass: [MTCodeRailroadNode class]])
            return nodes [3];
    }
    return nil;
}

-(void) whenIAmOverBlockNodeWithGesture: g
                                 inViev: v
{
    SKNode *node;
    static MTCodeRailroadNode *focusedNode;
    node = [self checkWhatIsBelowMeWithGesture: g inView: v];
    if ( node != nil )
    {
        if ([node isKindOfClass: [MTCodeRailroadNode class]]){
            if (focusedNode != node)
            {
                [focusedNode whenBlockNodeWasOverMe:self];
                
                focusedNode = (MTCodeRailroadNode*) node;
            }
            //////NSLog(@"name2: %@",node.name);
            [focusedNode whenBlockNodeIsOverMe:self];
        }
    }
}

-(void)logNodes:(NSArray*) nodes
{
    for (int i=0;i<nodes.count;i++)
    {
        SKNode *node = nodes[i];
        ////NSLog(@"%@ [%d]",node.name, i);
    }
}


-(void)moveMeFromCategoryBarWithGesture:(UIGestureRecognizer *)g
                                 inView:(UIView *)v
{
    SKSpriteNode* codeArea = (id)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCodeAreaNode"];
    
    SKNode* blockRoot = [[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTBlockRoot"];
    
    CGPoint newPos;
    
    newPos = [self newPositionWithGesture:g
                                   inView:v
                            inReferenceTo:blockRoot];
    
    if(newPos.x > GHOST_BAR_WIDTH - blockRoot.position.x + BLOCK_WIDTH/2  &&
       newPos.y > BLOCK_HEIGHT/2 &&
       newPos.y < codeArea.size.height - BLOCK_HEIGHT/2 &&
       newPos.x < CODE_AREA_WIDTH + CATEG_BAR_WIDTH - BLOCK_WIDTH/2)
    {
        self.position = newPos;
    }
}

-(void)moveMeFromCodeAreaBarWithGesture:(UIGestureRecognizer *)g
       inView:(UIView *)v
{
    SKSpriteNode* codeArea = (id)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCodeAreaNode"];
    CGPoint newPos;
    newPos = [self newPositionWithGesture:g
                                   inView:v
                            inReferenceTo:codeArea];
    //blokowanie przesuwania
    if(newPos.x < CODE_AREA_WIDTH - BLOCK_WIDTH/2 &&
       newPos.y < codeArea.size.height - BLOCK_HEIGHT/2 - TAB_HEIGHT &&
       newPos.x > BLOCK_WIDTH/2)
    {
        self.position = newPos;
    }
}

-(void)getIntoCodeArea
{
    MTCodeAreaNode * codeAreaNode = (MTCodeAreaNode*) ([[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCodeAreaNode"]);
    if ([self.myOrigin.name isEqualToString:@"MTCategoryBarNode"])
            [(MTCategoryBarNode *)(self.myOrigin) closeBlocksArea];
    
    [self changeMyParentTo: codeAreaNode];
}

-(void)whenDroppingOnCodeArea:(SKNode*) aimedNode
{
    [(MTCodeAreaNode*) aimedNode blockDrop:self];
}

-(void)whenDroppingOnCodeBlock:(SKNode*) aimedNode
{
    if ([self.myCart getCategory] != MTCategoryLocomotive)
    [(MTCodeBlockNode *)aimedNode blockDrop: self];
}


-(void)holdGesture:(UIGestureRecognizer *)g :(UIView *)v{
    //ZAMIANA - TEN GEST BĘDZIE USUWŁAŁ NODE....
    ////NSLog(@"Nic nie robimy bo to menu");
    
}

-(void)executeBlockDrop:(SKNode*) aimedNode
{
    MTCodeAreaNode *codeAreaNode = (MTCodeAreaNode*) ([[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCodeAreaNode"]);
    /* Wywoływanie funkcji reagujących na upuszczenie Bloczka */
    if ([aimedNode.name isEqualToString:@"MTTrashNode"])
    {
        [codeAreaNode.bin blockDrop:self];
        [self removeFromParent];
    }
    else if ([aimedNode.name isEqualToString:@"MTCodeAreaNode"] ||[aimedNode.name isEqualToString:@"MTTrainNode"])
    {
        [self whenDroppingOnCodeArea: codeAreaNode];
    }
    else if([aimedNode.name isEqualToString:@"MTCodeBlockNode"]||
            [aimedNode.name isEqualToString:@"MTTrackInsideNode"]||
            [aimedNode.name isEqualToString:@"MTTrackCurveNode"])
    {      
        float diffPosX = 0;
        float diffPosY = 0;
        SKNode* nextParent = aimedNode.parent;
        while (![[nextParent name] isEqualToString:@"MTCodeAreaNode"])
        {
            diffPosX += nextParent.position.x;
            diffPosY += nextParent.position.y;
            nextParent = nextParent.parent;
        }
        
        self.myCart.oldposition=CGPointMake(self.position.x-diffPosX,
                                            self.position.y-diffPosY);
        
        [self whenDroppingOnCodeBlock:aimedNode];
    }
}

/******************************************************/
/***                  PAN GESTURE                   ***/
/******************************************************/
-(void)panGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    
    if (![self.myCart isActive]) return;
    
    static CGPoint begin;
    static __weak SKNode* blockRoot;
    //static MTTrainNode* myActualTrainNode;
    static __weak MTCodeAreaNode *codeAreaNode;
    codeAreaNode = (MTCodeAreaNode*) ([[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCodeAreaNode"]);
    static __weak MTCategoryBarNode *catBar;
    
    static __weak MTTrashNode *bin;
    
    static MTBlockingBackground *background;
    if ([codeAreaNode getSelectedTabNumber] == 0 && [MTStorage getInstance].ProjectType == MTProjectTypeLearn) return;
    if (g.state == UIGestureRecognizerStateBegan)
    {
        
        [catBar closeBlocksArea];
        
        self.myOrigin = self.parent;
        blockRoot = [[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTBlockRoot"];
        codeAreaNode = (MTCodeAreaNode*) ([[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCodeAreaNode"]);
        bin = (id) codeAreaNode.bin;
        catBar = (MTCategoryBarNode*) [[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
        
        // Dodawanie kosza
        [(MTTrashNode *)bin showTrash];

        
        // zachowanie pozycji początkowej
        begin = self.position;
        
        // zmiana rodzica na stały punkt w scenie
        [self changeMyParentTo: blockRoot];
        
        //Uwzględnienie pozycji początkowej w przesuwaniu
        [self setPosition:CGPointMake(self.position.x + catBar.position.x - codeAreaNode.position.x, self.position.y)];
        
        if(ANIMATIONS)
        {
            
            if ([self.myCart getCategory] != MTCategoryLocomotive)
            {
                background = [[MTBlockingBackground alloc] initFullBackgroundWithDuration:1.0 Color:[UIColor blackColor] Alpha:0.4 andWaitTime:0.5];
                
                for (MTSpriteNode *child in codeAreaNode.children)
                {
                    if ([child.name isEqualToString: @"MTTrainNode"])
                        child.zPosition = child.zPosition + 400;
                }
                
                bin.zPosition = bin.zPosition + 400;
                
                self.zPosition = self.zPosition + 550;
                
            }
            
            if ([self.myCart getCategory] == MTCategoryLocomotive)
            {
                background = [[MTBlockingBackground alloc] initCodeAreaBackgroundWithDuration:1.0 Color:[UIColor greenColor] Alpha:0.3 andWaitTime:0.5];
                
                for (MTSpriteNode *child in codeAreaNode.children)
                {
                    if ([child.name isEqualToString: @"MTTrainNode"])
                    {
                        child.zPosition = child.zPosition + 400;
                    }
                    
                    if ([child isKindOfClass:[MTCodeTabNode class]])
                    {
                        child.zPosition = child.zPosition + 400;
                    }
                }
                
                bin.zPosition = bin.zPosition + 400;
                
                self.zPosition = self.zPosition + 550;
                
            }
        }
        
        
        
    }
    
    /* Blok wywolywany po opuszczeniu paska kategorii*/
    if ( [catBar isOpened] && self.position.x < catBar.position.x )
    {
        [self getIntoCodeArea];
    }
    
    if (self.parent == blockRoot) {
        [self moveMeFromCategoryBarWithGesture:g
                                        inView:v];
    }else
    if (self.parent == codeAreaNode)
    {
        [self moveMeFromCodeAreaBarWithGesture:g
                                        inView:v];
    }
    
    [self whenIAmOverBlockNodeWithGesture: g inViev: v];
    
    if (g.state == UIGestureRecognizerStateEnded)
    {
        if(ANIMATIONS)
        {
            if ([self.myCart getCategory] != MTCategoryLocomotive)
            {
                
                [background removeBackground];
                
                for (MTSpriteNode *child in codeAreaNode.children)
                {
                    if ([child.name isEqualToString: @"MTTrainNode"])
                    {
                        child.zPosition = child.zPosition - 400;
                    }
                }
                
                bin.zPosition = bin.zPosition - 400;
                
                self.zPosition = self.zPosition - 550;
            }
            
            if ([self.myCart getCategory] == MTCategoryLocomotive)
            {
                [background removeBackground];
                
                for (MTSpriteNode *child in codeAreaNode.children)
                {
                    if ([child.name isEqualToString: @"MTTrainNode"])
                    {
                        child.zPosition = child.zPosition - 400;
                    }
                    
                    if ([child isKindOfClass:[MTCodeTabNode class]])
                    {
                        child.zPosition = child.zPosition - 400;
                    }
                }
                
                bin.zPosition = bin.zPosition - 400;
                
                self.zPosition = self.zPosition - 550;
            }
        }
        
        /* wyszukiwanie Node'a pod BlockNodem */
        SKNode *targetedNode = [self checkWhatIsBelowMeWithGesture:g inView:v];
        
        [self executeBlockDrop: targetedNode];
        
        /* powrót do stanu wyjsciowego */
        self.position = begin;
        if (self.parent != nil)
            [self changeMyParentTo: catBar];
        
        // Usuwanie kosza
        [(MTTrashNode*)bin hideTrash];
    }
}
/***/
/* */
/***/
-(bool) removeMyCartInStorage
{
    return [[self getMySubTrain] removeCart: self.myCart];
}

-(bool) removeFullTrainInStorage
{
    return [[self getMySubTrain] removeAllCarts];
}


@end
