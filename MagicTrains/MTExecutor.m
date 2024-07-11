//
//  MTExecutor.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 09.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTExecutor.h"
#import "MTExecutionData.h"
#import "MTGhostRepresentationNode.h"
#import "MTSceneAreaNode.h"
#import "MTViewController.h"
#import "MTMainScene.h"
#import "MTStorage.h"
#import "MTGhostsBarNode.h"
#import "MTHelpView.h"
#import "MTLeftArrowLocomotiv.h"
#import "MTRightArrowLocomotiv.h"
#import "MTUpArrowLocomotiv.h"
#import "MTDownArrowLocomotiv.h"
#import "MTAButtonLocomotiv.h"
#import "MTBButtonLocomotiv.h"
#import "MTJoystickDropLocomotiv.h"
#import "MTGyroscopeLeftLocomotiv.h"
#import "MTGyroscopeRightLocomotiv.h"
#import "MTGhost.h"
#import "MTTrain.h"
#import "MTStorage.h"
#import "MTGUI.h"
#import "MTLocomotive.h"
#import "MTGlobalVar.h"
#import "MTCart.h"
#import "MTGhostRepresentationEventFlags.h"
#import "MTAButtonLocomotiv.h"
#import "MTNotificationNames.h"
#import "MTCollisionWithAnotherGhostLocomotiv.h"
#import "MTAudioPlayer.h"

#import "MTCollisionWithRightWallLocomotiv.h"
#import "MTCollisionWithLeftWallLocomotiv.h"
#import "MTCollisionWithTopWallLocomotiv.h"
#import "MTCollisionWithBottomWallLocomotiv.h"
#import "MTHPLocomotiv.h"
#import "MTGhostMenuView.h"
#import "MTSpriteNodeStopSimulation.h"

@interface MTExecutor ()

/// Tablica typu MTExecutionData
/// Liczniki rozkazów dla każdej reprezentacji klucz @"counters" oraz reprezentacja klucz @"ghostRepresentation"
@property NSMutableArray* executionData;
@property NSMutableArray* cloneExecutionData;

@end

@implementation MTExecutor
@synthesize useCM;

static MTExecutor * myInstanceEXE;

+(void)clear
{
    myInstanceEXE = nil;
}

+(MTExecutor *) getInstance
{
    if (myInstanceEXE == NULL)
    {
        myInstanceEXE = [[MTExecutor alloc]init];
    }
    return myInstanceEXE;
}
-(void) executeCode
{
    
    if (!self.simulationStarted)
    {
        
#if DEBUG_NSLog
        ////NSLog(@"exec ");
#endif
        
        [self startSimulation];
    }
    else
    {
        [self stopSimulation];
        
#if DEBUG_NSLog
        ////NSLog(@"quit ");
#endif
        
    }
}


/*
 *  z uwagi na wywolanie [self prepareMeBeforSimulation] 
 *  musi byc wywolywana po kompilacji kodu
 */
-(void) prepareExecutionData
{
    MTSceneAreaNode * scene = (MTSceneAreaNode *)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
    
    self.GhostRepNodes = [scene getAllGhostRepresentationNodes];
    //////NSLog(@"Przygotowuje dane wykonania");
    /// pętla ktora dla kazdej reprezentacji tworzy zestaw pociagow do wykonania
    for (MTGhostRepresentationNode *GRN in self.GhostRepNodes)
    {
        [GRN prepareMeBeforSimulation];
        [self prepareExecutionDataForGhostRepNode:GRN];
    }
}
-(void) prepareExecutionDataForGhostRepNode:(MTGhostRepresentationNode*) GRN
{
    MTGhost *G = GRN.myGhostIcon.myGhost;
    [GRN goIntoStateOfSimulation];
    [GRN prepareMeBeforSimulation];
    
    if (G && G.trains.count > 0)
    {
        MTExecutionData* ED = [[MTExecutionData alloc] initWithGhostRep:GRN TrainsArray:G.trains];
        for (MTTrain* train in G.trains)
        {
            [GRN setVariable:[[NSNumber alloc]initWithInteger:0] WithName:@"main" ForCartNo:-1 TrainNo:[train myNumber]];
        }
        [self.executionData addObject: ED];
    }
}

-(void) prepareExecutionDataForClone:(MTGhostRepresentationNode*) GRN
{
    MTGhost *G = GRN.myGhostIcon.myGhost;
    [GRN goIntoStateOfSimulation];
    
    if (G && G.trains.count > 0)
    {
        MTExecutionData* CED = [[MTExecutionData alloc] initWithGhostRep:GRN TrainsArray:G.trains];
        for (MTTrain* train in G.trains)
        {
            [GRN setVariable:[[NSNumber alloc]initWithInteger:0] WithName:@"main" ForCartNo:-1 TrainNo:[train myNumber]];
        }
        [self.cloneExecutionData addObject: CED];
    }
}

-(void) prepareCode
{
    MTStorage* storage = [MTStorage getInstance];
    //pętla kompilujaca WSZYSTKIE pociągi przed symulacja
    for (int i = 0; i< MAX_GHOST_COUNT; i++)
    {
        MTGhost *ghost = [storage getGhostAt:i];
        for (MTTrain* train in ghost.trains)
        {
            [train prepareMeBeforeSimulation];
        }
    }
}

/**
 * Przygotowywanie tablic zawierajacych pociagi zderzenia z innym duszkiem, dla klonow uzytkownika i zwyklych duszkow
 * -> wywolywane przy starcie symulacji
 */
-(void) prepareCollisionData
{
    NSMutableArray* trainsForCollision;
    NSMutableArray* trainsForCloneCollision;
    
    MTStorage* storage = [MTStorage getInstance];
    //pętla kompilujaca WSZYSTKIE pociągi przed symulacja
    for (int i = 0; i< MAX_GHOST_COUNT; i++)
    {
        MTGhost *mainGhost = [storage getGhostAt:i];
        //inicjalizacja jego tablicy
        mainGhost.trainsForCollision = [[NSMutableArray alloc] init];
        mainGhost.trainsForCloneCollision = [[NSMutableArray alloc] init];
        
        //przejde po wszytskich duszkach
        for (int j = 0; j< MAX_GHOST_COUNT; j++)
        {
            trainsForCollision = [[NSMutableArray alloc] init];
            trainsForCloneCollision = [[NSMutableArray alloc] init];
            
            MTGhost *collisionGhost = [storage getGhostAt:j];
            
            for (MTTrain* train in mainGhost.trains)
            {
                if ([[train getFirstCart] isKindOfClass:[MTCollisionWithAnotherGhostLocomotiv class]])
                {
                    //czy ten pociag dotyczy kolizji z aktualnie analizowanym duszkiem
                    MTCollisionWithAnotherGhostLocomotiv *locomotive = (MTCollisionWithAnotherGhostLocomotiv *)[train getFirstCart];
                    if(locomotive.selectedGhost == collisionGhost)
                    {
                        //teraz dodam do odpowiedniej tablicy
                        //zwykle duszki
                        if (train.tabNr < CLONE_TAB)
                        {
                            [trainsForCollision addObject: train];
                        }
                        else //klony
                        {
                            [trainsForCloneCollision addObject: train];
                        }
                    }
                }
            }
            
            //dodanie pociagow dla aktualnego duszka
            [mainGhost.trainsForCollision addObject: trainsForCollision];
            [mainGhost.trainsForCloneCollision addObject: trainsForCloneCollision];
        }
    }
}

/**
 * Przygotowywanie tablic zawierajacych pociagi zderzenia ze scianami dla duszkow i klonow uzytkownika
 * -> wywolywane przy starcie symulacji
 */
-(void) prepareWallCollisionData
{
    NSMutableArray* trainsForRightWallCollision;
    NSMutableArray* trainsForLeftWallCollision;
    NSMutableArray* trainsForTopWallCollision;
    NSMutableArray* trainsForBottomWallCollision;
    
    NSMutableArray* trainsForCloneRightWallCollision;
    NSMutableArray* trainsForCloneLeftWallCollision;
    NSMutableArray* trainsForCloneTopWallCollision;
    NSMutableArray* trainsForCloneBottomWallCollision;
    
    MTStorage* storage = [MTStorage getInstance];
    //przechodze po wszytskich duszkach
    for (int i = 0; i< MAX_GHOST_COUNT; i++)
    {
        MTGhost *mainGhost = [storage getGhostAt:i];
        //inicjalizacja jego tablicy
        mainGhost.trainsForWallCollision = [[NSMutableArray alloc] init];
        mainGhost.trainsForCloneWallCollision = [[NSMutableArray alloc] init];
        

        trainsForRightWallCollision = [[NSMutableArray alloc] init];
        trainsForLeftWallCollision = [[NSMutableArray alloc] init];
        trainsForTopWallCollision = [[NSMutableArray alloc] init];
        trainsForBottomWallCollision = [[NSMutableArray alloc] init];
        trainsForCloneRightWallCollision = [[NSMutableArray alloc] init];
        trainsForCloneLeftWallCollision = [[NSMutableArray alloc] init];
        trainsForCloneTopWallCollision = [[NSMutableArray alloc] init];
        trainsForCloneBottomWallCollision = [[NSMutableArray alloc] init];
        
        for (MTTrain* train in mainGhost.trains)
        {
            MTCart * firstCart = [train getFirstCart];
            
            if ([firstCart isKindOfClass:[MTCollisionWithRightWallLocomotiv class]])
            {
                if (train.tabNr < CLONE_TAB) //zwykle duszki
                {
                    [trainsForRightWallCollision addObject: train];
                }
                else //klony
                {
                    [trainsForCloneRightWallCollision addObject: train];
                }
            }
            else if ([firstCart isKindOfClass:[MTCollisionWithLeftWallLocomotiv class]])
            {
                if (train.tabNr < CLONE_TAB) //zwykle duszki
                {
                    [trainsForLeftWallCollision addObject: train];
                }
                else //klony
                {
                    [trainsForCloneLeftWallCollision addObject: train];
                }

            }
            else if ([firstCart isKindOfClass:[MTCollisionWithTopWallLocomotiv class]])
            {
                if (train.tabNr < CLONE_TAB) //zwykle duszki
                {
                    [trainsForTopWallCollision addObject: train];
                }
                else //klony
                {
                    [trainsForCloneTopWallCollision addObject: train];
                }

            }
            else if ([firstCart isKindOfClass:[MTCollisionWithBottomWallLocomotiv class]])
            {
                if (train.tabNr < CLONE_TAB) //zwykle duszki
                {
                    [trainsForBottomWallCollision addObject: train];
                }
                else //klony
                {
                    [trainsForCloneBottomWallCollision addObject: train];
                }

            }
        }
        
        //dodanie pociagow dla aktualnego duszka
        [mainGhost.trainsForWallCollision addObject: trainsForLeftWallCollision];
        [mainGhost.trainsForWallCollision addObject: trainsForTopWallCollision];
        [mainGhost.trainsForWallCollision addObject: trainsForRightWallCollision];
        [mainGhost.trainsForWallCollision addObject: trainsForBottomWallCollision];
        [mainGhost.trainsForCloneWallCollision addObject: trainsForCloneLeftWallCollision];
        [mainGhost.trainsForCloneWallCollision addObject: trainsForCloneTopWallCollision];
        [mainGhost.trainsForCloneWallCollision addObject: trainsForCloneRightWallCollision];
        [mainGhost.trainsForCloneWallCollision addObject: trainsForCloneBottomWallCollision];
    }
}

-(void) remove{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    myInstanceEXE=nil;
}

-(void) startSimulation
{
       //[[MTAudioPlayer instanceMTAudioPlayer] playBackground];
    //[[MTAudioPlayer instanceMTAudioPlayer] stopCodeBackground];
    //[[MTAudioPlayer instanceMTAudioPlayer] fadeOutBeat];
    
    
    [MTHelpView setHelpAllowed:NO];
    for(UIView * u in [MTViewController getInstance].view.superview.subviews){
        if ([u isKindOfClass:[MTGhostMenuView class]]){
            [(MTGhostMenuView*)u removeFromParent];
        }
    }
    [[MTAudioPlayer instanceMTAudioPlayer] play:@"background_simulation"];
    
    if (!self.simulationStarted)
    {
        
        MTSceneAreaNode * scene = (MTSceneAreaNode *)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
        
        if(HEIGHT==1024){//ipad pro
            
            MTSpriteNodeStopSimulation * snsss = (MTSpriteNodeStopSimulation *)[[[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"] childNodeWithName:@"MTSpriteNodeLeft" ]childNodeWithName:@"MTSpriteNodeStopSimulation"];
            
            [snsss runAction:[SKAction group:@[
                                               [SKAction fadeAlphaTo:1.0 duration:0.3],
                                               [SKAction moveByX:30 y:0 duration:0.3]
                                               ]]];
            
        }

        
        if(HEIGHT==768){//ipad
            
            MTSpriteNodeStopSimulation * snsss = (MTSpriteNodeStopSimulation *)[[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"] childNodeWithName:@"MTSpriteNodeStopSimulation"];
            
            [snsss runAction:[SKAction group:@[
                                               [SKAction fadeAlphaTo:1.0 duration:0.3],
                                               [SKAction moveByX:30 y:0 duration:0.3]
                                               ]]];
            
        }

        //Jesli tryb debugowania nie jest wlaczony odznacz aktualnego duszka
        if(![MTStorage getInstance].DebugEnabled )
            [[MTGhostRepresentationNode getSelectedRepresentationNode] makeMeUnselected];
        
        //zerowanie zmiennych globalnych
        MTGlobalVar *globalVar = [MTGlobalVar getInstance];
        [globalVar setVariableTo0];
        
        //zerowanie zmiennych lokalnych
        self.variablesArray = [[NSMutableArray alloc] init];
        
        // self.lock = [[NSLock alloc] init];
        // [MTActionManagement getInstance].allActions = [[NSMutableArray alloc] init];
        self.simulationStarted = true;
        MTGhostsBarNode * gbr = (id) ([[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTGhostsBarNode"]);
        [gbr.ribbon orangify];
        
        //Dodanie do listy oczekujacych na powiadomienie
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(stopSimulation) name:@"MTGhostsBarNode Shown" object:gbr];
        
        self.UserCloneNodes = [[NSMutableArray alloc] init]; //Inicjalizacja tablicy z klonami stworzonymi przez uzytkownika
        
        /// schowanie paska duszkow
        [gbr hideBar];
        
        self.executionData = [[NSMutableArray alloc] init];
        
        [self prepareCode];
        [self prepareExecutionData];
        
        //przygotowanie tablic zawierajacych pociagi kolizji z innym duszkiem
        [self prepareCollisionData];
        //przygotowanie tablic zawierajacych pociagi  zderzenia ze sciana
        [self prepareWallCollisionData];
        
        /// wywolanie kodu uzytkownika w tle
       // [self performSelectorInBackground:@selector( DoRunTrainsWithGhostRepNodes:) withObject:self.GhostRepNodes];
        
        
        //Uruchomienie aktualizacji pozycji zyroskopu
        [[MTViewController getInstance] startGyroUpdateWithDurationPerSecound:30];
        
        ///Timer wywołujący sprawdzenie czy kod uzytkokwnika dla zyroskopu ma zostac wykonany
        /*self.gyroTimer = [NSTimer scheduledTimerWithTimeInterval:0.50
                                                        target:self
                                                        selector:@selector(checkGyro)
                                                        userInfo:nil
                                                        repeats:YES];*/
        
        
        // TODO przenieść do MTSceneAreaNode
            
        /// dodanie joysticka do sceny
        if ([MTStorage getInstance].JoystickEnabled == true)
            [(MTSceneAreaNode*)scene addJoystick];

        //Zamontowanie trybu debugowania
        if ([MTStorage getInstance].DebugEnabled == true)
            [scene addDebugAddons];
        else
            scene.debugElements = [[NSMutableArray alloc] init];
    }
}

-(void) addRecentEventTrainsToExecutionData:(MTExecutionData *)ED
{
    MTGhostRepresentationNode *GRN = ED.ghostRepNode;
    NSMutableArray *trains = GRN.myGhostIcon.myGhost.trains;
    
    /// petla przechodzaca po duszkach sprawdzająca kolejne
    /// pociagi reagujące na zdarzenia
    /// w celu dodania ich do ED.trains

    for (int j = 0; j < trains.count; j++)
    {
        // jezeli pociag jest z odpowiedniej karty i jest lub nie jest klonem
        if (([(MTTrain*)trains[j] getTabNumber]>2 && GRN.userClone) || ([(MTTrain*)trains[j] getTabNumber]<3 && !GRN.userClone))
        {
            // sprawdzam typ pociagu
            NSString *cartType = [[trains[j] getFirstCart] getMyType];
            
            if ([GRN.myFlags getAButtonFlag] && [cartType isEqualToString:@"MTAButtonLocomotiv"])
            {
                [ED.trains addObject:trains[j]];
                [GRN.myFlags unSetAButtonFlag];
            }
            else if ([GRN.myFlags getBButtonFlag] && [cartType isEqualToString:@"MTBButtonLocomotiv"])
            {
                [ED.trains addObject:trains[j]];
                [GRN.myFlags unSetBButtonFlag];
            }
            else if ( [GRN.myFlags getRightArrowFlag] && [cartType isEqualToString:@"MTRightArrowLocomotiv"])
            {
                [ED.trains addObject:trains[j]];
                [GRN.myFlags unSetRightArrowFlag];
            }
            else if ([GRN.myFlags getLeftArrowFlag] && [cartType isEqualToString:@"MTLeftArrowLocomotiv"])
            {
                [ED.trains addObject:trains[j]];
                [GRN.myFlags unSetLeftArrowFlag];
            }
            else if ([GRN.myFlags getUpArrowFlag] && [cartType isEqualToString:@"MTUpArrowLocomotiv"])
            {
                [ED.trains addObject:trains[j]];
                [GRN.myFlags unSetUpArrowFlag];
            }
            else if ([GRN.myFlags getDownArrowFlag] && [cartType isEqualToString:@"MTDownArrowLocomotiv"])
            {
                [ED.trains addObject:trains[j]];
                [GRN.myFlags unSetDownArrowFlag];
            }
            else if ([GRN.myFlags getJoystickDropFlag] && [cartType isEqualToString:@"MTJoystickDropLocomotiv"])
            {
                //MTJoystickDropLocomotiv* m  = (MTJoystickDropLocomotiv*)[trains[j] getFirstCart];
                //[m setForce:[GRN.myFlags getJoystickDropForce]];
                [ED.trains addObject:trains[j]];
                [GRN.myFlags unSetJoystickDropFlag];
            }
            else if ([GRN.myFlags getPurpleSignalFlag]>0 && [cartType isEqualToString:@"MTRecieveSignalLocomotiv"])
            {
                [ED.trains addObject:trains[j]];
                [GRN.myFlags unSetPurpleSignalFlag];
            }
            else if ([GRN.myFlags getOrangeSignalFlag]>0 && [cartType isEqualToString:@"MTRecieveOrangeSignalLocomotiv"])
            {
                [ED.trains addObject:trains[j]];
                [GRN.myFlags unSetOrangeSignalFlag];
            }
            else if ([GRN.myFlags getBlueSignalFlag]>0 && [cartType isEqualToString:@"MTRecieveBlueSignalLocomotiv"])
            {
                [ED.trains addObject:trains[j]];
                [GRN.myFlags unSetBlueSignalFlag];
            }
            else if ([GRN.myFlags getRightGyroscopeFlag] && [cartType isEqualToString:@"MTGyroscopeRightLocomotiv"])
            {
                [ED.trains addObject:trains[j]];
                [GRN.myFlags unSetRightGyroscopeFlag];
            }
            else if ([GRN.myFlags getLeftGyroscopeFlag] && [cartType isEqualToString:@"MTGyroscopeLeftLocomotiv"])
            {
                [ED.trains addObject:trains[j]];
                [GRN.myFlags unSetLeftGyroscopeFlag];
            }
            else if ([GRN.myFlags getHPFlag] && [cartType isEqualToString:@"MTHPLocomotiv"])
            {
                [ED.trains addObject:trains[j]];
                [GRN.myFlags unSetHPFlag];
            }
        }
    }
}

-(void) processExecutionData:(MTExecutionData *) ED
{
    [self addRecentEventTrainsToExecutionData:ED];
    
    /// Pętla przechodząca po pociągach przypisanych do wybranej reprezentacji duszka
    for (NSInteger i = ED.trains.count -1 ; i >= 0; i--)
    {
        /// jezeli kod w pociagu zostanie wykonany to pociag zostaje usuniety z listy
        if ([(MTTrain *)ED.trains[i] runMeWithGhostRepNode: ED.ghostRepNode])
        {
            [ED.trains removeObjectAtIndex:i];
        }
    }
}

/*
 *  Główna 
 */
-(void) processFrameOfSimulationWithTime: (CFTimeInterval) timeSinceLastUpdate
{
    FRAME_TIME=timeSinceLastUpdate;
    ////NSLog(@"Time since last update: %f",timeSinceLastUpdate );
    [self checkGyroscope];
    
    
    
    for (long int i = self.executionData.count - 1 ; i>=0 ;i-- ) {
        MTExecutionData *ED = self.executionData[i];
        [self processExecutionData: ED];
    }
    for (long int i = self.cloneExecutionData.count - 1; i>=0; i--)
    {
        MTExecutionData *CED = self.cloneExecutionData[i];
        [self processExecutionData: CED];
    }
}
/**
 *  Główna procedura zakończenia stanu symulacji.
 */
-(void) stopSimulation
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DrawingEnded" object:self];
    
    [MTHelpView revertHelpAllowed];
    MTGhostsBarNode * gbr = (id) ([[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTGhostsBarNode"]);
    [[MTGhostIconNode getSelectedIconNode] makeMeSelectedE];
    
    [gbr.ribbon redify];
    if(HEIGHT==768){//ipad
        
        MTSpriteNodeStopSimulation * snsss = (MTSpriteNodeStopSimulation *)[[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"] childNodeWithName:@"MTSpriteNodeStopSimulation"];
        
        [snsss runAction:[SKAction group:@[
                                           [SKAction fadeAlphaTo:0.0 duration:0.3],
                                           [SKAction moveByX:-30 y:0 duration:0.3]
                                           ]]];
        
    }

    
    if(HEIGHT==1024){//ipad pro
        
        MTSpriteNodeStopSimulation * snsss = (MTSpriteNodeStopSimulation *)[[[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"] childNodeWithName:@"MTSpriteNodeLeft" ]childNodeWithName:@"MTSpriteNodeStopSimulation"];
        
        [snsss runAction:[SKAction group:@[
                                           [SKAction fadeAlphaTo:0.0 duration:0.3],
                                           [SKAction moveByX:-30 y:0 duration:0.3]
                                           ]]];
        
    }
    
    //[[MTAudioPlayer instanceMTAudioPlayer] stopBackground];
    //[[MTAudioPlayer instanceMTAudioPlayer] playCodeBackground];
    
    //wyłączanie grawitacji
    SKNode * scene2 = [[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
    scene2.scene.physicsWorld.gravity=CGVectorMake(0, 0);
    
    SKFieldNode * skf = [MTViewController getInstance].skf;
    skf.direction = vector_float(vector3(0, 0, 0));
    


    
    
    //Wskaznik na MTSceneAreaNode
    MTSceneAreaNode * scene = (MTSceneAreaNode*) [[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
    
    if(![MTStorage getInstance].DebugEnabled )
        [[MTGhostRepresentationNode getSelectedRepresentationNode] makeMeUnselected];
    
    //usunięcie wszystkich klonów stworzonych podczas symulacji
    // (dalej zwanych klonami uzytkownika)
    [self removeUserClones];
    
    if (self.simulationStarted)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:@"MTGhostsBarNode Shown"
                                                      object:nil];
        
        //petla wylaczająca stan symulacji dla reprezentacji duszkow
        for (MTGhostRepresentationNode* ghostRepNode in self.GhostRepNodes)
        {
            
            @try{
            if (ghostRepNode.parent == nil)
               [scene addChild:ghostRepNode];
                
            if (ghostRepNode.myFlags.observersExists == false)
                [ghostRepNode.myFlags addObserversWithGRN:ghostRepNode];
            
            [ghostRepNode resetMe];
            [ghostRepNode goIntoStateOfEditing];
            }@catch(NSException *e){
                ////NSLog(@"%@",e);
            }
        }
        
        self.simulationStarted = false;
        
        /// zatrzymanie timera
        [self.gyroTimer invalidate];
    }
    // ewentualne wylaczenie joysticka
    if ([MTStorage getInstance].JoystickEnabled == true)
        [scene removeJoystick];
    
    /*Wylaczenie trybu debugowania - zmienne na ekranie*/
        [scene removeDebugAddons];
    
    //Zatrzymanie aktualizacji zyroskopu
    [[MTViewController getInstance] stopGyroUpdate];
    
    // uruchomienie animacji zaznaczenia ikonki duszka
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MTGhostIconNode RunAnimation" object: self];
}
/**
 *
 * Usuwa klony uzytkownika po wyjściu ze stanu symulacji (w wywołaniu stopSimulation) tej samej klasy.
 * Metoda jest działającą próba zapanowana nad klonami użytkownika po wyjściu ze stanu symulacji.
 *
 */
-(void) removeUserClones
{
    for (MTGhostRepresentationNode* clone in self.UserCloneNodes)
    {
        //usuniecie notyfikacji
        [clone.myFlags removeNotifications];
        //usuniecie execution data
        [self removeTrainsForClone:clone];
        
        [[NSNotificationCenter defaultCenter] removeObserver:clone];
        [clone removeFromParent];
    }
    
    self.UserCloneNodes = [[NSMutableArray alloc] init];
}

/**
 * Usuwanie execution data klona uzytkownika, podczas usuwania go ze sceny
 * usuwam je z tablicy self.cloneExecutionData
 */
-(void) removeTrainsForClone: (MTGhostRepresentationNode*) clone
{
    //przechodze po tablicy execution data i usuwam ta ktora go dotyczy
    for (NSInteger i = self.cloneExecutionData.count-1; i>=0; i--)
    {
        if (clone.executionData == self.cloneExecutionData[i])
        {
            [self.cloneExecutionData removeObjectAtIndex:i];
        }
    }
    
}

/**
 * Zmiana stanu na StateOfConstant dla wszystkich duszkow i klonow.
 */
-(void) changeStateForAllGhosts
{
     //MTSceneAreaNode * scene = (MTSceneAreaNode*) [[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
    
    //[self stopSimulation];
    
    for (MTGhostRepresentationNode* rep in self.GhostRepNodes)
    {
        rep.moveXInSimulation = false;
        rep.moveYInSimulation = false;
        [rep goIntoStateOfConstant];
    }
    
    for (MTGhostRepresentationNode* rep in self.UserCloneNodes)
    {
        rep.moveXInSimulation = false;
        rep.moveYInSimulation = false;
        [rep goIntoStateOfConstant];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goIntoStateOfEditingForAllGhost) name:@"MTGhostsBarNode Shown" object:nil];
}

/*
 * Zmiana stanu wszystkich duszków na stan edycji
 */
-(void) goIntoStateOfEditingForAllGhost
{
    for (MTGhostRepresentationNode* rep in self.GhostRepNodes)
    {
        [rep resetMe];
        [rep goIntoStateOfEditing];
    }
    
    for (MTGhostRepresentationNode* rep in self.UserCloneNodes)
    {
        [rep resetMe];
        [rep goIntoStateOfEditing];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MTGhostsBarNode Shown" object:nil];
}

/**
 * Przetworzenie danych z działającego żyroskopu.
 */
-(void) checkGyroscope
{
    float gyro = [MTViewController getInstance].gyroRotation;
    
    if(gyro < -20)
    {
        
        
#if DEBUG_NSLog
        ////NSLog(@"wysylam w lewo");
#endif
        //wyslac notyfikacje ze zyroskop ruszyl sie w lewo
        [[NSNotificationCenter defaultCenter] postNotificationName: N_Gyroscope_Left_Signal object:self];
    }
    else if(gyro > 20)
    {
        

#if DEBUG_NSLog
        ////NSLog(@"wysylam w prawo");
#endif
        //wyslac notyfikacje ze zyroskop ruszyl sie w prawo
        [[NSNotificationCenter defaultCenter] postNotificationName: N_Gyroscope_Right_Signal object:self];
    }
    else
    {
            //ewentualnie dodac zatrzymywanie wykonania pociagu ktory juz sie wykonuje po ruszeniu iPadem
    }
}

@end
