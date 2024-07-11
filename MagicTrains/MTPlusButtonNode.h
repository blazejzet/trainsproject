//
//  MTPlusButtonNode.h
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 27.02.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MTSpriteNode.h"

@interface MTPlusButtonNode : MTSpriteNode


-(void) makeMeUnActive;
-(void) makeMeActive;
@property bool isActive;
@end
