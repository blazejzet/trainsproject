//
//  MTWheel.h
//  MagicTrains
//
//  Created by Kamil Tomasiak on 22.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTSpriteNode.h"
#import "MTLabelNode.h"
#import "MTLabelTextNode.h"
@class MTWheelPanel;
@interface MTWheelNode : MTSpriteNode

-(id) initWithCartName:(NSString *)cartName minValue : (CGFloat)minValue maxValue : (CGFloat)maxValue fullRotateValue : (CGFloat)fullRotateValue position : (CGPoint)position size : (CGSize) size andPanel:(MTWheelPanel*)myPanel myVariables: (NSMutableArray *)myVariables;

-(CGFloat) getWheelValue;

-(void)panGesture:(UIGestureRecognizer *)g :(UIView *)v;
-(void)tapGesture:(UIGestureRecognizer *)g;

@property MTWheelPanel* myPanel;
@property NSString* cartName;
@property float maxValue;
@property float minValue;
@property float fullRotateValue;
@property CGFloat value;
@property MTLabelTextNode *label;
//@property NSObject* myParent;
@property NSMutableArray * myVariables;
@property MTSpriteNode *circleNode;
@property CGPoint positionBackup;

@end
