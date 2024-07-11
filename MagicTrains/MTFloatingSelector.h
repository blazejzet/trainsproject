//
//  MTFloatingSelector.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 26.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTSpriteNode.h"

@interface MTFloatingSelector : MTSpriteNode

@property NSMutableArray* nodes;
@property (nonatomic) NSUInteger indexOfSelectedNode;

-(void)prepareActions;

@end
