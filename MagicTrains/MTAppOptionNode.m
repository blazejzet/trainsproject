//
//  MTAppOptionNode.m
//  MagicTrains
//
//  Created by Mateusz Wieczorkowski on 30.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTAppOptionNode.h"
#import "MTViewController.h"
#import "MTSceneAreaNode.h"
#import "MTMainScene.h"
#import "MTDialogWindow.h"
#import "MTStorage.h"

@implementation MTAppOptionNode

-(id) initDebugInPosition: (CGPoint)position;
{
    if ((self = [super initWithImageNamed:@"debugONOption"]))
    {
        self.position = position;
        self.size = CGSizeMake(150, 150);
        self.selected = false;
        self.name = @"debugModeNode";
    }

    return self;
}

-(id) initJoystickInPosition: (CGPoint)position;
{
    if ((self = [super initWithImageNamed:@"joystickONOption"]))
    {
        self.position = position;
        self.size = CGSizeMake(150, 150);
        self.selected = false;
        self.name = @"joystickModeNode";
    }
    
    return self;
}

-(id) initSaveInPosition: (CGPoint)position
{
    if ((self = [super initWithImageNamed:@"Download_Icon"]))
    {
        self.position = position;
        self.size = CGSizeMake(150, 150);
        self.selected = false;
        self.name = @"saveProject";
    }
    
    return self;
}

-(void) tapGesture:(UIGestureRecognizer *)g {

    SKNode * scene = [[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
    
    if (self.selected == false)
    {
        if([self.name isEqualToString:@"debugModeNode"])
        {
            self.selected = true;
            [MTStorage getInstance].DebugEnabled = true;
            [self refleshOptions];
            [self saveSettings];
        }
        
        if([self.name isEqualToString:@"joystickModeNode"])
        {
            self.selected = true;
            [MTStorage getInstance].JoystickEnabled = true;
            [self refleshOptions];
            [self saveSettings];
        }
        
    } else {
        
        if([self.name isEqualToString:@"debugModeNode"])
        {
            self.selected = false;
            [MTStorage getInstance].DebugEnabled = false;
            [self refleshOptions];
            [self saveSettings];
        }
        
        if([self.name isEqualToString:@"joystickModeNode"])
        {
            self.selected = false;
            [MTStorage getInstance].JoystickEnabled = false;
            [self refleshOptions];
            [self saveSettings];
        }
    }
    if([self.name isEqualToString:@"saveProject"])
    {
        MTDialogWindow *window = [[MTDialogWindow alloc] init];
        [(MTMainScene *) self.scene addChild:window];
    }

}

-(void) refleshOptions
{
    SKNode * scene = [[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
 
    UIImage *debugONimg = [UIImage imageNamed:@"debugONOption"];
    SKTexture *debugONtex = [SKTexture textureWithImage:debugONimg];
    
    UIImage *debugOFFimg = [UIImage imageNamed:@"debugOFFOption"];
  //  SKTexture *debugOFFtex = [SKTexture textureWithImage:debugOFFimg];
    
    UIImage *joystickONimg = [UIImage imageNamed:@"joystickONOption"];
    SKTexture *joystickONtex = [SKTexture textureWithImage:joystickONimg];
    
    UIImage *joystickOFFimg = [UIImage imageNamed:@"joystickOFFOption"];
    SKTexture *joystickOFFtex = [SKTexture textureWithImage:joystickOFFimg];
    
    SKTexture *saveProjectTex = [SKTexture textureWithImageNamed:@"Download_Icon.jpg"];
    
    if ([self.name isEqualToString:@"debugModeNode"])
    {
        if([MTStorage getInstance].DebugEnabled  == true)
        {
            self.selected = true;
            [self setTexture:debugONtex];
            self.alpha = 1.0;
        }
        
        if([MTStorage getInstance].DebugEnabled == false)
        {
            self.selected = false;
            [self setTexture:debugONtex];
            self.alpha = 0.4;
        }
        
    } else if ([self.name isEqualToString:@"joystickModeNode"]){
        
        if([MTStorage getInstance].JoystickEnabled == true)
        {
            self.selected = true;
            [self setTexture:joystickONtex];
            //self.alpha = 1.0;
        }
        
        if([MTStorage getInstance].JoystickEnabled == false)
        {
            self.selected = false;
            [self setTexture:joystickOFFtex];
            //self.alpha = 0.4;
        }
    } else if ([self.name isEqualToString:@"saveProject"])
    {
        self.selected = false;
        [self setTexture: saveProjectTex];
    }
}
/* czy to jest potrzebne? */
-(void) saveSettings
{
    SKNode * scene = [[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
    
    [[NSUserDefaults standardUserDefaults] setBool:[MTStorage getInstance].JoystickEnabled forKey:@"joystickModeKey"];
}

@end
