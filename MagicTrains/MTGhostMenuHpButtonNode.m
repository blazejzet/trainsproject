//
//  MTGhostMenuHpButtonNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 16.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTGhostMenuHpButtonNode.h"
#import "MTGhostMenuHpPlusButtonNode.h"
#import "MTGhostMenuNode.h"
#import "MTGhostMenuHpMinusButtonNode.h"
#import "MTGhostMenuHpBarNode.h"

@implementation MTGhostMenuHpButtonNode
-(id) init {
    if ((self = [super init]))
    {
        self.name = @"MTGhostMenuHpButtonNode";
        
        MTGhostMenuHpBarNode *hpBar = [[MTGhostMenuHpBarNode alloc] init];
        hpBar.size = CGSizeMake(240, 150);
        hpBar.anchorPoint = CGPointMake(0, 1);
        hpBar.position = CGPointMake(0, 0);
    
        MTGhostMenuHpPlusButtonNode *plusButton = [[MTGhostMenuHpPlusButtonNode alloc]  init];
        plusButton.size = CGSizeMake(50, 50);
        plusButton.anchorPoint = CGPointMake(0, 1);
        plusButton.position = CGPointMake(20, -100);
        
        MTGhostMenuHpMinusButtonNode *minusButton = [[MTGhostMenuHpMinusButtonNode alloc] init];
        minusButton.size = CGSizeMake(50, 50);
        minusButton.anchorPoint = CGPointMake(0, 1);
        minusButton.position = CGPointMake(180, -100);
        
        [self addChild:hpBar];
        [self addChild:plusButton];
        [self addChild:minusButton];
        [hpBar refreshBar];
    }
    return self;
}
-(void)pinchGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    [((MTGhostMenuNode*)self.parent) pinchGesture:g :v];
}
@end
