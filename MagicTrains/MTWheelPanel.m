//
//  MTWheelPanel.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 18.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTWheelPanel.h"
#import "MTGUI.h"
#import "MTGhostRepresentationNode.h"
#import "MTCategoryBarNode.h" 
#import "MTViewController.h"
#import "MTGlobalVar.h"

@implementation MTWheelPanel
@synthesize numberSelectedVariable;

- (id) init
{
    self = [super init];
    self.wheel = [[MTWheelNode alloc] init];
    self.var1  = [[MTVisibleGlobalVar alloc] init];
    self.var2  = [[MTVisibleGlobalVar alloc] init];
    self.var3  = [[MTVisibleGlobalVar alloc] init];
    self.var4  = [[MTVisibleGlobalVar alloc] init];
    self.var5  = [[MTVisibleGlobalVar alloc] init];
    self.ghostHpVar = [[MTVisibleGlobalVar alloc] init];
    self.varX  = [[MTVisibleGlobalVar alloc] init];
    self.varY  = [[MTVisibleGlobalVar alloc] init];
    self.deck = [[MTSpriteNode alloc]initWithImageNamed:@"WSKAZ_WARTOSC.png"];
    
    self.myVariables = [[NSMutableArray alloc] init];
    [self fillMyVariablesArray];
    
    [self setNumberSelectedVariable:5];
    return self;
}

- (void)setNumberSelectedVariable:(NSUInteger)number
{
    [(MTSpriteNode *) self.myVariables[number] setAlpha:1.0];
    for (int i = 0 ; i < self.myVariables.count ; i++)
    {
        if (i != number)
        {
            [(MTSpriteNode *) self.myVariables[i] setAlpha:0.3];
        }
    }
    
    numberSelectedVariable = number;
}



-(CGFloat) getMySelectedValueWithGhostRepNode:(MTGhostRepresentationNode *) ghostRepNode
{
    CGFloat val = 0.0;
    MTGlobalVar *globalVar = [MTGlobalVar getInstance];
    
    switch (numberSelectedVariable) {
        case 0:
            val = [self.wheel getWheelValue];
            break;
            
        case 5:
            val = [globalVar getGlobalValue5WithRangeFrom: self.wheel.minValue to: self.wheel.maxValue];
            break;
            
        case 6:
            val = ghostRepNode.hp;
            break;
            
        case 7:
            val = ghostRepNode.position.x;
            break;
            
        case 8:
            val = ghostRepNode.position.y;
            break;
            
        
            
        default:
            //pobiera wartosc zmiennej globalnej
            val = [globalVar getGlobalValueWithNumber: self.numberSelectedVariable];
            break;
    }
    return val;
}

-(void) fillMyVariablesArray
{
    [self.myVariables addObject: self.wheel];
    [self.myVariables addObject: self.var1];
    [self.myVariables addObject: self.var2];
    [self.myVariables addObject: self.var3];
    [self.myVariables addObject: self.var4];
    [self.myVariables addObject: self.var5];
    [self.myVariables addObject: self.ghostHpVar];
    [self.myVariables addObject: self.varX];
    [self.myVariables addObject: self.varY];
}
-(void) prepareAsMiddlePanelWithMax:(int) max Min:(int) min fullRotate:(int) fullRot
{
    
    [self prepareAsPanelWithMax:max Min:min fullRotate:fullRot andPosition:175];
}
-(void) prepareAsMidLowPanelWithMax:(int)max Min:(int)min fullRotate:(int)fullRot
{
    [self prepareAsPanelWithMax:max Min:min fullRotate:fullRot andPosition:120];
  
}
-(void) prepareAsUpperPanelWithMax:(int) max Min:(int) min fullRotate:(int) fullRot
{
    [self prepareAsPanelWithMax:max Min:min fullRotate:fullRot andPosition:350];
    
}
-(void)setImage:(NSString*)i{
    self.deck.texture=[SKTexture textureWithImageNamed:i];
}
-(void) prepareAsPanelWithMax:(int) max Min:(int) min fullRotate:(int) fullRot andPosition:(int)v
{
    
    self.wheel = [self.wheel initWithCartName: @"MTRotationCart" minValue: min maxValue:max fullRotateValue:fullRot position:CGPointMake(BLOCK_AREA_WIDTH-200, 200+v) size:CGSizeMake(300, 300) andPanel:self myVariables:self.myVariables];
    
    self.var1 = [self.var1 prepareWithNumberGlobalVar:1 imageName:@"varG1.png" position:CGPointMake(BLOCK_AREA_WIDTH-40, 290+v) wheel:self.wheel andPanel:self myVariables:self.myVariables size:CGSizeMake(60, 60)];
    
    self.var2 = [self.var2 prepareWithNumberGlobalVar:2 imageName:@"varG2.png" position:CGPointMake(BLOCK_AREA_WIDTH-40, 230+v) wheel:self.wheel andPanel:self myVariables:self.myVariables size:CGSizeMake(60, 60)];
    
    self.var3 = [self.var3 prepareWithNumberGlobalVar:3 imageName:@"varG3.png" position:CGPointMake(BLOCK_AREA_WIDTH-40, 170+v) wheel:self.wheel andPanel:self myVariables:self.myVariables size:CGSizeMake(60, 60)];
    
    self.var4 = [self.var4 prepareWithNumberGlobalVar:4 imageName:@"varG4.png" position:CGPointMake(BLOCK_AREA_WIDTH-40, 110+v) wheel:self.wheel andPanel:self myVariables:self.myVariables size:CGSizeMake(60, 60)];
    
    self.var5 = [self.var5 prepareWithNumberGlobalVar:5 imageName:@"varG5.png" position:CGPointMake(BLOCK_AREA_WIDTH+20, 110+v) wheel:self.wheel andPanel:self myVariables:self.myVariables size:CGSizeMake(60, 60)];
    
    self.ghostHpVar = [self.ghostHpVar prepareWithNumberGlobalVar:6 imageName:@"varHP.png" position:CGPointMake(BLOCK_AREA_WIDTH+20, 290+v) wheel:self.wheel andPanel:self myVariables:self.myVariables size:CGSizeMake(60, 60)];
    
    //x i y
    self.varX = [self.varX prepareWithNumberGlobalVar:7 imageName:@"varX.png" position:CGPointMake(BLOCK_AREA_WIDTH+20,230+v) wheel:self.wheel andPanel:self myVariables:self.myVariables size:CGSizeMake(60, 60)];
    
    self.varY = [self.varY prepareWithNumberGlobalVar:8 imageName:@"varY.png" position:CGPointMake(BLOCK_AREA_WIDTH+20,170+v) wheel:self.wheel andPanel:self myVariables:self.myVariables size:CGSizeMake(60, 60)];

    self.deck.position=CGPointMake(160,self.wheel.position.y+5);
    self.deck.texture=[SKTexture textureWithImageNamed:@"WSKAZ_WARTOSC.png"];

}


-(void) prepareAsLowerPanelWithMax:(int) max Min:(int) min fullRotate:(int) fullRot
{
   
    [self prepareAsPanelWithMax:max Min:min fullRotate:fullRot andPosition:0];
   
}
-(void) showPanel
{
    MTCategoryBarNode *catBarNode = (MTCategoryBarNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
    
    self.wheel.zRotation = 0;
    self.wheel.label.zRotation = 0;
    
    [catBarNode addChild: self.wheel];
    [catBarNode addChild: self.var1];
    [catBarNode addChild: self.var2];
    [catBarNode addChild: self.var3];
    [catBarNode addChild: self.var4];
    [catBarNode addChild: self.var5];
    [catBarNode addChild: self.ghostHpVar];
    [catBarNode addChild: self.varX];
    [catBarNode addChild: self.varY];
    [catBarNode addChild: self.deck];
    
}

-(void) hidePanel
{
    MTCategoryBarNode *categoryBarNode = (MTCategoryBarNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
    
    [self.wheel removeFromParent];
    [self.var1  removeFromParent];
    [self.var2  removeFromParent];
    [self.var3  removeFromParent];
    [self.var4  removeFromParent];
    [self.var5  removeFromParent];
    [self.ghostHpVar removeFromParent];
    [self.varX  removeFromParent];
    [self.varY  removeFromParent];
    [self.deck  removeFromParent];
    
    categoryBarNode.someOptionsOpened = false;
}



 //--------------------------------------------------------------------------//
//       Serializacja                                                         //
 //--------------------------------------------------------------------------//

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    self.wheel.value = [aDecoder decodeFloatForKey:@"WheelValue"];
    [self setNumberSelectedVariable:[aDecoder decodeIntegerForKey:@"numberSelectedVariable"]];
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeFloat: self.wheel.value forKey:@"WheelValue"];
    [aCoder encodeInteger: self.numberSelectedVariable forKey:@"numberSelectedVariable"];
}
@end
