//
//  MTGhostMenuIconNode.h
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 06.04.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTSpriteNode.h"

@class MTGhost;

@interface MTGhostMenuIconNode : MTSpriteNode

@property MTGhost *myGhost;
-(id) initWithTexture:(SKTexture*)texture andGhost:(MTGhost*)ghost;
-(void) repaintIcon:(NSString*)textureName;
@end
