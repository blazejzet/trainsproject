
//
//  MTStorage.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.02.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTGhostDefaults.h"
#import "MTProjectTypeEnum.h"
#import "MTCodeTabTypeEnum.h"
#import "MTCart.h"

@class MTGhost;
@class MTGhostRepresentationNode;

#define MAX_GHOST_COUNT 30

#define CURRENT_GGHOST_COUNT 42

@interface MTStorage: NSObject <NSCoding>

@property BOOL JoystickEnabled;
@property BOOL DebugEnabled;
@property MTProjectTypeEnum ProjectType;
//TODO dodaj listę MTStorage

@property int GhostCount;
@property NSString* filename;
@property NSMutableDictionary *ghostCostumes;
@property NSMutableDictionary *ghostDefaults;
@property NSMutableDictionary *usedCartsCounters;
@property NSMutableDictionary *maxCartsCounts;


+(void)clear;
//-(id)initFromArchive:(NSString *)filename;
-(id)initSingleton;
+(MTStorage *) getInstance;
+(MTStorage *) getNewInstance;
-(NSUInteger) getGhostCount;
-(MTCodeTabTypeEnum) getCodeTabTypeAt: (int) i;
-(id) addGhost;
-(void)setGhost:(MTGhost *) ghost At:(NSUInteger) n;
-(void) removeGhostAt:(uint) n;
-(MTGhost *)getGhostAt:(NSUInteger) n;
-(NSArray *)getAllGhosts;
-(MTGhostDefaults*) getGhostDefaults:(int)g;
-(BOOL)ghostCostumeIsSquare:(int)drn;
-(BOOL)ghostCostumeIsSpecial:(int)drn;
-(NSString*)getGhostsList;

-(void) incrementCounterForCart:(MTCart *) cart;
-(void) decrementCounterForCart:(MTCart *) cart;
@end
