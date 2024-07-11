//
//  MTNotSandboxProjectOrganizer.h
//  TrainsProject
//
//  Created by Mateusz Wieczorkowski on 03.04.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import "MTGUI.h"
#import "MTResources.h"
#import "MTCategoryBarNode.h"
#import "MTViewController.h"
#import "MTCategoryIconNode.h"
#import "MTMainScene.h"
#import "MTCodeAreaNode.h"
#import "MTStorage.h"
#import "MTGhost.h"
#import "MTGhostsBarNode.h"
#import "MTSpriteNode.h"
#import "MTCodeTabNode.h"

@interface MTNotSandboxProjectOrganizer : NSObject

@property MTCategoryBarNode *cbn;
@property MTCodeAreaNode *can;
@property MTGhostsBarNode *gbn;
@property (weak) MTMainScene *mainscene;
@property MTResources *resources;
@property NSMutableArray *CartsInCategories;

+(MTNotSandboxProjectOrganizer *) getInstance;
-(void)calculateCartsInCategories;

/*KATEGORIE WAGONOW*/
-(void)unactiveCategoryIconsWithoutCarts;
-(void)unactiveAllCategoryIcons;
-(void)activeAllCategoryIcons;

/*TABY*/
-(bool) isSelectedTabBlocked;
-(void) preprareCategoryIconsForThisTap;

-(bool) isThisTabBlocked: (int)tabNumber;
-(void) prepareCategoryIconsForTab: (int)tabNumber;

-(void) updateTabTextures;

@end
