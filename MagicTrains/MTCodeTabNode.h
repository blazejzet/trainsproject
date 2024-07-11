//
//  MTCodeTabNode.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 03.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTSpriteNode.h"

@interface MTCodeTabNode : MTSpriteNode

+(void) resetSelectedPointer;
+(MTCodeTabNode *) getSelectedTab;
-(void) makeMeSelected;

@property int tabNumber;

@end
