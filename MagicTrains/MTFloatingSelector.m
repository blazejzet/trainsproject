//
//  MTFloatingSelector.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 26.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTFloatingSelector.h"

@interface MTFloatingSelector ()

@property NSMutableArray* actions;

@end

@implementation MTFloatingSelector

@synthesize indexOfSelectedNode;

-(void)prepareActions
{
    self.actions = [[NSMutableArray alloc] init];
    for (int i = 0; (int) 9 >= i ; i++)
    {
        MTSpriteNode * node = (MTSpriteNode *) self.nodes[i];
        [self.actions addObject:[SKAction moveTo: node.position
                                        duration:0.3]];
    }
}

-(void)setIndexOfSelectedNode:(NSUInteger)ind
{
    NSMutableArray *jumps = [[NSMutableArray alloc] initWithCapacity:10];
    bool isNeedToAdd = (ind > self.indexOfSelectedNode);
    for (
         long int i =
         (isNeedToAdd? self.indexOfSelectedNode+1 : self.indexOfSelectedNode-1);
         isNeedToAdd ? (int) ind >= i  : (int) ind <= i ;
         isNeedToAdd ? i++             :  i--
         )
    {
        [jumps addObject:self.actions[i]];
    }
    [self runAction:[SKAction sequence:jumps]];
    indexOfSelectedNode = ind;
}
@end
