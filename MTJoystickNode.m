//
//  MTJoystickNode.m
//  MagicTrains
//
//  Created by Blazej Zyglarski on 16.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTJoystickNode.h"
#import "MTJoystickLeftArrowNode.h"
#import "MTJoystickRightArrowNode.h"
#import "MTJoystickUpArrowNode.h"
#import "MTJoystickDownArrowNode.h"
#import "MTJoystickCenterNode.h"
#import "MTJoystickNotificationsNames.h"
#import "MTSpriteNode.h"

@interface MTJoystickNode()
@property NSMutableArray * joystickElements;
@property MTJoystickCenterNode* eye;
@end

@implementation MTJoystickNode

@synthesize joystickElements;
@synthesize eye;

-(id)init{
    self = [super initWithImageNamed:@"JOYSTICKBG.png"];
    if(self){
        //[self setScale:0.5];
        [self setAnchorPoint:CGPointMake(0.5,0.5)];
        [self setPosition:CGPointMake(120,120)];
        [self setZPosition:1000];
        
        self.joystickElements = [[NSMutableArray alloc]init];
        
        self.eye = [[MTJoystickCenterNode alloc] init];
        //[self addChild:eye];
        
        MTJoystickLeftArrowNode *leftArrow = [[MTJoystickLeftArrowNode alloc] init];
        [self.joystickElements addObject:leftArrow];
        [self addChild:leftArrow];
        //leftArrow.position=CGPointMake(40, 80);
        
        MTJoystickRightArrowNode *rightArrow = [[MTJoystickRightArrowNode alloc] init];
        [self.joystickElements addObject:rightArrow];
        [self addChild:rightArrow];
        //rightArrow.position=CGPointMake(120, 80);
        
        MTJoystickUpArrowNode *upArrow = [[MTJoystickUpArrowNode alloc] init];
        [self.joystickElements addObject:upArrow];
        [self addChild:upArrow];
        //upArrow.position=CGPointMake(80, 120);
        
        MTJoystickDownArrowNode *downArrow = [[MTJoystickDownArrowNode alloc] init];
        [self.joystickElements addObject:downArrow];
        [self addChild:downArrow];
        //upArrow.position=CGPointMake(80, 40);
        [self addChild:eye];
       
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLeftArrowFlag) name: N_JoystickLeftArrowPush object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRightArrowFlag) name: N_JoystickRightArrowPush object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpArrowFlag) name: N_JoystickUpArrowPush object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDownArrowFlag) name: N_JoystickDownArrowPush object:nil];
        
        
    }
    return self;
}

-(void)setLeftArrowFlag{
    [self.eye runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(-90, 0) duration:0.1],[SKAction moveTo:CGPointMake(0, 0) duration:0.1]]]];
}
-(void)setRightArrowFlag{
    [self.eye runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(90, 0) duration:0.1],[SKAction moveTo:CGPointMake(0, 0) duration:0.1]]]];
}
-(void)setUpArrowFlag{
    [self.eye runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(0, 90) duration:0.1],[SKAction moveTo:CGPointMake(0, 0) duration:0.1]]]];
}
-(void)setDownArrowFlag{
    [self.eye runAction:[SKAction sequence:@[[SKAction moveTo:CGPointMake(0, -90) duration:0.1],[SKAction moveTo:CGPointMake(0, 0) duration:0.1]]]];
}
@end
