//
//  MTGhostRepresentationEffectNode.h
//  MagicTrains
//
//  Created by Mateusz Wieczorkowski on 17.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTGhostRepresentationNode.h"
#import "MTCodeBlockNode.h"
/*Klasa dziedziczy ze zwyklej reprezentacji, dzieki czemu obsluguje gesty*/
@interface MTGhostRepresentationEffectNode : MTGhostRepresentationNode

/*Wskaznik na reprezentacje, na ktorej tworzony jest efekt*/
@property MTGhostRepresentationNode* myGRN;
@property float myGRNzPosition;

/*Zwraca wskaznik na aktualnego NODEa-efekt*/
+(MTGhostRepresentationEffectNode*) getCurrentEffectNode;

/*Główne funkcje*/
-(id) initEffectNodeOn: (MTGhostRepresentationNode *)GRN;
-(id) initEffectNodeOnCart: (MTCodeBlockNode*)GRN;
-(void) removeEffectNode;

/*Dostepne animacje*/
-(void) doSelectedAnimationWithMe;
-(void) doUnselectedAnimationWithMe;
-(void) doPostInitAnimationWithMe;
+(MTGhostRepresentationEffectNode*) getCurrentEffectNode;
-(void)setLightRotation:(CGFloat)zRotation;
@end
