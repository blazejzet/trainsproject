//
//  MTCodeRailroadNode.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 30.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTCodeRailroadNode.h"
#import "MTSpriteNode.h"
#import "MTCodeTabNode.h"
#import "MTCloneMeCart.h"
#import "MTSubTrainCart.h"
#import "MTBlockNode.h"
#import "MTTrainNode.h"
#import "MTCodeAreaNode.h"
#import "MTGUI.h"
#import "MTNotSandboxProjectOrganizer.h"
@implementation MTCodeRailroadNode

-(id) initWithSubTrain:(MTSubTrain *)subTrain NextCartIndex:(NSUInteger)nextCartIndex;
{
    if (self = [super init])
    {
        self.nextCartIndex = nextCartIndex;
        self.myTrain = subTrain.myTrain;
        self.mySubTrain = subTrain;
        self = [self init];
    }
    return self;
}
-(void) panGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    static CGPoint pointOnMe;
    MTCodeAreaNode *codeAreaNode = (id)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCodeAreaNode"];
    
    if ([[MTNotSandboxProjectOrganizer getInstance] isSelectedTabBlocked]) return;
    if ([self.parent.name isEqualToString:@"MTTrainNode"])
    {
        MTTrainNode* parent = (id)self.parent;
        MTTrainNode* mainTrNode = [parent getMainTrNode];
        
        CGPoint pt = [g locationInView:g.view];
        pt.x = pt.x - codeAreaNode.position.x;
        pt.y = HEIGHT - pt.y - codeAreaNode.position.y;
        
        if (g.state == UIGestureRecognizerStateBegan)
            pointOnMe = CGPointMake(pt.x - mainTrNode.position.x,
                                    pt.y - mainTrNode.position.y);
        
        pt.x = pt.x - pointOnMe.x;
        pt.y = pt.y - pointOnMe.y;
        
        if (g.state != UIGestureRecognizerStateEnded)
            [mainTrNode moveMeToPoint:pt];
        
        [(MTCodeAreaNode *)codeAreaNode calculateMyHeight];
        [(MTCodeAreaNode *)codeAreaNode putMeIntoGoodPosition: codeAreaNode.position];
        
        if (g.state == UIGestureRecognizerStateEnded)
            [parent updatePositionInStorage];
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

-(void) whenBlockNodeWasOverMe:(MTBlockNode *) coveringNode
{
    
}

-(void) whenBlockNodeIsOverMe:(MTBlockNode *) coveringNode
{
    ////NSLog(@"%@\n",[self.parent name]);
    for (SKNode *child in self.parent.children)
    {
        ////NSLog(@"%@\n",[child name]);
    }
}

-(void) blockDrop: (MTBlockNode *)block
{
    MTSubTrain * mySubT = self.mySubTrain;
    if (mySubT != nil)
    {
        if ([block.myOrigin.name  isEqualToString:@"MTCategoryBarNode"])
        {
            if ([self checkForCloneTabs:block])
            {
                /* Dodawanie zupełnie nowego wagonika */
                MTCart *newCart = [[block myCart] getNewWithSubTrain:mySubT];
                newCart.oldposition = [[block myCart] oldposition];
                [mySubT insertCart: newCart
                           AtIndex: self.nextCartIndex ];
            }
        }
        else
        {
            if ([self checkForCloneTabs:block] && ! [self isLoopRecursive: block])
            {
                /* Umieszczenie upuszczanego bloczka w wybranym podpociągu*/
                
                [block removeMyCartInStorage];
                [mySubT insertCart:[block myCart]
                           AtIndex: self.nextCartIndex ];
                block.myCart.mySubTrain = mySubT;
            }
        }
        
    }
}
-(bool)isLoopRecursive:(MTBlockNode*) block
{
    if([block.myCart isKindOfClass: [MTSubTrainCart class]])
    {
        MTSubTrain* testSubTr =  self.mySubTrain ;
        while (testSubTr != nil)
        {
            bool val = ((MTSubTrainCart*)block.myCart).subTrain == testSubTr;
            if (val) return val;
            testSubTr = testSubTr.myParentSubTrain;
        }
        return false;
    }
    return false;
}
-(bool) imOnBlockedTab
{
    // ////NSLog(@"Sprawdzam czy zablokowany: tabNr = %d \n ProjectType = %d",[[[self getMySubTrain] myTrain] tabNr], (MTProjectTypeEnum)[[MTStorage getInstance] ProjectType] );
    /*return  [[[self getMySubTrain] myTrain] tabNr] == 0 && [[MTStorage getInstance] ProjectType] == MTProjectTypeLearn;*/
    return false;
}
@end