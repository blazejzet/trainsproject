//
//  MTGlobalVar.m
//  MagicTrains
//
//  Created by Programowanie Zespołowe on 14.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTVisibleGlobalVar.h"
#import "MTGlowFilter.h"
#import "MTRotationCartOptions.h"
#import "MTCategoryBarNode.h"
#import "MTMoveCartsOptions.h"
#import "MTGoXYCartOptions.h"
#import "MTPauseCartOptions.h"
#import "MTIfCartOptions.h"
#import "MTWheelPanel.h"
#import "MTForLoopCartOptions.h"
#import "MTGlobalVariableCartsOptions.h"
#import "MTNotSandboxProjectOrganizer.h"

@implementation MTVisibleGlobalVar

-(id) prepareWithNumberGlobalVar: (uint)numberGlobalVar imageName: (NSString*)image position: (CGPoint)position wheel: (MTWheelNode*) wheel andPanel:(MTWheelPanel*)myPanel
                  myVariables: (NSMutableArray *)myVariables size: (CGSize )size{
   
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.size = size;
        self.texture = [SKTexture textureWithImageNamed:image];
        //numer zmiennej globalnej
        self.numberGlobalVar = numberGlobalVar;
        
        self.name = @"MTVisibleGlobalVar";
        self.position = position;
        self.myPanel = myPanel;
        self.positionBackup = self.position;
        //self.wheel = wheel;
        //self.myVariables = myVariables;
    
    return self;
}
/*
-(id) initWithNumberGlobalVar: (uint)numberGlobalVar imageName: (NSString*)image position: (CGPoint)position wheel: (MTWheelNode*) wheel andParent:(NSObject*)myParent
      myVariables: (NSMutableArray *)myVariables size: (CGSize )size{
    if ((self = [super initWithImageNamed:image]))
    {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.size = size;
        
        //numer zmiennej globalnej
        self.numberGlobalVar = numberGlobalVar;
        
        self.name = @"MTVisibleGlobalVar";
        self.position = position;
        self.myPanel = myParent;
        //self.wheel = wheel;
        self.myVariables = myVariables;
    }
    
    return self;
}*/

/**
 * Obsluga tapniecia
 * podczas tapniecia w dana zmienna globalna w opcjach tego wagonu zapisuje ktora zmienna globalna
 * (numer zmiennej) zostala wybrana
 */
-(void)tapGesture:(UIGestureRecognizer *)g
{
    if ([[MTNotSandboxProjectOrganizer getInstance] isSelectedTabBlocked]) return;
    
    self.myPanel.numberSelectedVariable = self.numberGlobalVar;
    
    //zmieniam alphe dla poszczegolnych elmentow zeby tylko wybrany byl zaznaczony
    /*self.wheel.alpha = 0.3;
    
    for(int i = 0; i < self.myVariables.count; i++)
    {
        if (self != self.myVariables[i])
        {
            ((MTVisibleGlobalVar*)self.myVariables[i]).alpha = 0.3;
        }
        else
        {
            ((MTVisibleGlobalVar*)self.myVariables[i]).alpha = 1;
        }
    }*/
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
