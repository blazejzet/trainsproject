//
//  MTCodeAreaNode.h
//  testNodow
//
//  Created by Dawid Skrzypczyński on 18.12.2013.
//  Copyright (c) 2013 UMK. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MTSpriteNode.h"
#import "MTBlockNode.h"
#import "MTCategoryBarNode.h"
#import "MTCodeAreaCanvasNode.h"
#import "MTHelpView.h"
#import "MTCoverableProtocol.h"

#define CODE_AREA_NODE_NAME @"MTCodeAreaNode"
@class MTTrashNode;

@interface MTCodeAreaNode : MTSpriteNode <MTCoverableProtocol>

@property uint canvasCounter;
@property MTCodeAreaCanvasNode* primaryCanvas;
@property MTTrashNode * bin;
@property SKNode* tabParent;
//@property MTBlockNode* block;


-(void) deNotify;
-(void) initCanvas;
-(void) initCodeTabsWithParent: (SKNode *) parent;
-(void) update : (NSNotification *) notif;
-(void) selectFirstTab;
-(void) categoryBarInit;
-(void) blockDrop : (MTBlockNode *) block;
-(void) holdedBlock : (MTBlockNode *)block;
-(void) calculateMyHeight;
-(void) putMeIntoGoodPosition:(CGPoint) newPos;
-(int) getSelectedTabNumber;
-(CGFloat) maxTrainYPos;
@end
