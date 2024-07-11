//
//  MTGlobalVar.h
//  MagicTrains
//
//  Created by Programowanie Zespołowe on 14.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTSpriteNode.h"
@class MTWheelPanel;
@class MTWheelNode;

@interface MTVisibleGlobalVar : MTSpriteNode

@property int *variable;
//@property MTWheelNode *wheel;
// @property NSObject *myParent;
@property (weak) MTWheelPanel *myPanel;
@property CGFloat  * valuesFromStorage;
@property CGFloat  ** valuesFromOptions;
@property NSMutableArray * myVariables;
@property uint numberGlobalVar;
@property CGPoint positionBackup;

-(id) prepareWithNumberGlobalVar: (uint)numberGlobalVar imageName: (NSString*)image position: (CGPoint)position wheel: (MTWheelNode*) wheel andPanel:(MTWheelPanel*)myPanel myVariables: (NSMutableArray *)myVariables size: (CGSize )size;
/*
-(id) initWithNumberGlobalVar: (uint)numberGlobalVar imageName: (NSString*)image position: (CGPoint)position wheel: (MTWheelNode*) wheel andParent:(NSObject*)myParent
                  myVariables: (NSMutableArray *)myVariables size: (CGSize )size;
 */
@end
