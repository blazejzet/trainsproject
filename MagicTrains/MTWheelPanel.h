//
//  MTWheelPanel.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 18.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTWheelNode.h"
#import "MTOptionsPanel.h"
#import "MTVisibleGlobalVar.h"
#import "MTGhostRepresentationNode.h"

@interface MTWheelPanel : MTOptionsPanel 

@property MTWheelNode * wheel;
@property MTVisibleGlobalVar *var1;
@property MTVisibleGlobalVar *var2;
@property MTVisibleGlobalVar *var3;
@property MTVisibleGlobalVar *var4;
@property MTVisibleGlobalVar *var5;
@property MTVisibleGlobalVar *ghostHpVar;
@property MTVisibleGlobalVar *varX;
@property MTVisibleGlobalVar *varY;
@property MTSpriteNode *deck;

@property NSMutableArray *myVariables;

@property (nonatomic) NSUInteger numberSelectedVariable;

-(CGFloat) getMySelectedValueWithGhostRepNode:(MTGhostRepresentationNode *) ghostRepNode;

-(void) prepareAsUpperPanelWithMax: (int) max Min:(int) min fullRotate:(int) fullRot;
-(void) prepareAsLowerPanelWithMax: (int) max Min:(int) min fullRotate:(int) fullRot;
-(void) prepareAsMiddlePanelWithMax:(int) max Min:(int) min fullRotate:(int) fullRot;
-(void) prepareAsMidLowPanelWithMax:(int) max Min:(int) min fullRotate:(int) fullRot;

-(void)setImage:(NSString*)i;
-(void) showPanel;
-(void) hidePanel;

@end
