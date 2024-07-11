//
//  MTCategoryIconNode.h
//  MagicTrains
//
//  Created by Mateusz Wieczorkowski on 06.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTSpriteNode.h"

@interface MTCategoryIconNode : MTSpriteNode

@property uint CategoryNumber;
@property bool isActive; //Czy w kategorii są wagony? (przy zadaniach)
@property uint CartsInMe;

+(MTCategoryIconNode *) getSelectedIconNode;
-(void) makeMeUnselected;
-(void) makeMeSelected;
-(void) makeMeUnactive;
-(void) makeMeActive;
+(void) resetIcon;

@end
