//
//  MTBlockingBackground.m
//  MagicTrains
//
//  Created by Mateusz Wieczorkowski on 04.05.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTBlockingBackground.h"
#import "MTViewController.h"
#import "MTSceneAreaNode.h"
#import "MTGhostsBarNode.h"
#import "MTCodeAreaNode.h"
#import "MTCategoryBarNode.h"
#import "MTTrashNode.h"
#import "MTGUI.h"

@implementation MTBlockingBackground

-(id) initCodeAreaBackgroundWithDuration: (CGFloat)duration Color: (UIColor*)color Alpha: (CGFloat)alpha andWaitTime: (CGFloat)wait;
{
    if (self = [super init])
    {
        
        if(ANIMATIONS)
        {
            
            SKNode * code = [[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTBlockRoot"];
            SKNode * trash = [[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTBlockRoot"];
            
            self.duration = duration;
            self.backgroundColor = color;
            self.backgroundAlpha = alpha;
            
            self.codeBackground = [[MTSpriteNode alloc] initWithColor:self.backgroundColor size:CGSizeMake(CODE_AREA_WIDTH ,HEIGHT)];
            self.codeBackground.anchorPoint = CGPointMake(0, 0);
            self.codeBackground.position = CGPointMake(trash.position.x-80, trash.position.y);
            self.codeBackground.alpha = 0.0;
            self.codeBackground.zPosition = 300;
            
            SKAction *element1 = [SKAction waitForDuration:wait];
            SKAction *element2 = [SKAction fadeAlphaTo:self.backgroundAlpha duration:self.duration];
            SKAction *animation = [SKAction sequence:@[element1, element2]];
            
            [self.codeBackground runAction:animation];
            
            if(code != nil) {
                [(MTCodeAreaNode *)code addChild:self.codeBackground];
            }
        }
    }
    
    return self;
}

-(id) initFullBackgroundWithDuration: (CGFloat)duration Color: (UIColor*)color Alpha: (CGFloat)alpha andWaitTime: (CGFloat)wait;
{
    if (self = [super init])
    {
        if(ANIMATIONS)
            {
            SKNode * scene = [[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
            SKNode * category = [[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTCategoryBarNode"];
            SKNode * ghost = [[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTGhostsBarNode"];
            SKNode * code = [[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTBlockRoot"];
            SKNode * trash = [[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTBlockRoot"];
            
            self.duration = duration;
            self.backgroundColor = color;
            self.backgroundAlpha = alpha;
                
            SKAction *element1 = [SKAction waitForDuration:wait];
            SKAction *element2 = [SKAction fadeAlphaTo:self.backgroundAlpha duration:self.duration];
            SKAction *animation = [SKAction sequence:@[element1, element2]];
            
            self.sceneBackground = [[MTSpriteNode alloc] initWithColor:self.backgroundColor size:CGSizeMake(WIDTH ,HEIGHT)];
            self.sceneBackground.anchorPoint = CGPointMake(0.5, 0.5);
            self.sceneBackground.position = CGPointMake(0, 0);
            self.sceneBackground.alpha = 0.0;
            self.sceneBackground.zPosition = 1999;
                
            [self.sceneBackground runAction:animation];
            
            if(scene != nil) {
                [(MTSceneAreaNode *)scene addChild:self.sceneBackground];
            }
            
            self.ghostMenuBackground = [[MTSpriteNode alloc] initWithColor:self.backgroundColor size:CGSizeMake(GHOST_BAR_WIDTH ,HEIGHT)];
            self.ghostMenuBackground.anchorPoint = CGPointMake(0, 0);
            self.ghostMenuBackground.position = CGPointMake(0, 0);
            self.ghostMenuBackground.alpha = 0.0;
            self.ghostMenuBackground.zPosition = 1999;
            
            [self.ghostMenuBackground runAction:animation];
            
            if(ghost != nil) {
                [(MTGhostsBarNode *)ghost addChild:self.ghostMenuBackground];
            }
        
            self.codeBackground = [[MTSpriteNode alloc] initWithColor:self.backgroundColor size:CGSizeMake(CODE_AREA_WIDTH ,HEIGHT)];
            self.codeBackground.anchorPoint = CGPointMake(0, 0);
            self.codeBackground.position = CGPointMake(trash.position.x-80, trash.position.y);
            self.codeBackground.alpha = 0.0;
            self.codeBackground.zPosition = 300;
        
            [self.codeBackground runAction:animation];
            
            if(code != nil) {
                [(MTCodeAreaNode *)code addChild:self.codeBackground];
            }
            
            self.categoryBarBackground = [[MTSpriteNode alloc] initWithColor:self.backgroundColor size:CGSizeMake(CATEG_BAR_WIDTH+BLOCK_AREA_WIDTH ,HEIGHT)];
            self.categoryBarBackground.anchorPoint = CGPointMake(0, 0);
            self.categoryBarBackground.position = CGPointMake(0, 0);
            self.categoryBarBackground.alpha = 0.0;
            self.categoryBarBackground.zPosition = 1999;
            
            [self.categoryBarBackground runAction:animation];
            
            if(category != nil) {
                [(MTCodeAreaNode *)category addChild:self.categoryBarBackground];
            }
    }

}

    return self;
}

-(void) removeBackground
{
    [self.sceneBackground removeFromParent];
    [self.ghostMenuBackground removeFromParent];
    [self.codeBackground runAction:[SKAction fadeAlphaTo:0.0 duration:self.duration/2] completion:^{
       [self.codeBackground removeFromParent];
    }];
    [self.codeBackground removeFromParent];
    [self.categoryBarBackground removeFromParent];
}

@end
