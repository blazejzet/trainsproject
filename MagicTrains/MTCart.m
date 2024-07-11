//
//  MTCart.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 08.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//
#import "MTGUI.h"
#import "MTCart.h"

#import "MTLocomotive.h"
#import "MTTrain.h"
#import "MTGhost.h"
#import "MTSubTrain.h"
#import "MTStorage.h"

#import "MTGhost.h"
#import "MTGhostRepresentationNode.h"
@implementation MTCart
@synthesize oldposition;

@synthesize activeNow;
@synthesize activeBefore;
/**
 * Metoda wykonująca kod w wagoniku
 *
 * @return TRUE jeżeli operacja w wagoniku jest zakonczona
 *         FALSE w przeciwnym wypadku.
 */

-(id)init
{
    //[self populateActive];
    self.activeNow = false;
    return self;
}

-(id)options
{
    return nil;
}

-(void) setOptions:(id)options
{
    
}


-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode // InTime:];
{
    return true;
}
-(void)showOptions
{
    self.optionsOpen = true;
}
-(void)hideOptions
{
    self.optionsOpen = true;
}
+(NSString*)getMyType
{
    return [self DoGetMyType];
}
+(NSString*)DoGetMyType
{
    return @"";
}

-(NSString*) getMyType
{
    return [MTCart DoGetMyType];
}

-(NSString*)getImageName
{
    return @"addGhost.png";
}
-(int)getCategory
{
    return 0;
}
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train
{
    
    return nil;
}

-(int) getMyCounter
{
    NSNumber *cartCounter = [[MTStorage getInstance] usedCartsCounters] [[self getMyType]];
    int val = 0;
    if (cartCounter != nil)
        val = [cartCounter intValue];
    return val;
}

-(int) getMyMaxCount
{
    NSNumber *maxCartCount = [[MTStorage getInstance] maxCartsCounts] [[self getMyType]];
    int val = -1;
    if (maxCartCount != nil)
        val = [maxCartCount intValue];
    return val;
}



-(bool) isActive
{
    return self.activeNow;
}
-(bool) wasActiveBefore
{
    return self.activeBefore;
}
-(id) initWithSubTrain: (MTSubTrain *) t
{
    self.isInstantCart = true;
    self.mySubTrain = t;
    self.optionsOpen = true;
    //[self countMeInCartCounters];
    return self;
}

-(void) compileMeForTrain:(MTTrain *) myTrain
{
    self.numberInCodeArray = [myTrain.code indexOfObject:self];
    self.numberOfCodeArray = myTrain.myNumber;
}

/*-(void) countMeInCartCounters
{
    [[MTStorage getInstance] incrementCounterForCart:self ];
    [self populateActive];
}

-(void) uncountMeInCartCounters
{
    [[MTStorage getInstance] decrementCounterForCart:self ];
    [self populateActive];
}*/

-(CGFloat) returnMyValidDistance:(MTGhostRepresentationNode *)rep WithFi:(CGFloat)fi
{
    float g = HEIGHT /2 - [rep position].y;
    float a = rep.size.height;
    
    float alpha = (M_PI / 2)  - fi;
    float dist = g / cosf(alpha) - a/2;
    
    return fabsf(dist);//fmaxf(dist, dist1);
    
}

- (id) setTrainVariableWithName:(NSString*)name Class:(Class) aClass FromGhostRepNode:(MTGhostRepresentationNode*)GRN
{
    return [GRN getVariableWithName:name Class:aClass ForCartNo: -1 TrainNo: self.numberOfCodeArray];
}

- (id) getVariableWithName:(NSString*)name Class:(Class) aClass FromGhostRepNode:(MTGhostRepresentationNode*)GRN
{
    return [GRN getVariableWithName:name Class:aClass ForCartNo: self.numberInCodeArray TrainNo: self.numberOfCodeArray];
}

- (void) setTrainVariable:(id) variable WithName:(NSString*)name FromGhostRepNode:(MTGhostRepresentationNode*)GRN
{
    [GRN setVariable:variable WithName:name ForCartNo: -1 TrainNo: self.numberOfCodeArray];
}
- (void) setVariable:(id) variable WithName:(NSString*)name FromGhostRepNode:(MTGhostRepresentationNode*)GRN
{
    [GRN setVariable:variable WithName:name ForCartNo:self.numberInCodeArray TrainNo: self.numberOfCodeArray];
}

-(void) setActive: (bool) val
{
   /* self.activeBefore = self.activeNow;
    self.activeNow = val;*/
}

-(void) populateActive
{
    if ([self getMyMaxCount] == -1)
        [self setActive: true];
    else{
        if ([self getMyCounter] < [self getMyMaxCount])
            [self setActive: true];
        [self setActive: false];
    }
}

///-----------------------------------------------------
///    Serializacja
///-----------------------------------------------------
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:([[self class] DoGetMyType]) forKey:@"TypeOfCart"];
    
    [encoder encodeObject:[self mySubTrain] forKey:@"mySubTrain"];
    [encoder encodeObject:[self options] forKey:@"options"];
    
    ////NSLog(@"%@ G:%u T:%d",self.class,
       //   [self.mySubTrain.myTrain.myGhost myNumber],
        //  [self.mySubTrain.myTrain myNumber]);
}

-(id)initWithCoder:(NSCoder *)decoder
{
    [self setOptionsOpen: false];
    
    MTSubTrain *myST = ([decoder decodeObjectForKey:@"mySubTrain"]);
    
    MTCart* cart = [self getNewWithSubTrain: myST];
    
#if DEBUG_NSLog
    ////NSLog(@"%@ ST:%d",self.class,
          [myST.myTrain.myGhost myNumber]);

    ////NSLog(@"%@ G:%d T:%d",self.class,
          [cart.mySubTrain.myTrain.myGhost myNumber],
          [cart.mySubTrain.myTrain myNumber]);
#endif
    
    [cart setOptions: [decoder decodeObjectForKey:@"options"]];
    
    [myST addCart:cart];
    self = cart;
    return self;
}
@end
