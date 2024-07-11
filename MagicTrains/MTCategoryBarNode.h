//
//  MTCategoryBarNode.h
//  testNodow
//
//  Created by Dawid Skrzypczyński on 18.12.2013.
//  Copyright (c) 2013 UMK. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MTSpriteNode.h"

@class MTBlockNode;
@interface MTCategoryBarNode : MTSpriteNode

@property float positionWhenOpened;
@property bool isOpened;
@property bool isAppOptionsOpened;
@property bool someOptionsOpened;
@property NSArray* inactiveCartList;
@property MTBlockNode* optionsBlock;
@property NSMutableArray* cartsInCategories;

-(void) openBlocksArea;
-(void) closeBlocksArea;
-(void) openBlocksAreaWithOptionsForBlock :(MTBlockNode*) block;
-(void) closeOpenedOptions;
-(void) openAppOptions;
-(void) closeAppOptions;
-(void)refreshCategories;

-(void) unactiveAllCategories;
-(void) activeAllCategories;
@end
