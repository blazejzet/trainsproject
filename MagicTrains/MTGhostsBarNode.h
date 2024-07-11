//
//  MTGhostsBarNode.h
//  testNodow
//
//  Created by Dawid Skrzypczyński on 18.12.2013.
//  Copyright (c) 2013 UMK. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MTSpriteNode.h"
#import "MTGhostBarPickerNode.h"
#import "MTRibbon.h"

@class MTGhost;
@class MTGhostIconNode;
@class MTSceneAreaNode;
@interface MTGhostsBarNode : MTSpriteNode
@property NSMutableArray *icons;
@property MTGhostBarPickerNode *picker;
@property MTRibbon * ribbon;
@property bool isGhostBarOpened;

-(void) addNewGhostIcon;
-(MTGhost*) getSelectedGhost;
-(void) removeGhostIcon: (MTGhostIconNode *) icon;
-(void)moveRoot:(UIGestureRecognizer *)g v:(UIView *)v;
-(void) panGestureForGhostIcon:(UIGestureRecognizer *)g :(UIView *)v;
-(void) hideBar;
-(void) showBar;
-(void) showBarNM;
-(void) reloadGhostsFromStorage;
-(void) panGestureMain:(UIGestureRecognizer *)g :(UIView *)v;
@property int ghostIconQuota;
@property MTSceneAreaNode* SceneAreaNode;


@end
