//
//  MTGhostIconNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 27.02.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTGhostIconNode.h"
#import "MTGlowFilter.h"
#import "MTCodeAreaNode.h"
#import "MTGhostsBarNode.h"
#import "MTSceneAreaNode.h"
#import "MTGhostMenuNode.h"
#import "MTMainScene.h"
#import "MTCodeAreaNode.h"
#import "MTStorage.h"
#import "MTGhost.h"
#import "MTGUI.h"
#import "MTExecutor.h"
#import "MTGhostBarPickerNode.h"
#import <QuartzCore/QuartzCore.h>
#import "MTSpriteMoodNode.h"
#import "MTGhostMenuView.h"

@implementation MTGhostIconNode


static MTGhostIconNode *selectedIcon;
static bool isAnimated;

-(void) remove {
    selectedIcon=nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(id) initWithGhost:(MTGhost *)ghost {
    NSString *imgName = ghost.costumeName;
    
    if ((self = [super initWithImageNamed:imgName]))
    {
        
        NSString* dName=[ghost.costumeName substringToIndex:[ghost.costumeName rangeOfString:@"_"].location];
        
        self.name = @"MTGhostIconNode";
        self.size = CGSizeMake(75, 75);

        
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.textureName = imgName;
        self._scale = 0.7;
        self.alpha=0.4;
        
       // [self setMoodState:0];
        [self removeAllActions];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(runSelectedIconAnimation) name:@"MTGhostIconNode RunAnimation" object:nil];
    }
    
    return (id) self;
}


+(MTGhostIconNode *) getSelectedIconNode
{
    
    return selectedIcon;
}

-(void) makeMeSelected
{
    BOOL simulationmode=[[MTExecutor getInstance] simulationStarted];
    if (!simulationmode){
    if (selectedIcon != nil)
    {
        [selectedIcon makeMeUnselected];
    }
    selectedIcon = self;
        self.alpha=1;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedGhostIcon Changed"
                                                        object: self];
    
    [self runSelectedIconAnimation];
    if([(MTMainScene*)self.scene rootPosition] == 1){
        
    }
    
    if( [(MTMainScene*)self.scene rootPosition] == 1
       )
    {
        if (HEIGHT==1024){
            [self showSmallMenuForSelectedGhost];
        }else{
            [self updateMenuForSelectedGhost];
        }
    }
    }
    
}


-(void) makeMeSelectedE
{
    //if(selectedIcon != self){
        if (selectedIcon != nil)
        {
            [selectedIcon makeMeUnselected];
        }
        selectedIcon = self;
    self.alpha=1;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedGhostIcon Changed"
                                                            object: self];
        
        [self runSelectedIconAnimation];
        if([(MTMainScene*)self.scene rootPosition] == 1){
            
        }
    //}
}

-(void) makeMeSelectedX
{
    if (selectedIcon != nil)
    {
        [selectedIcon makeMeUnselected];
    }
    selectedIcon = self;
    self.alpha=1;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedGhostIcon Changed"
                                                        object: self];
    
    [self runSelectedIconAnimation];
}

-(void) makeMeUnselected
{
    selectedIcon = nil;
    self.alpha=0.4;
}
-(void) tapGesture:(UIGestureRecognizer *)g {
   // [self makeMeSelected];
    
    [(MTCodeAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCodeAreaNode"] categoryBarInit];
    [(MTGhostBarPickerNode *)self.parent tapGesture:g WithIcon:self];
}

-(void) panGesture:(UIGestureRecognizer *)g :(UIView *)v{
    [(MTGhostBarPickerNode *)self.parent panGesture:g:v];
}

-(void)holdGesture:(UIGestureRecognizer *)g :(UIView *)v{
    [self hold:g :v];
}
-(void) hold:(UIGestureRecognizer *)g :(UIView *)v
{
    [self makeMeSelectedX];
    [(MTCodeAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCodeAreaNode"] selectFirstTab];
    [(MTCodeAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCodeAreaNode"] categoryBarInit];
    
    //[(MTGhostBarPickerNode *)self.parent tapGesture:nil WithIcon:self];
    
    //pierwszy warunek : jezeli bedzie pokazana scena
    if( [(MTMainScene*)self.scene rootPosition] == 1 &&
       g.state == UIGestureRecognizerStateBegan &&
       !((MTSceneAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"]).menuMode)
    {
        [self showMenuForSelectedGhost];
    }
}

-(void)showMenuForSelectedGhost
{
    /*Wyłączenie dostępu do menu gdy w trybie projekt-nauka*/
    MTStorage *Storage = [MTStorage getInstance];
    
    if (!(Storage.ProjectType == MTProjectTypeLearn || Storage.ProjectType == MTProjectTypeQuest)) {
        
        int ilosc =0;
        for(UIView * u in self.scene.view.superview.subviews){
            if ([u isKindOfClass:[MTGhostMenuView class]]){
                [(MTGhostMenuView*)u removeFromParent];
            }
        }
        MTGhostMenuView * m = [[MTGhostMenuView alloc]initWithGhost:self.myGhost :self];
        [self.scene.view.superview addSubview:m];
        [m show];
    }
}

-(void)updateMenuForSelectedGhost{
    /*Wyłączenie dostępu do menu gdy w trybie projekt-nauka*/
    MTStorage *Storage = [MTStorage getInstance];
    
    if (!(Storage.ProjectType == MTProjectTypeLearn || Storage.ProjectType == MTProjectTypeQuest)) {
        
        int ilosc =0;
        BOOL isShown = false;
        for(UIView * u in self.scene.view.superview.subviews){
            if ([u isKindOfClass:[MTGhostMenuView class]]){
                
                isShown = [(MTGhostMenuView*)u isShown];
                ilosc+=1;
                [(MTGhostMenuView*)u removeFromParent];
            }
        }
        if(ilosc>0 && isShown){
            MTGhostMenuView * m = [[MTGhostMenuView alloc]initWithGhost:self.myGhost :self];
            [self.scene.view.superview addSubview:m];
            [m show];
        }
    }

}
-(void)showSmallMenuForSelectedGhost
{
    /*Wyłączenie dostępu do menu gdy w trybie projekt-nauka*/
    MTStorage *Storage = [MTStorage getInstance];
    
    if (!(Storage.ProjectType == MTProjectTypeLearn || Storage.ProjectType == MTProjectTypeQuest)) {
        
        int ilosc =0;
        [self hideMenuForSelectedGhost];
        MTGhostMenuView * m = [[MTGhostMenuView alloc]initWithGhost:self.myGhost :self];
        [self.scene.view.superview addSubview:m];
        [m showSmall];
    }
}

-(void)hideMenuForSelectedGhost
{
    /*Wyłączenie dostępu do menu gdy w trybie projekt-nauka*/
    MTStorage *Storage = [MTStorage getInstance];
    
    if (!(Storage.ProjectType == MTProjectTypeLearn || Storage.ProjectType == MTProjectTypeQuest)) {
        
        int ilosc =0;
        for(UIView * u in self.scene.view.superview.subviews){
            if ([u isKindOfClass:[MTGhostMenuView class]]){
                [(MTGhostMenuView*)u removeFromParent];
            }
        }
            }
}

-(void) repaintIcon:(NSString *) imgName
{
    self.texture = [SKTexture textureWithImageNamed:imgName];
    self.textureName = imgName;
    
}

-(void) runSelectedIconAnimation
{
   // [[MTGhostIconNode getSelectedIconNode] runAction: [SKAction scaleTo:1.0 duration:0.3]];
}

@end
