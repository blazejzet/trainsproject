//
//  MTMainScene.h
//  testNodow
//
//  Created by Dawid Skrzypczyński on 18.12.2013.
//  Copyright (c) 2013 UMK. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MTGestureDelegate.h"
#import "MTPhysicsManagement.h"
#import "MTSceneAreaNode.h"

@class MTStrategyOfSimultanousGestures;
@class MTStrategyOfAvailabilityGestures;
@class MTSpriteNode;

@interface MTMainScene : SKScene <UIGestureRecognizerDelegate> 
@property bool simultaneousGestures;
@property MTStrategyOfSimultanousGestures *simultaneousGesturesStrategy;
@property MTStrategyOfAvailabilityGestures *availabilityGesturesStrategy;
@property MTPhysicsManagement *physicsManagement;
@property MTSpriteNode *selectedNode;
@property id <MTGestureDelegate> service;
@property MTSpriteNode *root;
@property NSArray * inactiveCartList;
@property BOOL blocked;

@property (weak) MTSceneAreaNode * sceneAreaNode;

-(void)setIsBlocked:(BOOL) y;
-(int)rootPosition;
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

-(void)prepareGUI;
-(void)prepareGUI:(NSArray*)lista;

-(void)prepareSimultaneousPanPinchRotate;
-(void)prepareSimultaneousPinchRotate;
-(void)prepareSimultaneousNone;

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
-(void)prepareAvailabilityNoneGestures;
-(void)prepareAvailabilityAllGestures;

@end
