
//
//  MTGhostFactory.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.02.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTGhost.h"
#import "MTGhostInstance.h"
#import "MTStorage.h"
#import "MTExecutor.h"
#import "MTTrain.h"

#import "MTRecieveBlueSignalLocomotiv.h"
#import "MTRecieveOrangeSignalLocomotiv.h"
#import "MTRecieveSignalLocomotiv.h"

#import "MTLocomotive.h"
#import "MTGhostRepresentationNode.h"
#import "MTGUI.h"

@implementation MTGhost
@synthesize initlalMass,allowedTouching,allowedClonning,allowedOptions,allowedCoding;
@synthesize hp;

-(id) CreateNewGhostInstance
{
    id val = [[MTGhostInstance alloc] initWithNr: self.myNumber ];
    [self.ghostInstances addObject: val];
    return val;
}

-(int)mass{
    return initlalMass;
}
-(void)setMass:(int)m{
    self.initlalMass=m;
}

-(CGFloat)getScaledMass{
    return pow(2,self.mass);
}

-(id)init
{
    self = [super init];
    self.trains = [[NSMutableArray alloc] init];
    self.ghostInstances = [[NSMutableArray alloc] init];
    self.hpInit = 10;
    self.hp = _hpInit;
    self.allowedCoding = true;
    self.allowedOptions = true;
    self.allowedClonning = true;
    self.allowedTouching = true;
    
    return self;
}

-(int)getIntHP{
    return (int) hp;
}

-(void)setIntHP:(int)newhp{
    self.hpInit=1.0*newhp;
    self.hp = newhp;
}

-( id ) initWithNr: (NSUInteger) n
{
    self = self.init;
    self.myNumber = n;
    //NSDictionary *randomCostumePair = [[NSDictionary alloc] init];
    
    NSMutableArray *randomCostume = [self generateRandomGhostCostume];
    
    while([self checkIfRandomCostumeExist:randomCostume])
    {
        randomCostume = [self generateRandomGhostCostume];
    }
    
    self.costumeCat = randomCostume[0];
    self.costumeName = randomCostume[1];
    
    
    return self;
}


-(bool) getAllowedCoding {
    return allowedCoding;
}
-(bool) getAllowedTouching{
    return allowedTouching;
}
-(bool) getAllowedOptions{
    return allowedOptions;
}
-(bool) getAllowedClonning{
    return allowedClonning;
}
-(void) setAllowedCodingToVal:(bool)val{
    allowedCoding = val;
}
-(void) setAllowedTouchingToVal:(bool)val{
    allowedTouching = val;
}
-(void) setAllowedOptionsToVal:(bool)val{
    allowedOptions = val;
}
-(void) setAllowedColonningToVal:(bool)val{
    allowedClonning = val;
}

-(NSMutableArray *) generateRandomGhostCostume
{
    MTStorage *storage = [MTStorage getInstance];
    long size = storage.ghostCostumes.count-1;
    int randomGhostCat = arc4random() % size;
    int randomGhostVariant = arc4random() % 9;
    self.mass=[[MTStorage getInstance]getGhostDefaults:randomGhostVariant].defaultMass;
    
    NSArray *keys = [storage.ghostCostumes allKeys];
    id aKey = [keys objectAtIndex:randomGhostCat];
    NSArray *ghostCat = [storage.ghostCostumes objectForKey:aKey];
    NSString *ghostVariant = ghostCat[randomGhostVariant];
    
    NSMutableArray *costumeCatAndVariantPair = [[NSMutableArray alloc] init];
    
    [costumeCatAndVariantPair addObject:aKey];
    [costumeCatAndVariantPair addObject:ghostVariant];
    
    return costumeCatAndVariantPair;
}

-(BOOL) checkIfRandomCostumeExist:(NSMutableArray *) costume
{
    MTStorage *storage = [MTStorage getInstance];
    
    for(int i = 0; i < storage.GhostCount; i++)
    {
        MTGhost *ghost = [storage getGhostAt:i];
        NSString *costumeCat = costume[0];
        NSString *costumeVariant = costume[1];
        
        if([ghost.costumeCat isEqual:costumeCat] && [ghost.costumeName isEqual:costumeVariant])
        {
            return true;
        }
    }
    
    return false;
}
-( void ) addTrain: (MTTrain*) newTrain
{
    [ self.trains addObject:newTrain ];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Ghost Changed" object:self];
}

-( MTTrain * ) getTrain: ( uint ) i
{
    return ( MTTrain * ) self.trains[i];
}

-(void) runMyTrainsWithGhostRepNode:(MTGhostRepresentationNode *) gRN// InTime: ];
{
    for (int i = 0; i < self.trains.count ; i ++)
    {
        MTTrain *train = [self getTrain:i];
        
        /*Inicjalizuje watki dla pociagow 'nie dla klonow' - dwa ostatnie taby dla klonow*/
        /*Inicjalizacja watkow dla klonow znajduje sie w wagonie MTCloneMe*/
        /*
        if([train.mainSubTrain.Carts[0] isKindOfClass:[MTLocomotive class]] && (train.tabNr < CLONE_TAB))
        {
            [[[NSThread alloc] initWithTarget: train
                                     selector: @selector(runMeWithGhostRepNode:)
                                       object: gRN ] start];
        }
        */
        if([train.mainSubTrain.Carts[0] isKindOfClass:[MTLocomotive class]] && (train.tabNr < CLONE_TAB))
        {
            [train runMeWithGhostRepNode:gRN];// InTime: ];
        }
    
    }
}

-(void) removeTrain: (MTTrain *) train
{
    [self.trains removeObject: train];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Train Removed" object:train];
}

-(MTGhostInstance *) addNewInstance
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Ghost Changed" object:self];
    return [self CreateNewGhostInstance];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"MTSceneAreaNode updateGhost" object:self];
}

-(void) removeGhostInstance:(MTGhostInstance*)ghost
{
    
    [self.ghostInstances removeObject: ghost];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Ghost Changed" object:self];
}
-(MTGhostInstance *) getGhostInstanceAt:(uint)i
{
    return self.ghostInstances[i];
}

//----------------------------------------------------------------------------\\
// Serializacja                                                               \\
//----------------------------------------------------------------------------\\

- (void) encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeInteger:[self myNumber] forKey:@"myNumber"];
    [encoder encodeObject:[self costumeName] forKey:@"costumeName"];
    [encoder encodeObject:[self costumeCat] forKey:@"costumeCat"];
    [encoder encodeFloat: self.hpInit forKey:@"hpInit"];
    NSLog(@"Saving hp:%f",self.hpInit);
    [encoder encodeInt: self.mass forKey:@"myMass"];
    [encoder encodeBool:self.allowedClonning forKey:@"allowedClonning"];
    [encoder encodeBool:self.allowedOptions forKey:@"allowedOptions"];
    [encoder encodeBool:self.allowedTouching forKey:@"allowedTouching"];
    [encoder encodeBool:self.allowedCoding forKey:@"allowedCoding"];
    
    /*
    [encoder encodeInteger: self.trains.count forKey:@"TrainsCount"];
    for (int i = 0;i<self.trains.count;i++) {
        MTTrain* train = [self getTrain:i];
        [encoder encodeObject:train forKey:[NSString stringWithFormat:@"Train%d",train.myNumber]];
    }*/

    [encoder encodeInteger: self.ghostInstances.count forKey:@"GhostInstancesCount"];
    int i = 0;
    for (MTGhostInstance* ghost in [self ghostInstances]) {
        [encoder encodeObject:ghost forKey:[NSString stringWithFormat:@"GhostInstances%d",i]];
        i++;
    }
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    MTStorage* storage = [MTStorage getInstance];
    
    [self setMyNumber:[decoder decodeIntegerForKey:@"myNumber"]];
    self = [self initWithNr:[self myNumber]];
    
    [self setCostumeName: [decoder decodeObjectForKey:@"costumeName"]];
    [self setCostumeCat: [decoder decodeObjectForKey:@"costumeCat"]];
    [self setAllowedClonning: [decoder decodeBoolForKey:@"allowedClonning"]];
    [self setAllowedOptions: [decoder decodeBoolForKey:@"allowedOptions"]];
    [self setAllowedTouching: [decoder decodeBoolForKey:@"allowedTouching"]];
    [self setAllowedCoding: [decoder decodeBoolForKey:@"allowedCoding"]];
    
    [self setHpInit:[decoder decodeFloatForKey:@"hpInit"]];
    NSLog(@"Reading hp:%f",self.hpInit);
    self.hp = _hpInit ;
    NSLog(@"Setting hp:%f",self.hp);
    self.mass = [decoder decodeIntForKey:@"myMass"];

#if DEBUG_NSLog
    ////NSLog(@"%d: costume is : %@",[self myNumber],[self costumeName]);
    ////NSLog(@"%d: cat is : %@",[self myNumber],[self costumeCat]);
#endif
    
    self.hp = _hpInit ;
    
    [storage setGhost:self At:[self myNumber]];
    
    NSInteger N = [decoder decodeIntegerForKey:@"GhostInstancesCount"];
    for (int i = 0; i < N; i++) {
        [self.ghostInstances addObject:[decoder decodeObjectForKey:[NSString stringWithFormat:@"GhostInstances%d",i]]];
        
    }

    return self;
}

-(NSUInteger) getMyNumber {
    return self.myNumber;
}

@end
