//
//  MTExecutionData.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 09.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//
#import "MTGUI.h"
#import "MTExecutionData.h"
#import "MTCart.h"


@implementation MTExecutionData

-(id)initWithGhostRep:(MTGhostRepresentationNode *) ghostRepresentationNode TrainsArray:(NSMutableArray *) trains
{
    [self setGhostRepNode:ghostRepresentationNode];
    self.trains = [[NSMutableArray alloc]init];
    for (MTTrain *train in trains)
    {
        if ((train.tabNr < CLONE_TAB && ![ghostRepresentationNode userClone]) ||
            (train.tabNr >= CLONE_TAB && [ghostRepresentationNode userClone]))
            if ([[[train getFirstCart] getMyType] isEqualToString: @"MTStartLocomotive"])
            {
                [self.trains addObject:train];
            }
    }
    
    //dodac wskaznik w rep duszka na ten obiekt
    ghostRepresentationNode.executionData = self;
    
    [ghostRepresentationNode.myFlags prepareFlags];
    
    return self;
}

/**
 *  Metoda dodająca licznik rozkazów do reprezentacji duszka
 *  @params counter tablica typu NSNumber zawierająca liczby naturalne
 *  @params train wskaznik na MTTrain powiązany z danym licznikiem
 */
/*
-(void)addCommandsCounter:(NSMutableArray *)counter Train:(MTTrain *) train
{
    NSDictionary *dict = [[NSDictionary alloc]initWithObjects:
                          [NSMutableArray arrayWithObjects:counter,train,nil]
                                                      forKeys:
                          [NSMutableArray arrayWithObjects:@"Counter",@"Train",nil]];
    [self.tra addObject:dict];
}
*/
/**
 *  Metoda zwracająca licznik wykożystywana w MTExecutorze w metodzie
 *  wywołującej kod użytkownika
 *  @params index nr pociągu
 *  @return Tablica typu NSNumber zawierająca liczby Naturalne
 *//*
-(NSMutableArray*)getCommandsCounterAt:(NSUInteger) index
{
    NSMutableArray* val = [self.commandsCounters[index] valueForKey:@"Counter"];
    if (!val)
        ////NSLog(@"blad odczytu klucza \"Counter\" z commandsCounters");
    return val;
}*/

/**
 *  Metoda zerująca licznik na podanym indeksie
 *  @params index nr pociągu
 *//*
-(void)resetCommandsCounterAt:(NSUInteger) index
{
    NSMutableArray* arrayWithZero = [[NSMutableArray alloc] init];
    [arrayWithZero addObject:[NSNumber numberWithUnsignedInt:0]];
    [self.commandsCounters[index] setValue: arrayWithZero forKey:@"Counter"];
}*/

/**
 *  Metoda ustawiająca licznik na podanym indeksie
 *  @params index nr pociągu
 *  @params array tablica typu NSNumber zawierająca liczby naturalne
 *//*
-(void)setCommandsCounterAt:(NSUInteger) index WithCounter:(NSMutableArray*) array
{
    [self.commandsCounters[index] setValue: array forKey:@"Train"];
}*/

/**
 *  Metoda, zwracająca wskaźnik na pociąg, wykorzystywana w MTExecutorze w metodzie
 *  wywołującej kod użytkownika
 *  @params index nr pociągu
 *  @return wskaźnik na pociąg powiązany z licznikiem o tym samym indeksie
 *//*
- (MTTrain *) getCommandsCounterTrainAt:(NSUInteger) index
{
    MTTrain* val = [self.commandsCounters[index] valueForKey:@"Train"];
    if (!val)
        ////NSLog(@"blad odczytu klucza \"Train\" z commandsCounters");
    return val;
}*/

@end
