//
//  MTTrashNode.h
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 10.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTSpriteNode.h"
#import "MTBlockNode.h"
#import "MTGhost.h"
#import "MTGhostRepresentationNode.h"
#import "MTGhostsBarNode.h"
@interface MTTrashNode : MTSpriteNode

//-(id) initWithSize: (CGSize) size;

@property SKAction* rotateBin;
@property SKAction* hideBin;
@property SKAction* showBin;
-(void) showTrash;
-(void) hideTrash;

-(void) blockDrop:(MTBlockNode *) block;
-(void) ghostRepDrop:(MTGhostRepresentationNode *) ghostRep;
@end
