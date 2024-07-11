//
//  MTConditionNode.h
//  MagicTrains
//
//  Created by Kamil Tomasiak on 27.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTSpriteNode.h"

@interface MTConditionNode : MTSpriteNode

@property (nonatomic) BOOL checked;
@property (weak) NSObject *myParent;

-(void) prepareWithImageNamed:(NSString *)name position: (CGPoint)position andParent:(NSObject*)myParent;
-(id)initWithImageNamed:(NSString*)s;

@end
