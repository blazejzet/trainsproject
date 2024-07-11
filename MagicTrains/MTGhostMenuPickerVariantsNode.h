//
//  MTGhostMenuPickerVariantsNode.h
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 29.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTSpriteNode.h"

@interface MTGhostMenuPickerVariantsNode : MTSpriteNode

-(id) initWithPosition:(CGPoint)point andCostume:(NSString*)costume;

@property NSString *costumeName;

@end
