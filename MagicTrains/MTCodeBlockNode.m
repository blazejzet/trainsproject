//
//  MTCodeBlockNode.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 12.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCodeBlockNode.h"
#import "MTBlockNode.h"
#import "MTGUI.h"
#import "MTCart.h"
#import "MTMainScene.h"
#import "MTTrainNode.h"
#import "MTTrashNode.h"
#import "MTSubTrainCart.h"
#import "MTCodeAreaNode.h"
#import "MTCategoryIconNode.h"
#import "MTCloneMeCart.h"
#import "MTCodeTabNode.h"
#import "MTBlockingBackground.h"
#import "MTProjectTypeEnum.h"
#import "MTWindowAlert.h"
#import "MTGhostRepresentationEffectNode.h"
#import "MTNotSandboxProjectOrganizer.h"


@interface MTCodeBlockNode()
@property MTWindowAlert *alert ;
@property MTGhostRepresentationEffectNode* myEffect;
@end


@implementation MTCodeBlockNode
@synthesize myEffect;
//Wskaźnik na wagonik z otwartymi opcjami
static MTCodeBlockNode *SelectedBlock;

-(id)init
{
    if (self = [super init] )
    {
        self.name = @"MTCodeBlockNode";
        //SelectedBlock = nil;
    }
    return self;
}

/*SEKCJA OBECNIE ZAZNACZONEGO WAGONIKA Z OPCJAMI*/
+(MTCodeBlockNode*) getSelectedBlockForOptions
{
    return SelectedBlock;
}

-(void) makeMeSelected
{
    if( [self imOnBlockedTab]) return;
    if (SelectedBlock != nil)
    {
        [SelectedBlock makeMeUnselected];
    }
    
    SelectedBlock = self;
    
    if(ANIMATIONS && self.myCart.getCategory !=3){
        //[self runAction: [SKAction resizeToWidth:BLOCK_WIDTH+10 height:BLOCK_HEIGHT+10 duration:0.2]];
        myEffect = [[MTGhostRepresentationEffectNode alloc] initEffectNodeOn:self];
        [self addChild:myEffect];
        [myEffect doPostInitAnimationWithMe];
        [myEffect doSelectedAnimationWithMe];
    }
    
}

-(void) makeMeUnselected
{
    if( [self imOnBlockedTab]) return;
    if(ANIMATIONS && SelectedBlock.myCart.getCategory !=3)
        [SelectedBlock runAction: [SKAction resizeToWidth:BLOCK_WIDTH height:BLOCK_HEIGHT duration:0.2]];
    
    //SelectedBlock.size = CGSizeMake(BLOCK_WIDTH, BLOCK_HEIGHT);
    for (MTSpriteNode* child in self.children)
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
    
    SelectedBlock = nil;
}

-(void)moveMeWithGesture:(UIGestureRecognizer *)g
                  inView:(UIView *)v
{
    SKSpriteNode* codeArea = (id)[[self.scene
                                   childNodeWithName:@"MTRoot"]
                                  childNodeWithName:@"MTCodeAreaNode"];
    CGPoint newPos;
    newPos = [self newPositionWithGesture:g
                                   inView:v
                            inReferenceTo:codeArea];
    //blokowanie przesuwania
    if(newPos.y > BLOCK_HEIGHT/2 &&
       newPos.x < CODE_AREA_WIDTH - BLOCK_WIDTH/2 &&
       newPos.y < codeArea.size.height - BLOCK_HEIGHT/2 - TAB_HEIGHT &&
       newPos.x > BLOCK_WIDTH/2)
    {
        [self setPosition: newPos];
    }
}

-(bool) checkForCloneTabs: (MTBlockNode *)block
{
    /*Sekcja blokowany wagonow*/
    bool cartBlocked = [block.myCart isKindOfClass: [MTCloneMeCart class]];
    
    /*W blokowanych tabach*/
    int selectedTab = [MTCodeTabNode getSelectedTab].tabNumber;
    bool inTab = (selectedTab == CLONE_TAB) ||
    (selectedTab == CLONE_TAB+1) ;
    
    return !(cartBlocked && inTab);
}

/*
 Wywoływane przez bloczek na który upuszcza się inny bloczek
 */
-(void) blockDrop: (MTBlockNode *)block
{
    if( [self imOnBlockedTab]) return;
    
    MTSubTrain * mySubT = [self getMySubTrain];
    if (mySubT != nil)
    {
        if ([block.myOrigin.name  isEqualToString:@"MTCategoryBarNode"])
        {
            if ([self checkForCloneTabs:block])
            {
                /* Dodawanie zupełnie nowego wagonika */
                [mySubT insertCart: [[block myCart] getNewWithSubTrain:mySubT]
                           AtIndex: [mySubT.Carts indexOfObject:self.myCart] + 1 ];
            }
        }
        else
        {
            
            if ([self checkForCloneTabs:block] && ![self isLoopRecursive: block])
            {
                /* Umieszczenie upuszczanego bloczka w wybranym podpociągu*/
                [block removeMyCartInStorage];
                [mySubT insertCart:[block myCart]
                           AtIndex: [mySubT.Carts indexOfObject:self.myCart] + 1 ];
                block.myCart.mySubTrain = mySubT;
                /* Jezeli bloczek zawiera podpociag (jest klasy MTSubTrainCart)*/
                if ([block.myCart isKindOfClass: [MTSubTrainCart class]])
                {
                    /// zmieniam ustawienia zawartego w nim subTrain'a
                    MTSubTrainCart * STcart = (MTSubTrainCart *) block.myCart;
                    STcart.subTrain.myTrain = mySubT.myTrain;
                }
            }
        }
    }
}
-(bool)isLoopRecursive:(MTBlockNode*) block
{
    if([block.myCart isKindOfClass: [MTSubTrainCart class]])
        return [self getMySubTrain] == ((MTSubTrainCart*)block).subTrain;
    return false;
}

-(void)whenDroppingOnCodeArea:(SKNode*) aimedNode{
    if ([self.myCart getCategory] != MTCategoryLocomotive){
        [(MTCodeAreaNode *) aimedNode blockDrop:self];
    }
}

-(void)whenDroppingOnCodeBlock:(SKNode*) aimedNode
{
    if (self.myCart.getCategory != MTCategoryLocomotive )
    {
        if(! [(MTCodeBlockNode *)aimedNode imOnBlockedTab])
            [(MTCodeBlockNode *)aimedNode blockDrop: self];
        
    }
}

-(void) moveBack:(MTBlockNode *) coveringNode
{
    if(self.isMovedAside)
    {
        CGPoint newPos = CGPointMake(self.position.x, self.position.y - 50);
        [self runAction: [SKAction moveTo: newPos duration: 0.5] completion:^{
            self.isMovedAside = false;
        }];
    }
}

-(void) moveASide:(MTBlockNode *) coveringNode
{
    if(! self.isMovedAside)
    {
        self.isMovedAside = true;
        CGPoint newPos = CGPointMake(self.position.x, self.position.y + 50);
        [self runAction: [SKAction moveTo: newPos duration: 0.5]];
    }
}

-(MTCodeBlockNode*) getCodeBlockNodeBeforeMe
{
    return nil;
}

-(MTCodeBlockNode*) getCodeBlockNodeAfterMe
{
    return nil;
}

/******************************************************/
/***                  PAN GESTURE                   ***/
/******************************************************/
-(void)panGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    if ([[MTNotSandboxProjectOrganizer getInstance] isSelectedTabBlocked]) return;
    
    static CGPoint begin;
    static SKNode* blockRoot;
    static MTTrainNode* myActualTrainNode;
    static MTCodeAreaNode *codeAreaNode;
    
    static MTTrashNode *bin;
    
    static MTBlockingBackground *background;
    
    //Przydaloby sie zrobic porzadek z zPosition ale to kiedys tam, bo to tylko kwestia porzadku.
    float binZPositionTMP;
    if( [self imOnBlockedTab]) return;
    
    if (g.state == UIGestureRecognizerStateBegan)
    {
        
        self.myOrigin = self.parent;
        blockRoot = [[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTBlockRoot"];
        codeAreaNode = (MTCodeAreaNode*) ([[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCodeAreaNode"]);
        bin = (id) codeAreaNode.bin;
        myActualTrainNode = nil;
        if ( [self.parent.name isEqualToString:@"MTTrainNode"])
            myActualTrainNode = (id) self.parent;
        
        //Animacje przesuwania
        
        if(ANIMATIONS)
        {
            background = [[MTBlockingBackground alloc] initFullBackgroundWithDuration:1.0 Color:[UIColor blackColor] Alpha:0.4 andWaitTime:0.5];
            
            if ([self.myCart getCategory] != MTCategoryLocomotive)
            {
                for (MTSpriteNode *child in codeAreaNode.children)
                {
                    if ([child.name isEqualToString: @"MTTrainNode"])
                        child.zPosition = child.zPosition + 10000;
                }
            }
            binZPositionTMP = bin.zPosition;
            bin.zPosition = 10000;
            
            self.zPosition = self.zPosition + 10001;
        }
        
        // Dodawanie kosza
        
        [(MTTrashNode*)bin showTrash];
        begin = self.position;
        self.myOrigin = self.parent;
        
        // Przypinanie do MTBlockRoot'a podczas przenoszenia
        [super changeMyParentTo: blockRoot];
        
        if (self.myOrigin == myActualTrainNode)
        {
            CGPoint mATNpos = [myActualTrainNode getAbsolutePositionInCodeArea];
            [self setPosition:CGPointMake(self.position.x + mATNpos.x ,
                                          self.position.y + mATNpos.y + codeAreaNode.position.y)];
        }
    }
    
    [self whenIAmOverBlockNodeWithGesture: g inViev: v];
    
    [self moveMeWithGesture:g inView:v];
    
    if (g.state == UIGestureRecognizerStateEnded)
    {
        //Animacje przesuwania
        if(ANIMATIONS)
        {
            [background removeBackground];
            
            if ([self.myCart getCategory] != MTCategoryLocomotive)
            {
                for (MTSpriteNode *child in codeAreaNode.children)
                {
                    if ([child.name isEqualToString: @"MTTrainNode"])
                        child.zPosition = child.zPosition - 10000;
                }
            }
            
            bin.zPosition = 10000;
            
            self.zPosition = self.zPosition - 10001;
            
        }
        
        /* wyszukiwanie Node'a pod BlockNodem */
        SKNode *targetedNode = [super checkWhatIsBelowMeWithGesture:g inView:v];
        
        [self executeBlockDrop: targetedNode];
        
        /* powrót do stanu wyjsciowego */
        self.position = begin;
        if (self.parent != nil)
            [self changeMyParentTo: self.myOrigin];
        
        // Usuwanie kosza
        [(MTTrashNode*)bin hideTrash];
    }
    
}
/***/
/* */
/***/
-(void) tapGesture:(UIGestureRecognizer *)g
{
    
}



-(void)holdGesture:(UIGestureRecognizer *)g :(UIView *)v{
    
    static MTCart * cartBefore;
    
    if(!self.myCart.optionsOpen)
    {
        //zamykanie innych kategorii wagonow
        if(![[MTCategoryIconNode getSelectedIconNode].name isEqualToString:@"MTCategoryIconNode50"])
            [[MTCategoryIconNode getSelectedIconNode] makeMeUnselected];
        
        //((MTMainScene *)self.scene).simultaneousGestures = YES;
        [((MTMainScene *)self.scene) prepareSimultaneousPanPinchRotate];
        //[cartBefore hideOptions];
        [((MTCategoryBarNode*)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"])closeOpenedOptions];
        [self.myCart showOptions];
        
        if ([self.parent.name isEqualToString:@"MTCodeAreaNode"])
            [(MTCodeAreaNode *)self.parent holdedBlock: self];
        
        //Zaznacza obecny wagonik z opcjami
        [self makeMeSelected];
        [((MTCategoryBarNode*)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"])openBlocksAreaWithOptionsForBlock :self];
    }
    cartBefore = self.myCart;
    
    //ZAMIANA - TEN GEST BĘDZIE USUWŁAŁ NODE....
    /*self.myOrigin = self.parent;
     
     if(self.alert){
     [self.alert cancel];
     self.alert=nil;
     }else{
     MTBlockingBackground *background = [[MTBlockingBackground alloc] initFullBackgroundWithDuration:1.0 Color:[UIColor blackColor] Alpha:0.4 andWaitTime:0.001];
     //        MTWindowAlert *alert = [[MTWindowAlert alloc] initWithNode: (MTBlockNode*)self CB:^{
     //            MTCodeAreaNode *codeAreaNode = (MTCodeAreaNode*) ([[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCodeAreaNode"]);
     //            [self removeFromParent];
     //            [codeAreaNode.bin blockDrop:self];
     
     }];
     
     MTWindowAlert *alert = [[MTWindowAlert alloc] initWithNode: (MTBlockNode*)self inContainer: (MTCodeAreaNode*) ([[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCodeAreaNode"]) CB:^{
     MTCodeAreaNode *codeAreaNode = (MTCodeAreaNode*) ([[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCodeAreaNode"]);
     //[self removeFromParent]; //del
     [codeAreaNode.bin blockDrop:self];
     
     }];
     
     alert.background = background;
     self.alert=alert;
     [((MTCodeAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTBlockRoot"]) addChild:alert];
     alert.zPosition=1225.0;
     self.zPosition=1223.0;
     }*/
    
}


-(bool) imOnBlockedTab
{
    // ////NSLog(@"Sprawdzam czy zablokowany: tabNr = %d \n ProjectType = %d",[[[self getMySubTrain] myTrain] tabNr], (MTProjectTypeEnum)[[MTStorage getInstance] ProjectType] );
    return  [[[self getMySubTrain] myTrain] tabNr] == 0 && [[MTStorage getInstance] ProjectType] == MTProjectTypeLearn;
}
@end