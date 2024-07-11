//
//  MTCancelButtonNode.h
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 16.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTSpriteNode.h"

@interface MTCancelButtonNode : MTSpriteNode
-(id) initWithDialogName: (NSString *)dialogName;
@property NSString *dialogName;
@end
