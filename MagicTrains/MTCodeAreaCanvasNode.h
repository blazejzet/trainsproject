//
//  MTCodeAreaCanvasNode.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 26.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTSpriteNode.h"
@class MTBlockNode;
@interface MTCodeAreaCanvasNode : MTSpriteNode
-(id)initWithTexture:(SKTexture *) texture Size:(CGSize) size;
-(void)blockDrop:(MTBlockNode*)block;
@end
