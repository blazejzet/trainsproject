//  MTRemoveMyGhostCart.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.

#import "MTRemoveMyGhostCart.h"
#import "MTGhostRepresentationNode.h"
#import "MTSceneAreaNode.h"
#import "MTGhostIconNode.h"


@implementation MTRemoveMyGhostCart

static NSString* myType = @"MTRemoveMyGhostCart";

- (id) initWithSubTrain: (MTTrain *) t
{
    if(self = [super init])
    {
        self.optionsOpen = true;
        self.isInstantCart = true;
    }
    return self;
}

+(NSString*)DoGetMyType{
    return myType;
}

-(NSString*)getImageName
{
    return @"delMe.png";
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    return [[MTRemoveMyGhostCart alloc] initWithSubTrain:train];
}

-(int)getCategory
{
    return MTCategoryGhost;
}

/**
 * Próba "neutralizacji" duszka, który ma zostać usunięty zgodnie z instrukcją użytkownika
 * Funkcja usuwa rodzica reprezentacji. Zmienia specjalny parametr "czy usunięty". Usuwa wszystkie akcje. Przenosi duszka do stanu edycji i resetuje go.
 * TODO Mateusz: Znaleźć optymalne, najmniej inwazyjne rozwiązania do usuwania duszka ze sceny przez kod użytkownika.
 */
-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode
{
    /*Jesli usuwany duszek jest aktualnie zaznaczony to go odznacz*/
    if([MTGhostRepresentationNode getSelectedRepresentationNode] == ghostRepNode)
        [ghostRepNode makeMeUnselected];
    
    /*Czy duszek został już usuniety?*/
    if(!ghostRepNode.deleted)
    {
        /*Rozroznienie - czy jest klonem uzytkownika*/
        /*Duszki bedace klonami uzytkownika nie zostana juz przywrocone po wylaczeniu symulacji*/
        
        if (ghostRepNode.userClone)
        {
            [ghostRepNode removeFromStage];
        } else {
            [ghostRepNode removeFromStage];

        ghostRepNode.physicsBody.dynamic = NO;
        // [ghostRepNode goIntoStateOfEditing];
        }
    }
    return true;
}

@end
