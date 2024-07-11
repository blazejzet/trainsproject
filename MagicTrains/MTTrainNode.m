//
//  MTTrainNode.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 05.04.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTTrainNode.h"
#import "MTTrain.h"
#import "MTTrackStartNode.h"
#import "MTSubTrain.h"
#import "MTSpriteNode.h"
#import "MTBlockNode.h"
#import "MTCodeBlockNode.h"
#import "MTLoopBlockNode.h"
#import "MTTrackInsideNode.h"
#import "MTCart.h"
#import "MTCodeAreaNode.h"
#import "MTSubTrainCart.h"
#import "MTForLoopCart.h"
#import "MTIfCart.h"
#import "MTGUI.h"
@implementation MTTrainNode
//@synthesize mainTrainNode;
-(id)init
{
    if (self = [super init])
    {
        self.name = @"MTTrainNode";
    }
    return self;
}

-(id)initWithPositon:(CGPoint) pos
{
    if (self = [self init])
    {
        [self setPosition:pos];
    }
    return self;
}

-(SKNode *) showSubTrain:(MTSubTrain *) subTrain
{
   
    CGPoint point = CGPointMake(0,0);
    /*Przeglądanie wagoników*/
    for (int j=0; j<subTrain.Carts.count; j++)
    {
        MTCart* currentCart = [subTrain getCartAt:j];
        ////NSLog(@"%@",currentCart);
        
        point = [self calculateCartPositionInsideTrainNodeWithNr:j];
        
        [self DoAddConnectorAtPoint: point
                        ForSubTrain: subTrain
                    IndexOfNextCart: j+1];

       
        //currentCart.oldposition=point;
        
        if ([currentCart isKindOfClass: [MTSubTrainCart class]])
        {
           [self showSubtrainCart:(MTCart *)currentCart
                          AtPoint:(CGPoint) point
                       InSubtrain:(MTSubTrain*) subTrain];
        }
        else
        {
           [self DoAddNewBlockWithCart: currentCart
                            AtPosition: point
                          FromSubTrain: subTrain];
        }
    }
    
    //dodanie końca torów
    point = [self calculateCartPositionInsideTrainNodeWithNr:subTrain.Carts.count];
    
    [self DoAddConnectorAtPoint: point
                    ForSubTrain: subTrain
                IndexOfNextCart: subTrain.Carts.count];
    
    self.mySubTrain = subTrain;
    self.myTrain = subTrain.myTrain;
    return self;
}

-(MTTrainNode*) getMainTrNode
{
    if (self.mySubTrain == self.myTrain.mainSubTrain){
        return self;
    }
    return [(MTTrainNode*)self.parent getMainTrNode];
}

-(void)showSubtrainCart:(MTCart *)currentCart AtPoint:(CGPoint) point InSubtrain:(MTSubTrain*) subTrain
{
    MTCart* currentBlock = [self DoAddNewBlockWithCart: currentCart
                                            AtPosition: CGPointMake(point.x, point.y+24)
                                          FromSubTrain: subTrain];
    
    MTSubTrainCart* STCart = (MTSubTrainCart*) currentCart;
    
    MTTrackStartNode * curve = [[MTTrackStartNode alloc]initWithSubTrain:STCart.subTrain  NextCartIndex:0];
    
    CGPoint pointForNewSubtrain = CGPointMake(point.x + TRACK_WIDTH, point.y - TRACK_HEIGHT  -4);
    MTTrainNode * newTrainNode = [[MTTrainNode alloc] initWithPositon:pointForNewSubtrain ];
    [newTrainNode addChild: curve];
    
    /* dodanie odnosnika do ukrywania podpociągów*/
    ((MTLoopBlockNode*) currentBlock).myTrainNode = newTrainNode;

    //newTrainNode.mainTrainNode = [self getMainTrNode];
    
    [newTrainNode showSubTrain: ((MTSubTrainCart*)currentCart).subTrain];
    
    if (((MTSubTrainCart*)currentCart).isMySubTrainVisible)
    {
        [self addChild: newTrainNode];
    }
    else
    {
        /* zmiana z domyslnej teksturki bloczka na wyłączoną*/
        ((MTLoopBlockNode*) currentBlock).texture = [SKTexture textureWithImageNamed:[((MTSubTrainCart*)currentCart) getSecondImageName]];
        newTrainNode.alpha = 0;
    }
}

-(void)panGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    [((MTSpriteNode *) self.parent) panGesture:g :v ];
}

-(CGPoint) getAbsolutePositionInCodeArea
{
    SKNode* currNode = self.parent;
    CGPoint pt = self.position;
    while ([currNode.parent.name isEqualToString:@"MTTrainNode"]||
           [currNode.parent.name isEqualToString:@"MTCodeAreaNode"])
    {
        pt = CGPointMake(pt.x + currNode.position.x,
                         pt.y + currNode.position.y);
        currNode = currNode.parent;
    }
    return pt;
}
-(CGFloat) getMyHeightRecursive
{
    float myHeight = TRACK_HEIGHT * self.mySubTrain.Carts.count;
    for (SKNode *child in self.children) {
        if ([child isKindOfClass:( [MTTrainNode class])])
        {
            //if (((MTTrainNode *)child).mySubTrain)
            myHeight += [(MTTrainNode *) child getMyHeightRecursive];
        }
    }
    return myHeight;
}


-(void) fadeMeOut
{
    [self removeAllActions];
    [self runAction:[SKAction fadeOutWithDuration:0.1] completion:
     ^{
            [self runAction:[SKAction removeFromParent]];
     }];
}
-(void) fadeMeIn
{
    [self removeAllActions];
    //if (self.parent != nil)
    //{
    //    [self removeFromParent];
    //}
    
    [self runAction:[SKAction fadeInWithDuration:0.1]];
}
-(void) moveMeToPoint:(CGPoint) pt
{
    MTCodeAreaNode * codeArea = (id)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCodeAreaNode"];
    //////NSLog(@"whole code area height: %f", codeArea.size.height);
    float px = pt.x;
    float py = pt.y;
    if (TRACK_WIDTH/2 > px)
        px = TRACK_WIDTH/2;
    else if(px > CODE_AREA_WIDTH - TRACK_WIDTH/2)
        px = CODE_AREA_WIDTH - TRACK_WIDTH/2;
    
    if(py > [codeArea maxTrainYPos])
        py = [codeArea maxTrainYPos];
    [self setPosition: CGPointMake(px, py)];
}

-(void) updatePositionInStorage
{
    self.myTrain.positionInCodeArea = [self getMainTrNode].position ;
}
-(void) onCartRemoved
{
    [self removeChildrenInArray:@[[[self children] lastObject]]];
}

//////// IMPLEMEN			TACJA
-(CGPoint)calculateCartPositionInsideTrainNodeWithNr:(int) C
{
    return CGPointMake( 0,  -(C * (BLOCK_HEIGHT + 5)));
}
-(CGPoint)calculateMyShiftWithDepth:(uint)depth MyDepth:(uint)myDepth
{
    return CGPointMake(0.5 * powf(2, (CGFloat) depth / (CGFloat) myDepth) , 0.0);
}

-(MTCodeBlockNode *) DoAddNewBlockWithCart:(MTCart *)cart AtPosition:(CGPoint)pos
               FromSubTrain:(MTSubTrain *)subtrain
{
    MTCodeBlockNode *destiny = nil;
    if (cart.getCategory == MTCategoryLoop)
        destiny = (id)[[MTLoopBlockNode alloc] initWithCart:cart];
    else
        destiny = [[MTCodeBlockNode alloc] initWithCart:cart];
    
    destiny.myCart.mySubTrain = subtrain;
    
    destiny.position=cart.oldposition;
    destiny.zPosition=10000.00;
    [self addChild:destiny];
    [self animateAddingBlock:destiny AtPosition:pos];
    return destiny;
    
}
-(void) animateAddingBlock: (MTCodeBlockNode *)destiny AtPosition:(CGPoint)pos{
    [destiny runAction:[SKAction moveTo:pos duration:0.2] completion:^(){
        destiny.myCart.oldposition=pos;
        destiny.zPosition=0.0;
    }];
}


-(void) DoAddConnectorAtPoint: (CGPoint) pt ForSubTrain:(MTSubTrain *) subTrain IndexOfNextCart:(NSUInteger) index
{
    MTTrackInsideNode *newConn = [[MTTrackInsideNode alloc] initWithSubTrain:subTrain NextCartIndex:index];
    [newConn setPosition:pt];
    
    [self addChild:newConn];
}



@end
