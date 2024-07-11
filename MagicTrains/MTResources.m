//
//  MTResources.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 14.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTResources.h"
#import "MTCartFactory.h"

#import "MTLocomotive.h"
#import "MTAlwaysLocomotiv.h"
#import "MTHPLocomotiv.h"

#import "MTRecieveSignalLocomotiv.h"
#import "MTRecieveBlueSignalLocomotiv.h"
#import "MTRecieveOrangeSignalLocomotiv.h"
/*Lokomotywy kolizyjne */
#import "MTCollisionWithRightWallLocomotiv.h"
#import "MTCollisionWithLeftWallLocomotiv.h"
#import "MTCollisionWithTopWallLocomotiv.h"
#import "MTCollisionWithBottomWallLocomotiv.h"

#import "MTCollisionWithAnotherGhostLocomotiv.h"

/* Lokomotywy zwiazane z joystickiem */
#import "MTLeftArrowLocomotiv.h"
#import "MTRightArrowLocomotiv.h"
#import "MTUpArrowLocomotiv.h"
#import "MTDownArrowLocomotiv.h"
#import "MTAButtonLocomotiv.h"
#import "MTBButtonLocomotiv.h"
#import "MTJoystickDropLocomotiv.h"

#import "MTGyroscopeLeftLocomotiv.h"
#import "MTGyroscopeRightLocomotiv.h"

/* Bloczki zwiazane z ruchem */
#import "MTLeftRotationCart.h"
#import "MTRightRotationCart.h"
#import "MTRotateToAngleCart.h"
#import "MTGoLeftCart.h"
#import "MTGoRightCart.h"
#import "MTGoTopCart.h"
#import "MTGoXYCart.h"
#import "MTGoDownCart.h"

#import "MTGoLeftShotCart.h"
#import "MTGoRightShotCart.h"
#import "MTGoTopShotCart.h"
#import "MTGoDownShotCart.h"

#import "MTResizeUpCart.h"
#import "MTResizeDownCart.h"


#import "MTresetDraw.h"
#import "MTendDraw.h"

#import "MTPauseCart.h"
#import "MTShowGlobalVar.h"
#import "MTSendSignalCart.h"
#import "MTSendOrangeSignalCart.h"
#import "MTSendBlueSignalCart.h"
#import "MTMessageGameOverCart.h"

#import "MTSubTrainCart.h"
#import "MTForLoopCart.h"
#import "MTIfCart.h"

#import "MTgOFF.h"
#import "MTgON.h"
#import "MTgOFFm.h"
#import "MTgONm.h"
#import "MTgOFFmMy.h"
#import "MTgONmMy.h"
#import "MTgONmMyMass.h"
#import "MTgOFFmMyMass.h"

#import "MTgONGDIR.h"
#import "MTgOFFGDIR.h"

#import "MTgOFFmrev.h"
#import "MTgONmrev.h"

#import "MTgOFFkg.h"
#import "MTgONkg.h"
#import "MTgGlobalOFF.h"
#import "MTgGlobalON.h"
#import "MTjOFF.h"
#import "MTjON.h"


#import "MTCloneMeCart.h"
#import "MTJointMeCart.h"
#import "MTDisJointMeCart.h"

#import "MTFullJointMeCart.h"
#import "MTDisFullJointMeCart.h"
#import "MTRemoveMyGhostCart.h"
#import "MTHpIncreaseValueCart.h"
#import "MTHpReduceValueCart.h"
#import "MTMoveXInSimulationON.h"
#import "MTMoveXInSimulationOFF.h"
#import "MTMoveYInSimulationON.h"
#import "MTMoveYInSimulationOFF.h"

#import "MTGlobalVarPlusVariableCart.h"
#import "MTGlobalVarMultiplyThrowVariable.h"
#import "MTGlobalVarDivideThrowVariable.h"
#import "MTGlobalVarMinusVariable.h"
#import "MTGlobalVarEqualVariable.h"

#import "MTMessageVictoryCart.h"

#import "MTSwitchCostumeCart.h"
#import "MTSwitchCostumeColorCart.h"

#import "MTReAlphaCart.h"


#import "MTdrawMe.h"
#import "MTdontDrawMe.h"


@implementation MTResources

static MTResources* myMTResourcesInstance;

+(MTResources* ) getInstance{
    if (myMTResourcesInstance != nil)
        return myMTResourcesInstance;
    myMTResourcesInstance = [[MTResources alloc] init];
    return myMTResourcesInstance;
}

+(MTResources* ) getInstance:(NSArray*)lista{
    if (myMTResourcesInstance != nil)
        return myMTResourcesInstance;
    myMTResourcesInstance = [[MTResources alloc] init:lista];
    return myMTResourcesInstance;
}

-(id)init
{
    self = [self init:[NSArray array]];
    return self;
}
/* inicjalizacja dodająca obiekty wagoników do słownika oraz ich klucze do tablicy kluczy */
-(id)init:(NSArray*)lista
{
    self.carts = [[NSMutableDictionary alloc] init];
    self.keys = [[NSMutableArray alloc]init];
    /*** LOKOMOTYWY ***/
    [self.carts setValue:[[MTLocomotive alloc] init] forKey: [MTLocomotive getMyType]];
    [self.keys addObject:[MTLocomotive getMyType]];
    [self.carts setValue:[[MTHPLocomotiv alloc] init] forKey:[MTHPLocomotiv getMyType]];
    [self.keys addObject:[MTHPLocomotiv getMyType]];
    [self.carts setValue:[[MTAButtonLocomotiv alloc] init] forKey:[MTAButtonLocomotiv getMyType]];
    [self.keys addObject:[MTAButtonLocomotiv getMyType]];
    [self.carts setValue:[[MTBButtonLocomotiv alloc] init] forKey:[MTBButtonLocomotiv getMyType]];
    [self.keys addObject:[MTBButtonLocomotiv getMyType]];
    
    [self.carts setValue:[[MTLeftArrowLocomotiv alloc] init] forKey:[MTLeftArrowLocomotiv getMyType]];
    [self.keys addObject:[MTLeftArrowLocomotiv getMyType]];
    [self.carts setValue:[[MTRightArrowLocomotiv alloc] init] forKey:[MTRightArrowLocomotiv getMyType]];
    [self.keys addObject:[MTRightArrowLocomotiv getMyType]];
    [self.carts setValue:[[MTUpArrowLocomotiv alloc] init] forKey:[MTUpArrowLocomotiv getMyType]];
    [self.keys addObject:[MTUpArrowLocomotiv getMyType]];
    [self.carts setValue:[[MTDownArrowLocomotiv alloc] init] forKey:[MTDownArrowLocomotiv getMyType]];
    [self.keys addObject:[MTDownArrowLocomotiv getMyType]];
    
    [self.carts setValue:[[MTJoystickDropLocomotiv alloc] init] forKey:[MTJoystickDropLocomotiv getMyType]];
    [self.keys addObject:[MTJoystickDropLocomotiv getMyType]];
    
    [self.carts setValue:[[MTCollisionWithLeftWallLocomotiv alloc] init] forKey:[MTCollisionWithLeftWallLocomotiv getMyType]];
    [self.keys addObject:[MTCollisionWithLeftWallLocomotiv getMyType]];
    [self.carts setValue:[[MTCollisionWithRightWallLocomotiv alloc] init] forKey:[MTCollisionWithRightWallLocomotiv getMyType]];
    [self.keys addObject:[MTCollisionWithRightWallLocomotiv getMyType]];
    [self.carts setValue:[[MTCollisionWithTopWallLocomotiv alloc] init] forKey:[MTCollisionWithTopWallLocomotiv getMyType]];
    [self.keys addObject:[MTCollisionWithTopWallLocomotiv getMyType]];
    [self.carts setValue:[[MTCollisionWithBottomWallLocomotiv alloc] init] forKey:[MTCollisionWithBottomWallLocomotiv getMyType]];
    [self.keys addObject:[MTCollisionWithBottomWallLocomotiv getMyType]];
    
    [self.carts setValue:[[MTCollisionWithAnotherGhostLocomotiv alloc] init] forKey:[MTCollisionWithAnotherGhostLocomotiv getMyType]];
    [self.keys addObject:[MTCollisionWithAnotherGhostLocomotiv getMyType]];
    [self.carts setValue:[[MTRecieveSignalLocomotiv alloc] init] forKey: [MTRecieveSignalLocomotiv getMyType]];
    [self.keys addObject:[MTRecieveSignalLocomotiv getMyType]];
    [self.carts setValue:[[MTRecieveBlueSignalLocomotiv alloc] init] forKey: [MTRecieveBlueSignalLocomotiv getMyType]];
    [self.keys addObject:[MTRecieveBlueSignalLocomotiv getMyType]];
    [self.carts setValue:[[MTRecieveOrangeSignalLocomotiv alloc] init] forKey: [MTRecieveOrangeSignalLocomotiv getMyType]];
    [self.keys addObject:[MTRecieveOrangeSignalLocomotiv getMyType]];

    /* ZYROSKOP */
    [self.carts setValue:[[MTGyroscopeLeftLocomotiv alloc] init] forKey:[MTGyroscopeLeftLocomotiv getMyType]];
    [self.keys addObject:[MTGyroscopeLeftLocomotiv getMyType]];
    [self.carts setValue:[[MTGyroscopeRightLocomotiv alloc] init] forKey:[MTGyroscopeRightLocomotiv getMyType]];
    [self.keys addObject:[MTGyroscopeRightLocomotiv getMyType]];
    
    /*** RUCH ***/
    
    [self.carts setValue:[[MTGoLeftCart alloc] init] forKey: [MTGoLeftCart getMyType]];
    [self.keys addObject:[MTGoLeftCart getMyType]];
    [self.carts setValue:[[MTGoRightCart alloc] init] forKey: [MTGoRightCart getMyType]];
    [self.keys addObject:[MTGoRightCart getMyType]];
    [self.carts setValue:[[MTGoTopCart alloc] init] forKey: [MTGoTopCart getMyType]];
    [self.keys addObject:[MTGoTopCart getMyType]];
    [self.carts setValue:[[MTGoDownCart alloc] init] forKey: [MTGoDownCart getMyType]];
    [self.keys addObject:[MTGoDownCart getMyType]];
    
    [self.carts setValue:[[MTGoLeftShotCart alloc] init] forKey: [MTGoLeftShotCart getMyType]];
    [self.keys addObject:[MTGoLeftShotCart getMyType]];
    [self.carts setValue:[[MTGoRightShotCart alloc] init] forKey: [MTGoRightShotCart getMyType]];
    [self.keys addObject:[MTGoRightShotCart getMyType]];
    [self.carts setValue:[[MTGoTopShotCart alloc] init] forKey: [MTGoTopShotCart getMyType]];
    [self.keys addObject:[MTGoTopShotCart getMyType]];
    [self.carts setValue:[[MTGoDownShotCart alloc] init] forKey: [MTGoDownShotCart getMyType]];
    [self.keys addObject:[MTGoDownShotCart getMyType]];
    
    [self.carts setValue:[[MTLeftRotationCart alloc]  init] forKey: [MTLeftRotationCart getMyType]];
    [self.keys addObject:[MTLeftRotationCart getMyType]];
    [self.carts setValue:[[MTRightRotationCart alloc]  init] forKey: [MTRightRotationCart getMyType]];
    [self.keys addObject:[MTRightRotationCart getMyType]];
    [self.carts setValue:[[MTRotateToAngleCart alloc]  init] forKey: [MTRotateToAngleCart getMyType]];
    [self.keys addObject:[MTRotateToAngleCart getMyType]];
    
    [self.carts setValue:[[MTGoXYCart alloc] init] forKey: [MTGoXYCart getMyType]];
    [self.keys addObject:[MTGoXYCart getMyType]];
    
    
    
    [self.carts setValue:[[MTdrawMe alloc] init] forKey: [MTdrawMe getMyType]];
    [self.keys addObject:[MTdrawMe getMyType]];
    
    [self.carts setValue:[[MTdontDrawMe alloc] init] forKey: [MTdontDrawMe getMyType]];
    [self.keys addObject:[MTdontDrawMe getMyType]];
    
    
    [self.carts setValue:[[MTendDraw alloc] init] forKey: [MTendDraw getMyType]];
    [self.keys addObject:[MTendDraw getMyType]];
    
    [self.carts setValue:[[MTresetDraw alloc] init] forKey: [MTresetDraw getMyType]];
    [self.keys addObject:[MTresetDraw getMyType]];
    
    
   
    
    /*** STEROWANIE ***/
    [self.carts setValue:[[MTPauseCart alloc] init] forKey: [MTPauseCart getMyType]];
    [self.keys addObject:[MTPauseCart getMyType]];
    [self.carts setValue:[[MTSendSignalCart alloc] init] forKey:[MTSendSignalCart getMyType]];
    [self.keys addObject:[MTSendSignalCart getMyType]];
    [self.carts setValue:[[MTSendBlueSignalCart alloc]init] forKey:[MTSendBlueSignalCart getMyType]];
    [self.keys addObject:[MTSendBlueSignalCart getMyType]];
    [self.carts setValue:[[MTSendOrangeSignalCart alloc]init] forKey:[MTSendOrangeSignalCart getMyType]];
    [self.keys addObject:[MTSendOrangeSignalCart getMyType]];
    [self.carts setValue:[[MTMessageGameOverCart alloc]init] forKey:[MTMessageGameOverCart getMyType]];
    [self.keys addObject:[MTMessageGameOverCart getMyType]];
    
    [self.carts setValue:[[MTMessageVictoryCart alloc]init] forKey:[MTMessageVictoryCart getMyType]];
    [self.keys addObject:[MTMessageVictoryCart getMyType]];
    
    [self.carts setValue:[[MTShowGlobalVar alloc]init] forKey:[MTShowGlobalVar getMyType]];
    [self.keys addObject:[MTShowGlobalVar getMyType]];
    
    /*** PETLE ***/
    [self.carts setValue:[[MTForLoopCart alloc] init] forKey: [MTForLoopCart getMyType]];
    [self.keys addObject:[MTForLoopCart getMyType]];
    [self.carts setValue:[[MTIfCart alloc] init] forKey: [MTIfCart getMyType]];
    [self.keys addObject:[MTIfCart getMyType]];
     
    /*GHOST*/
    [self.carts setValue:[[MTHpReduceValueCart alloc] init] forKey: [MTHpReduceValueCart getMyType]];
    [self.keys addObject:[MTHpReduceValueCart getMyType]];
    [self.carts setValue:[[MTHpIncreaseValueCart alloc] init] forKey: [MTHpIncreaseValueCart getMyType]];
    [self.keys addObject:[MTHpIncreaseValueCart getMyType]];
    [self.carts setValue:[[MTRemoveMyGhostCart alloc] init] forKey: [MTRemoveMyGhostCart getMyType]];
    [self.keys addObject:[MTRemoveMyGhostCart getMyType]];
    [self.carts setValue:[[MTCloneMeCart alloc] init] forKey: [MTCloneMeCart getMyType]];
    [self.keys addObject:[MTCloneMeCart getMyType]];
    
    [self.carts setValue:[[MTMoveXInSimulationON alloc] init] forKey: [MTMoveXInSimulationON getMyType]];
    [self.keys addObject:[MTMoveXInSimulationON getMyType]];
    [self.carts setValue:[[MTMoveXInSimulationOFF alloc] init] forKey: [MTMoveXInSimulationOFF getMyType]];
    [self.keys addObject:[MTMoveXInSimulationOFF getMyType]];
    [self.carts setValue:[[MTMoveYInSimulationON alloc] init] forKey: [MTMoveYInSimulationON getMyType]];
    [self.keys addObject:[MTMoveYInSimulationON getMyType]];
    [self.carts setValue:[[MTMoveYInSimulationOFF alloc] init] forKey: [MTMoveYInSimulationOFF getMyType]];
    [self.keys addObject:[MTMoveYInSimulationOFF getMyType]];
    
    [self.carts setValue:[[MTjON alloc] init] forKey: [MTjON getMyType]];
    [self.keys addObject:[MTjON getMyType]];
    [self.carts setValue:[[MTjOFF alloc] init] forKey: [MTjOFF getMyType]];
    [self.keys addObject:[MTjOFF getMyType]];
    [self.carts setValue:[[MTgON alloc] init] forKey: [MTgON getMyType]];
    [self.keys addObject:[MTgON getMyType]];
    [self.carts setValue:[[MTgOFF alloc] init] forKey: [MTgOFF getMyType]];
    [self.keys addObject:[MTgOFF getMyType]];
    
    
    [self.carts setValue:[[MTgONm alloc] init] forKey: [MTgONm getMyType]];
    [self.keys addObject:[MTgONm getMyType]];
    [self.carts setValue:[[MTgOFFm alloc] init] forKey: [MTgOFFm getMyType]];
    [self.keys addObject:[MTgOFFm getMyType]];
    
    
    
    [self.carts setValue:[[MTgONmMy alloc] init] forKey: [MTgONmMy getMyType]];
    [self.keys addObject:[MTgONmMy getMyType]];
    [self.carts setValue:[[MTgOFFmMy alloc] init] forKey: [MTgOFFmMy getMyType]];
    [self.keys addObject:[MTgOFFmMy getMyType]];
    
    [self.carts setValue:[[MTgONmrev alloc] init] forKey: [MTgONmrev getMyType]];
    [self.keys addObject:[MTgONmrev getMyType]];
    [self.carts setValue:[[MTgOFFmrev alloc] init] forKey: [MTgOFFmrev getMyType]];
    [self.keys addObject:[MTgOFFmrev getMyType]];
    
    [self.carts setValue:[[MTgGlobalON alloc] init] forKey: [MTgGlobalON getMyType]];
    [self.keys addObject:[MTgGlobalON getMyType]];
    
    [self.carts setValue:[[MTgGlobalOFF alloc] init] forKey: [MTgGlobalOFF getMyType]];
    [self.keys addObject:[MTgGlobalOFF getMyType]];
    
    [self.carts setValue:[[MTgONmMyMass alloc] init] forKey: [MTgONmMyMass getMyType]];
    [self.keys addObject:[MTgONmMyMass getMyType]];
    [self.carts setValue:[[MTgOFFmMyMass alloc] init] forKey: [MTgOFFmMyMass getMyType]];
    [self.keys addObject:[MTgOFFmMyMass getMyType]];
    
    
    [self.carts setValue:[[MTgONGDIR alloc] init] forKey: [MTgONGDIR getMyType]];
    [self.keys addObject:[MTgONGDIR getMyType]];
    
    [self.carts setValue:[[MTgOFFGDIR alloc] init] forKey: [MTgOFFGDIR getMyType]];
    [self.keys addObject:[MTgOFFGDIR getMyType]];
    
    
    
    [self.carts setValue:[[MTgONkg alloc] init] forKey: [MTgONkg getMyType]];
    [self.keys addObject:[MTgONkg getMyType]];
    [self.carts setValue:[[MTgOFFkg alloc] init] forKey: [MTgOFFkg getMyType]];
    [self.keys addObject:[MTgOFFkg getMyType]];
    
    [self.carts setValue:[[MTResizeDownCart alloc] init] forKey: [MTResizeDownCart getMyType]];
    [self.keys addObject:[MTResizeDownCart getMyType]];
    
    [self.carts setValue:[[MTResizeUpCart alloc] init] forKey: [MTResizeUpCart getMyType]];
    [self.keys addObject:[MTResizeUpCart getMyType]];
    
    [self.carts setValue:[[MTSwitchCostumeCart alloc] init] forKey: [MTSwitchCostumeCart getMyType]];
    [self.keys addObject:[MTSwitchCostumeCart getMyType]];
    
    [self.carts setValue:[[MTSwitchCostumeColorCart alloc] init] forKey: [MTSwitchCostumeColorCart getMyType]];
    [self.keys addObject:[MTSwitchCostumeColorCart getMyType]];
    
    [self.carts setValue:[[MTReAlphaCart alloc] init] forKey: [MTReAlphaCart getMyType]];
    [self.keys addObject:[MTReAlphaCart getMyType]];
    
    
    
    [self.carts setValue:[[MTJointMeCart alloc] init] forKey: [MTJointMeCart getMyType]];
    [self.keys addObject:[MTJointMeCart getMyType]];
    
    [self.carts setValue:[[MTDisJointMeCart alloc] init] forKey: [MTDisJointMeCart getMyType]];
    [self.keys addObject:[MTDisJointMeCart getMyType]];
    
    [self.carts setValue:[[MTFullJointMeCart alloc] init] forKey: [MTFullJointMeCart getMyType]];
    [self.keys addObject:[MTFullJointMeCart getMyType]];
    
    [self.carts setValue:[[MTDisFullJointMeCart alloc] init] forKey: [MTDisFullJointMeCart getMyType]];
    [self.keys addObject:[MTDisFullJointMeCart getMyType]];
    
    
    
    /*** Logika ***/
    
    [self.carts setValue:[[MTGlobalVarPlusVariableCart alloc] init] forKey: [MTGlobalVarPlusVariableCart getMyType]];
    [self.keys addObject:[MTGlobalVarPlusVariableCart getMyType]];
    [self.carts setValue:[[MTGlobalVarMinusVariable alloc] init] forKey: [MTGlobalVarMinusVariable getMyType]];
    [self.keys addObject:[MTGlobalVarMinusVariable getMyType]];
    [self.carts setValue:[[MTGlobalVarMultiplyThrowVariable alloc] init] forKey: [MTGlobalVarMultiplyThrowVariable getMyType]];
    [self.keys addObject:[MTGlobalVarMultiplyThrowVariable getMyType]];
    [self.carts setValue:[[MTGlobalVarDivideThrowVariable alloc] init] forKey: [MTGlobalVarDivideThrowVariable getMyType]];
    [self.keys addObject:[MTGlobalVarDivideThrowVariable getMyType]];
    [self.carts setValue:[[MTGlobalVarEqualVariable alloc] init] forKey: [MTGlobalVarEqualVariable getMyType]];
    [self.keys addObject:[MTGlobalVarEqualVariable getMyType]];
    
    return self;
}

-(MTCart *) getCartOfType:(NSString *)key
{
    return (MTCart *) self.carts[key];
}

@end
