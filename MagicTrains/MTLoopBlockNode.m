//
//  MTLoopBlockNode.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 04.04.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTLoopBlockNode.h"
#import "MTTrainNode.h"
#import "MTSubTrainCart.h"
#import "MTCodeAreaNode.h"
@implementation MTLoopBlockNode

////////////////PUBLICZNE
-(id)init
{
    if (self = [super init] )
    {
        self.anchorPoint = CGPointMake(0.5, 0.76);
    }
    return self;
}


-(void)tapGesture:(UIGestureRecognizer *)g
{
    [super tapGesture:g];
    for (SKNode *node in self.parent.children)
    {
        if([node isKindOfClass:[MTLoopBlockNode class]])
        {
            MTLoopBlockNode* loopBlockNode = (id) node;
            if ([loopBlockNode getMyCart].isMySubTrainVisible || loopBlockNode != self)
                {
                    [loopBlockNode hideMySubtrain];
                    [loopBlockNode turnOffTexture];
                }
                else
                {
                    [loopBlockNode showMySubtrain];
                    [loopBlockNode turnOnTexture];
                    SKNode* node = [self parent];
                    while (![[node name] isEqualToString:CODE_AREA_NODE_NAME])
                        node = [node parent];
                    [(MTCodeAreaNode*)node calculateMyHeight];
                }
            
        }
    }
}

/////////////PRYWATNE

-(MTSubTrainCart*) getMyCart
{
    return ((MTSubTrainCart*)self.myCart);
}

-(void)hideMySubtrain
{
    if ([self getMyCart].isMySubTrainVisible)
    {
        [self.myTrainNode fadeMeOut];
        [self getMyCart].isMySubTrainVisible = false;
    }
}

-(void)showMySubtrain
{
    if (![self getMyCart].isMySubTrainVisible)
    {
        [self.myTrainNode removeFromParent];
        [self.parent addChild: self.myTrainNode];
        
        [self.myTrainNode fadeMeIn];
        
        [self getMyCart].isMySubTrainVisible = true;
    }
}

-(void)turnOnTexture
{
    NSString* myImageName = [[self getMyCart] getImageName];
    [self runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:myImageName]]];
}

-(void)turnOffTexture
{
    NSString* myImageName = [[self getMyCart] getSecondImageName];
    [self runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:myImageName]]];
}


@end
