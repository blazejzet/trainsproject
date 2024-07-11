//
//  MTBlockNode.h
//  MagicTrains
//
//  Created by Mateusz Wieczorkowski on 06.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTSpriteNode.h"
#import "MTTrain.h"
@interface MTBlockNode : MTSpriteNode

@property uint tabNr;
@property MTCart* myCart;

//@property MTSubTrain* mySubTrain;
@property SKNode* myOrigin;
@property CGPoint oldposition;
-(MTSubTrain *) getMySubTrain;
-(id)initWithCart: (MTCart *) cart;

-(void) whenIAmOverBlockNodeWithGesture: g inViev: v;
-(bool) removeMyCartInStorage;
-(bool)removeFullTrainInStorage;

-(void)changeMyParentTo:(SKNode *) newParent;

-(void)executeBlockDrop:(SKNode*) targetedNode;
-(SKNode *) checkWhatIsBelowMeWithGesture: g
                                   inView: v;

@end
