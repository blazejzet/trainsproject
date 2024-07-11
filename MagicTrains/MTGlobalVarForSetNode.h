//
//  MTGlobalVarForSet.h
//  MagicTrains
//
//  Created by Kamil Tomasiak on 28.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTSpriteNode.h"

@interface MTGlobalVarForSetNode : MTSpriteNode

@property (nonatomic) BOOL checked;
@property (weak) NSObject *myParent;
@property NSString * kind;
@property uint numberGlobalVariable;
@property CGPoint positionBackup;

-(id) prepareWithNumberGlobalVariable: (uint)numberGlobalVariable Image :(NSString*)image position: (CGPoint)position andParent:(NSObject*)myParent kindOfGlobalVar: (NSString*) kind size: (CGSize) size;


@end
