//
//  MTCart.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 08.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTGhostRepresentationNode.h"

enum MTCartType {
    MTNullNumber = 0,
    MTStartLocomotiveNumber = 1,
    MTMoveCartNumber = 10
};
enum MTCartCategory {
    MTCategoryLocomotive = 1,
    MTCategoryMove = 2,
    MTCategoryLoop = 3,
    MTCategoryControl = 4,
    MTCategoryGhost = 5,
    MTCategoryLogic = 6,
    MTCategoryRotate =7,
    MTCartOptions = 50
 };

@class MTTrain;
@class MTSubTrain;


@interface MTCart : NSObject <NSCoding>
@property CGPoint oldposition;
//@property MTTrain* myTrain;
@property MTSubTrain* mySubTrain;

/// mowi o tym czy dany wagonik jest natychmiastowy tj czy zajmuje mniej niz jedna klatke czasu
@property bool isInstantCart;

///Nr wagonika w tablicy w kodzie nadawany w trakcie kompilacji
@property uint numberInCodeArray;

///Nr tablicy z kodem nadawany w trakcie kompilacji
@property uint numberOfCodeArray;

/*Funkcje otwierajace i zamykajace opcje; pozostawic puste w przypadku braku opcji*/
@property bool optionsOpen; //czy opcje wagonika sa otwarte?
@property bool activeNow;
@property bool activeBefore;
-(void) showOptions;
-(void) hideOptions;

-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode;
+(NSString*)getMyType;
+(NSString*)DoGetMyType;
-(NSString*)getImageName;

-(id) options;
-(void) setOptions:(id)options;
-(int) getMyCounter;
-(int) getMyMaxCount;
-(bool) isActive;
-(bool) wasActiveBefore;
-(int)getCategory;
-(id) initWithSubTrain: (MTSubTrain *) t;
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) t;
-(CGFloat) returnMyValidDistance:(MTGhostRepresentationNode *) rep WithFi:(CGFloat) fi;

-(void)compileMeForTrain:(MTTrain *) myTrain;

//- (id) getTrainVariableWithName:(NSString*)name Class:(Class) aClass FromGhostRepNode:(MTGhostRepresentationNode*)GRN;
- (id) getVariableWithName:(NSString*)name Class:(Class) aClass FromGhostRepNode:(MTGhostRepresentationNode*)GRN;
- (void) setTrainVariable:(id) variable WithName:(NSString*)name FromGhostRepNode:(MTGhostRepresentationNode*)GRN;
- (void) setVariable:(id) variable WithName:(NSString*)name FromGhostRepNode:(MTGhostRepresentationNode*)GRN;

//new
-(NSString*) getMyType;

@end
