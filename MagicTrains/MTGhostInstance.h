//
//  MTGhostInstance.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.02.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTSpriteNode.h"
#import "MTGhost.h"

@interface MTGhostInstance : NSObject <NSCoding>
-(id) initWithNr: (NSUInteger)ghostNumber;
-(void)setPosition:(CGPoint)pt;
-(MTGhost*)getMyGhost;
@property uint numberOfMyGhost;
@property MTSpriteNode *node;
@property NSString *ImageName;
@property NSString* costumeName;
@property NSMutableArray* costumeVisuals;

@end
