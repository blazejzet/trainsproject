//
//  MTCollisionWithAnotherGhostLocomotivGhostIconNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 30.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCollisionWithAnotherGhostLocomotivGhostIconNode.h"
#import "MTCollisionWithAnotherGhostLocomotivOptions.h"
#import "MTGhost.h"
#import "MTSpriteNode.h"
#import "MTViewController.h"
#import "MTCategoryBarNode.h"
#import "MTSpriteNodeGI.h"
#import "MTNotSandboxProjectOrganizer.h"

@implementation MTCollisionWithAnotherGhostLocomotivGhostIconNode
@synthesize allIcons;

static MTCollisionWithAnotherGhostLocomotivGhostIconNode* prevSelectedIcon;
-(id)initWithImageNamed:(NSString *)name{
    self = [super initWithImageNamed:name];
    ////NSLog(@">>>>>>>>%@",name);
    NSString* uname= [NSString stringWithFormat:@"%@_USMIECHNIETY_1",[name componentsSeparatedByString:@"_"][0]];
    
    if([[[name componentsSeparatedByString:@"_"][0] componentsSeparatedByString:@"D"][1] intValue]<10){
        SKSpriteNode*face =[[MTSpriteNodeGI alloc]initWithImageNamed:uname];
        if(face.texture!=nil){
            [self addChild:face];
            face.size = CGSizeMake(75, 75);
        }
    }
    
    return self;
}

-(id) initWithTexture:(SKTexture *)texture AndPosition:(CGPoint) position AndGhost:(MTGhost *)ghost andMyLocomotivOptions:(MTCollisionWithAnotherGhostLocomotivOptions *)options
{
    if ((self = [super init]))
    {
        self.myOptions = options;
        self.ghostFromGhostBar = ghost;
        self.position = position;
        self.texture = texture;
        self.size = CGSizeMake(75, 75);
        self.time = 0.15;
    }
    
    return self;
}

-(void)resetPosition{
    [self runAction:[SKAction moveTo:_oldPosition duration:0.3]];
}

-(void)tapGesture:(UIGestureRecognizer *)g
{
    if ([[MTNotSandboxProjectOrganizer getInstance] isSelectedTabBlocked]) return;
    
    if(self.myOptions.currentSelectedGhostIcon != self)
    {
        if(self.myOptions.isAnimationRuning == false)
        {
            
            //reseticonsposition
            for(MTCollisionWithAnotherGhostLocomotivGhostIconNode* icon in self.allIcons){
                if(icon != self)
                {
                        [icon resetPosition ];
                }
            }
            
            
                CGPoint prevPos = self.position;
                _oldPosition=self.position;
                SKAction *horizontal = [SKAction moveToX:300 duration:0.1];
                SKAction *vertical = [SKAction moveToY:260 duration:0.4];
                NSTimeInterval wainttime = 0.3;
                if (self.myOptions.selectedIconGhostNumber==-1){
                    wainttime=0.0;
                }
                SKAction *horizontalAndVertical = [SKAction sequence:@[[SKAction waitForDuration:wainttime],horizontal,vertical]];
                
                self.myOptions.isAnimationRuning = true;
                [self runAction:horizontalAndVertical completion:^{[self.myOptions savePrevPosition:prevPos WithSelectedIcon:self];}];
            
                
            
            self.myOptions.myLocomotiv.selectedGhost = self.ghostFromGhostBar;
        }
    }
}
@end
