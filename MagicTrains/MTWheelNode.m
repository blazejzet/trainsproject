//
//  MTWheel.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 22.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTWheelNode.h"
#import "MTGUI.h"
#import "MTMainScene.h"
#import "MTRotationCartOptions.h"
#import "MTMoveCartsOptions.h"
#import "MTGoXYCartOptions.h"
#import "MTPauseCartOptions.h"
#import "MTIfCartOptions.h"
#import "MTForLoopCartOptions.h"
#import "MTGlobalVariableCartsOptions.h"
#import "MTWheelCircleNode.h"
#import "MTWheelPanel.h"
#import "MTNotSandboxProjectOrganizer.h"

@implementation MTWheelNode
-(id)init
{
    self = [super initWithImageNamed:@"wheel.png"];
    self.value = 0;
    self.zRotation = 0;
    self.anchorPoint = CGPointMake(0.5, 0.5);
    
    return self;
}
-(id)initWithCartName: (NSString *)cartName minValue : (CGFloat)minValue maxValue : (CGFloat)maxValue fullRotateValue : (CGFloat)fullRotateValue position : (CGPoint)position size : (CGSize) size andPanel:(MTWheelPanel *)myPanel myVariables: (NSMutableArray *)myVariables{
    
    //if ((self = [super initWithImageNamed:@"wheel.png"]))
    {
        self.size = size;
        self.cartName = cartName;
       // self.value = 0;
        self.name = @"MTWheelNode";
        self.maxValue = maxValue;
        self.fullRotateValue = fullRotateValue;
        self.minValue = minValue;
    
        self.myVariables = myVariables;
        self.position = position;
        self.myPanel = myPanel;
        self.positionBackup = self.position;
        
        [self addLabelToWheel];
        [self addCircleToWheel];
    }
    
    return self;
}//zwraca wartosc kola
-(CGFloat) getWheelValue
{
    return self.value;
}
-(void)rotateGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    UIRotationGestureRecognizer*p = (UIRotationGestureRecognizer*)g;
    
    if ([[MTNotSandboxProjectOrganizer getInstance] isSelectedTabBlocked]) return;
    CGFloat angle = p.rotation;
    static float tmp;
    static float valueTmp;
    
    if(g.state == UIGestureRecognizerStateBegan)
    {
        tmp = angle - self.zRotation;
        valueTmp = 0;

        //wartoscxi x i y
        self.myPanel.numberSelectedVariable = 0;

    }
    
    if ((!((int)roundf(valueTmp + self.value) <= self.minValue) || !(p.rotation < 0)) &&
        (!((int)roundf(valueTmp + self.value) >= self.maxValue) || !(p.rotation > 0)))
    {
        [self setZRotation: -angle - tmp];
        valueTmp = ((p.rotation / 6.28 ) * self.fullRotateValue);
        
        /// uzaleznic wzor od wielkosci wheel
        if(![self.cartName isEqual:@"MTForCart"])
        {
            [self.circleNode runAction:[SKAction resizeToWidth:( 90/self.maxValue)*roundf(valueTmp + self.value) height:(90/self.maxValue)*roundf(valueTmp + self.value) duration:0.05]];
            //self.circleNode.size = CGSizeMake(( 90/self.maxValue)*roundf(valueTmp + self.value), (90/self.maxValue)*roundf(valueTmp + self.value));
        }
        else
        {
            [self.circleNode runAction:[SKAction resizeToWidth:(120/self.maxValue)*roundf(valueTmp + self.value) height:(120/self.maxValue)*roundf(valueTmp + self.value) duration:0.05]];
            //self.circleNode.size = CGSizeMake((120/self.maxValue)*roundf(valueTmp + self.value), (120/self.maxValue)*roundf(valueTmp + self.value));
        }
        
        self.label.text = [NSString stringWithFormat:@"%i", (int)roundf(valueTmp + self.value)];
        
        [self.label setZRotation : -self.zRotation];
    }
    
    if((int)roundf(valueTmp + self.value) < (int)self.minValue) {
        self.label.text = [NSString stringWithFormat:@"%i", (int)self.minValue];
    }
    if((int)roundf(valueTmp + self.value) > (int)self.maxValue) {
        self.label.text = [NSString stringWithFormat:@"%i", (int)self.maxValue];
    }
    
    if (g.state == UIGestureRecognizerStateEnded)
    {
        if((int)roundf(valueTmp + self.value) < self.minValue)
        {
            self.value = self.minValue;
        }
        else if((int)roundf(valueTmp + self.value) >= self.maxValue)
        {
            self.value = self.maxValue;
        }
        else
        {
            self.value = (int)roundf(valueTmp + self.value);
        }
        
        [self setZRotation: self.zRotation];
        
        self.label.text = [NSString stringWithFormat:@"%i", (int)(self.value)];
    }
}

-(void)panGesture:(UIGestureRecognizer *)g :(UIView *)v
{
#if DEBUG_NSLog
    ////NSLog(@"pan");
#endif
}

-(void)tapGesture:(UIGestureRecognizer *)g
{
    if ([[MTNotSandboxProjectOrganizer getInstance] isSelectedTabBlocked]) return;
    self.myPanel.numberSelectedVariable = 0;
}

-(void) pinchGesture:(UIGestureRecognizer *) g :(UIView *) v
{
#if DEBUG_NSLog
    ////NSLog(@"pinch");
#endif
}

-(void) addLabelToWheel
{
    self.label = [[MTLabelTextNode alloc] init];
    self.label.text = [NSString stringWithFormat:@"%d", (int)roundf(self.value)];
    self.label.zPosition = 1;
    [self addChild: self.label];
}

-(void) addCircleToWheel
{
    self.circleNode = [[MTWheelCircleNode alloc] init];
    [self addChild: self.circleNode];
}

-(void) setAlpha:(CGFloat)alpha
{
    [self runAction:[SKAction fadeAlphaTo:alpha duration:0.2]];
}

-(void) removeFromParent
{
    self.position = self.positionBackup;
    [super removeFromParent];
}

@end
