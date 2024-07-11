//
//  MTGhostIconNode.h
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 27.02.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTSpriteNode.h"
@class MTGhost; 
@interface MTGhostIconNode : MTSpriteNode

@property MTGhost *myGhost;
//@property SKEffectNode *effectNode;
@property NSString *textureName;
@property float _scale;

-(void) makeMeSelected;
-(void) makeMeSelectedE;
-(id) initWithGhost:(MTGhost *)ghost;

-(void) remove;
+(MTGhostIconNode *) getSelectedIconNode;
-(void) repaintIcon:(NSString *) imgName;
//-(void) addGhostIcons;
-(void) makeMeUnselected;
-(void)showSmallMenuForSelectedGhost;
-(void)hideMenuForSelectedGhost;

@end
