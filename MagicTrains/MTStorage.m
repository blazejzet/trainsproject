//
//  MTStorage.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.02.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTStorage.h"
#import "MTArchiver.h"
#import "MTGhost.h"
#import "MTViewController.h"
#import "MTGhostRepresentationNode.h"
#import "MTGlobalVar.h"
#import "MTMainScene.h"
#import "MTGhostsBarNode.h"
#import "MTGUI.h"
#import "MTGhostDefaults.h"
#import "MTProjectTypeEnum.h"
#import "MTCodeTabTypeEnum.h"
#import "MTCart.h"
@implementation MTStorage

static MTStorage *myInstanceMTS;

MTGhost* AllGhosts[MAX_GHOST_COUNT];
MTGhostDefaults* GhostDefaults[MAX_GHOST_COUNT];

BOOL JoystickEnabled;
BOOL DebugEnabled;

MTCodeTabTypeEnum CodeTabsTypesCArray[5];
MTProjectTypeEnum ProjectType;

@synthesize usedCartsCounters;
@synthesize maxCartsCounts;

+(void)clear
{
    myInstanceMTS = nil;
}
+(MTStorage *) getInstance
{
    //////NSLog(@"Nastąpił dostęp do MTStorage.");
    return myInstanceMTS;
}

+(MTStorage *) getNewInstance
{
    [[MTStorage alloc]initSingleton];
    NSLog(@"Nastąpiło zresetowanie  MTStorage.");
    return myInstanceMTS;
}

-(NSString*)getGhostsList{
    
    NSString * a = @"";
    //AllGhosts[i];
    for ( int i = 0;i<MAX_GHOST_COUNT;i++){
        MTGhost* g = AllGhosts[i];
        a = [NSString stringWithFormat:@"%@%d:%d,%d,%@,%@\n",a,i,g.getMyNumber,g.getIntHP,g.costumeCat,g.costumeName];
    }
    return a;
}

-(id) initSingleton
{
#if DEBUG_NSLog
    ////NSLog(@"inicjuje MTStorage.");
#endif
    //Inicjowanie tablicy na duszki
    self.GhostCount = 0;
    for (int i=0 ; i<MAX_GHOST_COUNT; i++) {
        AllGhosts[i] = nil;
    }
   
    self.ghostCostumes = [[NSMutableDictionary alloc] init];
    self.ghostDefaults = [[NSMutableDictionary alloc] init];
    self.usedCartsCounters = [[NSMutableDictionary alloc] init];
    self.maxCartsCounts  = [[NSMutableDictionary alloc] init];
    
    self.ProjectType = MTProjectTypeLearn;
    [self addGhostCostumes];
    
    myInstanceMTS = self;
    return self;
}

-(void) initCodeTabsTypes
{
    for (int i=0; i< 5; i++) {
        CodeTabsTypesCArray[i] = MTCodeTabProjectTypeBlocked;
    }
}

-(MTCodeTabTypeEnum) getCodeTabTypeAt:(int) i {
    
    return (MTCodeTabTypeEnum)CodeTabsTypesCArray[i];
}

-(id) initFromArchive
{
    //self = [self initSingleton];
    return myInstanceMTS;
}
-(id) init
{
    return myInstanceMTS;
}


/**
 *
 * Wyszukiwanie wolnych miejsc w tablicy dla duszków
 * @return Jeżeli zwróci -1 to znaczy że nie ma wolnych miejsc w tablicy
 *
 */
-(uint) firstNilInAllGhosts
{
    int i=0;
    while (AllGhosts[i] != nil && i<MAX_GHOST_COUNT)
    {
        i++;
    }
    if (i == MAX_GHOST_COUNT)
        return -1;
    return i;
}

-(id) addGhost
{
    int i = [self firstNilInAllGhosts];
    if (i < 0 || MAX_GHOST_COUNT <= i)
        return nil;
    
    AllGhosts[i] = [[MTGhost alloc] initWithNr:i];
    id val = AllGhosts[i];
    self.GhostCount++;
    return val;
}

-(NSUInteger) getGhostCount{
    return self.ghostCostumes.count;
}

-(MTGhostDefaults*) getGhostDefaults:(int)g{
    return [self.ghostDefaults objectForKey:[NSString stringWithFormat:@"%d",g]];
}


-(BOOL)ghostCostumeIsSimple:(int)drn{
    NSArray * m = [[NSArray alloc]initWithObjects:[[NSNumber alloc]initWithInt:17],[[NSNumber alloc]initWithInt:18],[[NSNumber alloc]initWithInt:19],[[NSNumber alloc]initWithInt:10],[[NSNumber alloc]initWithInt:11],[[NSNumber alloc]initWithInt:12],[[NSNumber alloc]initWithInt:13],[[NSNumber alloc]initWithInt:14],[[NSNumber alloc]initWithInt:15],[[NSNumber alloc]initWithInt:16],[[NSNumber alloc]initWithInt:20],[[NSNumber alloc]initWithInt:21],[[NSNumber alloc]initWithInt:22],[[NSNumber alloc]initWithInt:23],[[NSNumber alloc]initWithInt:24],[[NSNumber alloc]initWithInt:25],[[NSNumber alloc]initWithInt:26],[[NSNumber alloc]initWithInt:27],[[NSNumber alloc]initWithInt:28],[[NSNumber alloc]initWithInt:29],[[NSNumber alloc]initWithInt:30],[[NSNumber alloc]initWithInt:33],[[NSNumber alloc]initWithInt:36],[[NSNumber alloc]initWithInt:37],[[NSNumber alloc]initWithInt:38],[[NSNumber alloc]initWithInt:40],[[NSNumber alloc]initWithInt:41],[[NSNumber alloc]initWithInt:42], nil];
    
    for(NSNumber* n in m){
        if([n intValue]==drn)return TRUE;
    }
    return FALSE;
    
}

-(BOOL)ghostCostumeIsSquare:(int)drn{
    NSArray * m = [[NSArray alloc]initWithObjects:[[NSNumber alloc]initWithInt:13],[[NSNumber alloc]initWithInt:14],[[NSNumber alloc]initWithInt:20],[[NSNumber alloc]initWithInt:21],[[NSNumber alloc]initWithInt:22],[[NSNumber alloc]initWithInt:24],[[NSNumber alloc]initWithInt:36], nil];
    
    for(NSNumber* n in m){
        if([n intValue]==drn)return TRUE;
    }
    return FALSE;
    
}



-(BOOL)ghostCostumeIsSpecial:(int)drn{
    NSArray * m = [[NSArray alloc]initWithObjects:[[NSNumber alloc]initWithInt:27],[[NSNumber alloc]initWithInt:28], nil];
    
    for(NSNumber* n in m){
        if([n intValue]==drn)return TRUE;
    }
    return FALSE;
    
}

-(void) removeGhostAt:(uint) n
{
#if DEBUG_NSLog
    ////NSLog(@"@Usuwam duszka nr %i",n);
#endif
    
    AllGhosts[n] = nil;
}


-(MTGhost *)getGhostAt:(NSUInteger) n
{
    return AllGhosts[n];
}
-(void)setGhost:(MTGhost *) ghost At:(NSUInteger) n
{
    AllGhosts[n] = ghost;
}
-(void) addGhostCostumes
{
   
    
    for(int i =1;i<=CURRENT_GGHOST_COUNT;i++){
        NSMutableArray *array = [[NSMutableArray alloc] init];
        MTGhostDefaults* def = [MTGhostDefaults defaults];
        if( [self ghostCostumeIsSimple:i]){
            def = [MTGhostDefaults defaults:8 :YES];
        }
        for(int j=1;j<=CURRENT_GGHOST_COUNT;j++){
            [array addObject:[NSString stringWithFormat:@"D%d_C%d.png",i,j]];
            ////NSLog(@"Dodawnaie D%d_C%d.png",i,j);
        }
    
        [self.ghostCostumes setValue:array forKey:[NSString stringWithFormat:@"D%d_C1.png",i]];
        
        [self.ghostDefaults setValue:def forKey:[NSString stringWithFormat:@"%d",i]];
        
    }
}
-(NSArray *)getAllGhosts
{
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    
    for (int i=0;i< MAX_GHOST_COUNT;i++)
    {
        if(AllGhosts[i])
        [arr addObject: AllGhosts[i]];
    }
    return arr;
}

-(void) incrementCounterForCart:(MTCart *)cart
{
    NSString* cartType = [cart getMyType];
    NSNumber *cartCounter = [self usedCartsCounters] [cartType];
    if (cartCounter != nil)
    {
        cartCounter = [[NSNumber alloc] initWithInt: [cartCounter intValue]+1];
    }else
    {
        cartCounter = [[NSNumber alloc] initWithInt: 1];
    }
    [[self usedCartsCounters] setValue:cartCounter forKey: cartType ];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CounterIncreased" object:cart];
}
-(void) decrementCounterForCart:(MTCart *)cart
{
    NSString* cartType = [cart getMyType];
    NSNumber *cartCounter = [self usedCartsCounters] [cartType];
    if (cartCounter != nil)
    {
        int iVal = [cartCounter intValue];
        if (iVal > 1)
        {
            cartCounter = [[NSNumber alloc] initWithInt: [cartCounter intValue]-1];
            [[self usedCartsCounters] setValue:cartCounter forKey: cartType ];
        }else
        {
            [[self usedCartsCounters] removeObjectForKey: cartType];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CounterDecreased" object:cart];
}


// Serializacja ----------------------------------------------------------------
// Serializacja ----------------------------------------------------------------
// Serializacja ----------------------------------------------------------------
- (void) encodeWithCoder:(NSCoder *)encoder {
    for (uint i = 0 ; i < MAX_GHOST_COUNT ;i++)
    {
        [encoder encodeObject:[self getGhostAt:i] forKey: [NSString stringWithFormat:@"MTGhost%d",i]];
    }
    for (uint i = 0 ; i < MAX_GHOST_COUNT ;i++)
    {
        if(AllGhosts[i])
            [encoder encodeObject: AllGhosts[i].trains forKey:[NSString stringWithFormat:@"MTGhost%d Trains",i]];
        
    }
    [encoder encodeObject: [self usedCartsCounters] forKey:@"usedCartsCounters"];
    [encoder encodeObject: [self maxCartsCounts] forKey:@"maxCartsCounts"];
    [encoder encodeInteger: (int)[self ProjectType] forKey:@"ProjectType"];
    [encoder encodeInteger: [self GhostCount] forKey:@"GhostQuota"];
    [encoder encodeBool: [self JoystickEnabled] forKey:@"JoystickEnabled"];
    [encoder encodeBool: [self DebugEnabled] forKey:@"DebugEnabled"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [self initSingleton];
    for (uint i = 0 ; i < MAX_GHOST_COUNT ;i++)
    {
        [decoder decodeObjectForKey:[NSString stringWithFormat:@"MTGhost%d",i]];
#if DEBUG_NSLog
        ////NSLog(@"AllGhosts[%d] zawiera: %@",i,[[self getGhostAt:i] costumeName]);
#endif
    }
    
    for (uint i = 0 ; i < MAX_GHOST_COUNT ;i++)
    {
        if(AllGhosts[i])
            AllGhosts[i].trains = [decoder decodeObjectForKey:[NSString stringWithFormat:@"MTGhost%d Trains",i]];
    }
    
    MTMainScene *scene = (MTMainScene *)[[MTViewController getInstance] mainScene];
    MTGhostsBarNode * GBN = (MTGhostsBarNode *)[[scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTGhostsBarNode"];
     [GBN reloadGhostsFromStorage];
    [self setUsedCartsCounters: [decoder decodeObjectForKey:@"usedCartsCounters"]];
    [self setMaxCartsCounts: [decoder decodeObjectForKey:@"maxCartsCounts"]];
    [self setProjectType: (MTProjectTypeEnum) [decoder decodeIntegerForKey:@"ProjectType"]];
    [self setGhostCount: [decoder decodeIntegerForKey:@"GhostQuota"]];
    [self setJoystickEnabled:[decoder decodeBoolForKey:@"JoystickEnabled"]];
    [self setDebugEnabled:[decoder decodeBoolForKey:@"DebugEnabled"]];
    
    myInstanceMTS = self;
    return self;
}
@end
