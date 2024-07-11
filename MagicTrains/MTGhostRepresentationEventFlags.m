//
//  MTGhostRepresentationEventFlags.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 18.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTGhostRepresentationEventFlags.h"
#import "MTJoystickNotificationsNames.h"
#import "MTSignalNotificationNames.h"
#import "MTNotificationNames.h"
#import "MTJoystickCenterNode.h"
#import "MTGhostRepresentationNode.h"

@implementation MTGhostRepresentationEventFlags

-(id) init
{
    [self prepareFlags];
    
    [self addObserversWithGRN:nil];
    
    self.observersExists = true;
    
    return self;
}

-(id) initWithGRN: (MTGhostRepresentationNode *)GRN
{
    [self prepareFlags];
    
    [self addObserversWithGRN:GRN];
    
    self.observersExists = true;
    
    return self;
}

-(void) prepareFlags
{
    self.aButtonFlag = false;
    self.bButtonFlag = false;
    self.leftArrowFlag = false;
    self.rightArrowFlag = false;
    self.upArrowFlag = false;
    self.downArrowFlag = false;
    
    self.purpleSignalFlag = false;
    self.orangeSignalFlag = false;
    self.blueSignalFlag = false;
    
    self.leftGyroscopeFlag = false;
    self.rightGyroscopeFlag = false;
    self.HPFlag = false;
    
    self.joystickDropFlag=false;
    self.joystickDropForce=CGPointMake(0, 0);
}

//usuniecie notyfikacji dla klonow wykozystywane
-(void) removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.observersExists = false;
}

-(void) addObserversWithGRN:(MTGhostRepresentationNode *)GRN
{
    //centrum notyfikacji joysticka
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAButtonFlag) name: N_JoystickAButtonPush object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBButtonFlag) name: N_JoystickBButtonPush object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLeftArrowFlag) name: N_JoystickLeftArrowPush object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRightArrowFlag) name: N_JoystickRightArrowPush object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpArrowFlag) name: N_JoystickUpArrowPush object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDownArrowFlag) name: N_JoystickDownArrowPush object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveJoistickDropNotification:) name: N_JoystickLeftArrowDrop object:nil];
    
    
    //centrum notyfikacji sygnalow
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPurpleSignalFlag) name:N_Send_Purple_Signal object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setOrangeSignalFlag) name:N_Send_Orange_Signal object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBlueSignalFlag) name:N_Send_Blue_Signal object:nil];
    
    //dodanie obserwatorow dla gyroscopu
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLeftGyroscopeFlag) name: N_Gyroscope_Left_Signal object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRightGyroscopeFlag) name: N_Gyroscope_Right_Signal object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setHPFlag) name:N_HP_Signal object:GRN];
    
    self.observersExists = true;
}
//metody dla gyroscopu
-(void) setLeftGyroscopeFlag
{
    self.leftGyroscopeFlag = true;
}

-(void) unSetLeftGyroscopeFlag
{
    self.leftGyroscopeFlag = false;
}
-(void) unSetHPFlag
{
    self.HPFlag = false;
}
-(bool) getHPFlag
{
    return self.HPFlag;
}
-(void) setHPFlag
{
    
    self.HPFlag = true;

}

-(bool) getLeftGyroscopeFlag
{
    return self.leftGyroscopeFlag;
}

-(void) setRightGyroscopeFlag
{
    self.rightGyroscopeFlag = true;
}

-(void) unSetRightGyroscopeFlag
{
    self.rightGyroscopeFlag = false;
}

-(bool) getRightGyroscopeFlag
{
    return self.rightGyroscopeFlag;
}


//metody sygnalu purple
-(void) setPurpleSignalFlag
{
    self.purpleSignalFlag +=1;
}

-(void) unSetPurpleSignalFlag
{
    self.purpleSignalFlag -= 1;
}

-(int) getPurpleSignalFlag
{
    return self.purpleSignalFlag;
}


//metody sygnalu orange
-(void) setOrangeSignalFlag
{
    self.orangeSignalFlag +=1;
}

-(void) unSetOrangeSignalFlag
{
    self.orangeSignalFlag -=1;
}

-(int) getOrangeSignalFlag
{
    return self.orangeSignalFlag;
}

//metody sygnalu blue
-(void) setBlueSignalFlag
{
    self.blueSignalFlag +=1;
}

-(void) unSetBlueSignalFlag
{
    self.blueSignalFlag -=1;
}

-(int) getBlueSignalFlag
{
    return self.blueSignalFlag;
}

//metody joustica
-(void) setAButtonFlag
{

#if DEBUG_NSLog
    ////NSLog(@"ustawiam flage");
#endif
    
    self.aButtonFlag = true;
}

-(void) unSetAButtonFlag
{
    self.aButtonFlag = false;
}

-(bool) getAButtonFlag
{
    return self.aButtonFlag;
}


-(void) setBButtonFlag
{
    self.bButtonFlag = true;
}

-(void) unSetBButtonFlag
{
    self.bButtonFlag = false;
}

-(bool) getBButtonFlag
{
    return self.bButtonFlag;
}


-(void) setLeftArrowFlag
{
    self.leftArrowFlag = true;
}

-(void) unSetLeftArrowFlag
{
    self.leftArrowFlag = false;
}

-(bool) getLeftArrowFlag
{
    return self.leftArrowFlag;
}


-(void) setRightArrowFlag
{
    self.rightArrowFlag = true;
}

-(void) unSetRightArrowFlag
{
    self.rightArrowFlag = false;
}

-(bool) getRightArrowFlag
{
    return self.rightArrowFlag;
}


-(void) setUpArrowFlag
{
    self.upArrowFlag = true;
}

-(void) unSetUpArrowFlag
{
    self.upArrowFlag = false;
}

-(bool) getUpArrowFlag
{
    return self.upArrowFlag;
}


-(void) setDownArrowFlag
{
    self.downArrowFlag = true;
}

-(void) unSetDownArrowFlag
{
    self.downArrowFlag = false;
}

-(bool) getDownArrowFlag
{
    return self.downArrowFlag;
}


-(void) unSetJoystickDropFlag{
    self.joystickDropFlag=false;
    //self.joystickDropForce=CGPointMake(0, 0);
}
-(void) unSetJoystickDropForce{
//    self.joystickDropFlag=false;
    self.joystickDropForce=CGPointMake(0, 0);
}
-(bool) getJoystickDropFlag{
 return   self.joystickDropFlag;
}
-(CGPoint) getJoystickDropForce{
    return self.joystickDropForce;
}
- (void) receiveJoistickDropNotification:(NSNotification *) notification{
    MTJoystickCenterNode* c = (MTJoystickCenterNode*)notification.object;
    self.joystickDropFlag=true;
    self.joystickDropForce=c.force;
}


@end
