//
//  MTCodeBlockNode.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 12.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTBlockNode.h"
#import "MTStorage.h"
@interface MTCodeBlockNode : MTBlockNode

@property BOOL isMovedAside;

-(void) blockDrop: (MTBlockNode *)block;

+(MTCodeBlockNode*) getSelectedBlockForOptions;
-(void) moveBack:(MTBlockNode *) coveringNode;
-(void) moveASide:(MTBlockNode *) coveringNode;
-(void) makeMeSelected;
-(void) makeMeUnselected;


@end
