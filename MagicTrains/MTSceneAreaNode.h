//
//  MTSceneAreaNode.h
//  testNodow
//
//  Created by Dawid Skrzypczyński on 18.12.2013.
//  Copyright (c) 2013 UMK. All rights reserved.0
//

#import <SpriteKit/SpriteKit.h>
#import "MTSpriteNode.h"
#import "MTLabelNode.h"
#import "MTGhost.h"
#import "MTEndCloneButtonNode.h"

@class MTGhostRepresentationNode;
@class MTGhostInstance;
@class MTGhostIconNode;
@class MTTrashNode;
@class MTGhostMenuNode;
@class MTGhostsBarNode;
@interface MTSceneAreaNode : MTSpriteNode
@property bool blocked;
//@property bool debugMode; /*TRUE = wlaczony tryb debugowania w stanie symulacji (widok zmiennych)*/
//@property bool joystickMode;
@property bool menuMode;
@property bool drawableBackground;
@property bool addOneCloneMode;
@property bool addMultiCloneMode;
@property bool endCloneButtonExists;
@property MTEndCloneButtonNode* ecbn;
@property MTTrashNode* bin;
@property NSMutableArray *ghostsRepresentations;
@property MTGhostMenuNode *ghostMenu;
@property NSMutableArray *joystickElements;
@property NSMutableArray *debugElements;
@property MTLabelNode *textGameOver;
@property MTSpriteNode *textVictory;
@property MTSpriteNode *backgroundA;
@property MTSpriteNode *backgroundB;


/*Flagi informujace czy wagon utworzyl juz instancje widoku zmiennej globalnej*/
@property bool globalVar1Cart;
@property bool globalVar2Cart;
@property bool globalVar3Cart;
@property bool globalVar4Cart;
@property bool HPCart;
/*Funkcje dodajace do sceny zmienne globalne z pociagow*/
-(void) addHPVar;
-(void) addGlobalVar1;
-(void) addGlobalVar2;
-(void) addGlobalVar3;
-(void) addGlobalVar4;
-(void)addGhostRepresentationNodesWithGhostBar: (MTGhostsBarNode *)ghostBar;
-(void)addGhostRepresentationNodesWithGhostIcon: (MTGhostIconNode *) icon;
-(void)addGhostRepresentationNodeWith:(MTGhostInstance *) ghostInst ghostIcon: (MTGhostIconNode *) icon;
-(void)addGhostRepresentationNodeWith: (MTGhostInstance *) ghostInst ghostIcon: (MTGhostIconNode *) icon :(BOOL)blocked;
-(void)menuModeOn;
-(void)menuModeOff;
-(void)addOneCloneModeOn;
-(void)addOneCloneModeOff;
-(void)addMultiCloneModeOn;
-(void)addMultiCloneModeOff;
-(void)deleteAllClones;
-(void)addBinForGhostRep:(MTGhostRepresentationNode *)ghostRep;
-(void)refreshRepresentationNodeOfGhostInstance:(MTGhostInstance *)ghostInst;
-(void)refreshMassNodeOfGhostInstance:(MTGhostInstance *)ghostInst andMass:(int)m;
-(void)removeBin;
-(void)addMenu:(MTGhostMenuNode *)menu;
-(void) addNewGhostInstance: (UIGestureRecognizer *)g;
-(void)removeMenu;
-(void)addJoystick;
-(void) removeJoystick;
-(void)addDebugAddons;
-(void)removeDebugAddons;
-(void) addTextGameOver;
-(void) addTextVictory;
-(void) removeTextVictory;
-(void)simulationEnd;
-(void)saveRepresentationNodes;
-(int) countRepsForGhost:(MTGhost *) ghost WithRepType:(NSString *)repType;
-(int) countAllRepresentationsforGhosts:(NSMutableArray *)array;
-(NSArray *) getAllGhostRepresentationNodes;
/*
 Nasluchuje na zmiany nodow
 
 */
@end
