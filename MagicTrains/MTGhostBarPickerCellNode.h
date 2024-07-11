//
//  MTGhostBarPickerCellNode.h
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 18.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTSpriteNode.h"

@interface MTGhostBarPickerCellNode : MTSpriteNode
@property MTSpriteNode *node;

-(id) initWithNode:(MTSpriteNode *) node;
@end
