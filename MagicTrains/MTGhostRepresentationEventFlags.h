//
//  MTGhostRepresentationEventFlags.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 18.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MTGhostRepresentationNode;
@interface MTGhostRepresentationEventFlags : NSObject

//joystic
@property bool aButtonFlag;
@property bool bButtonFlag;
@property bool leftArrowFlag;
@property bool rightArrowFlag;
@property bool upArrowFlag;
@property bool downArrowFlag;

//sygnaly
@property int purpleSignalFlag;
@property int orangeSignalFlag;
@property int blueSignalFlag;

@property bool HPFlag;


//gyroscop
@property bool leftGyroscopeFlag;
@property bool rightGyroscopeFlag;


@property bool joystickDropFlag;
@property CGPoint joystickDropForce;

@property bool observersExists;

-(id) init;
-(id) initWithGRN: (MTGhostRepresentationNode *)GRN;
-(void) removeNotifications;
-(void) prepareFlags;
-(void) addObserversWithGRN:(MTGhostRepresentationNode*)GRN;

//gyroscope
-(void) unSetLeftGyroscopeFlag;
-(bool) getLeftGyroscopeFlag;

-(void) unSetRightGyroscopeFlag;
-(bool) getRightGyroscopeFlag;

//joystic
-(void) unSetBButtonFlag;
-(bool) getBButtonFlag;

-(void) unSetAButtonFlag;
-(bool) getAButtonFlag;

-(void) unSetLeftArrowFlag;
-(bool) getLeftArrowFlag;

-(void) unSetRightArrowFlag;
-(bool) getRightArrowFlag;

-(void) unSetUpArrowFlag;
-(bool) getUpArrowFlag;

-(void) unSetDownArrowFlag;
-(bool) getDownArrowFlag;

-(void) unSetJoystickDropFlag;
-(bool) getJoystickDropFlag;
-(CGPoint) getJoystickDropForce;
-(void) unSetJoystickDropForce;


//sygnaly
-(void) unSetPurpleSignalFlag;
-(int) getPurpleSignalFlag;

-(void) unSetOrangeSignalFlag;
-(int) getOrangeSignalFlag;

-(void) unSetBlueSignalFlag;
-(int) getBlueSignalFlag;


-(void) unSetHPFlag;
-(void) setHPFlag;
-(bool) getHPFlag;



@end
