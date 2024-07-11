//
//  MTGhostMenuPickerElementNode.h
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 26.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTSpriteNode.h"

@interface MTGhostMenuPickerElementNode : MTSpriteNode
@property NSString *imgName;
@property int myNumber;
-(id) initWithPosition: (CGPoint)p AndCostume:(NSString *)costume AndNumber:(int)number;
@end
