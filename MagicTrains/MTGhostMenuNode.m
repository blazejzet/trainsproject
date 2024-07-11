//
//  MTGhostMenuNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 16.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTGhostMenuNode.h"
#import "MTGhostMenuHpButtonNode.h"
#import "MTGhostMenuCloneAddButtonNode.h"
#import "MTGhostMenuCloneRemoveButtonNode.h"
#import "MTGhostMenuCloneAddOneButtonNode.h"
#import "MTGhostMenuCloneAddMultiButtonNode.h"
#import "MTGhostsBarNode.h"
#import "MTCancelButtonNode.h"
#import "MTSceneAreaNode.h"
#import "MTGhostIconNode.h"
#import "MTStorage.h"
#import "MTGhostMenuPickerNode.h"
#import "MTGhost.h"
#import "MTGUI.h"

#import "MTGhostMenuIconNode.h"
#import "MTGhostMenuPickerVariantsNode.h"
#import "MTGhostMenuPickerElementNode.h"
#import "MTGhostInstance.h"

#import "MTWindowAlert.h"
#import "MTBlockingBackground.h"

@implementation MTGhostMenuNode
-(id) init {
    if ((self = [super initWithImageNamed:@"ghostMenuBG.png"]))
    {
        self.name = @"MTGhostMenuNode";
        self.size = CGSizeMake(1024, 768);
        self.alpha = 1.0;
        self.anchorPoint = CGPointMake(0.5, 0.5);
        //self.position = CGPointMake(100,40);
        self.isVariantActionRunning = false;
        //self.color = [UIColor redColor];
        self.zPosition = 5;
        
        //rozmiar większych przyciskow u góry
        CGSize itemSize = CGSizeMake(self.size.width/3, 150);
        
        ///Inicjalizacja przyciskow
        //hpNode
        MTGhostMenuHpButtonNode *hpButton = [[MTGhostMenuHpButtonNode alloc] init];
        hpButton.size = CGSizeMake(itemSize.width, itemSize.height);
        hpButton.anchorPoint = CGPointMake(0, 1);
        //hpButton.color = [UIColor blueColor];
        hpButton.position = CGPointMake(-(self.size.width/2), +(self.size.height/2));
        [self addChild:hpButton];
        
        //cloneMenuNode
        MTGhostMenuCloneAddButtonNode *cloneAddButton = [[MTGhostMenuCloneAddButtonNode alloc] init];
        cloneAddButton.size = CGSizeMake(itemSize.width, itemSize.height);
        cloneAddButton.anchorPoint = CGPointMake(0, 1);
        cloneAddButton.color = [UIColor greenColor];
        cloneAddButton.position = CGPointMake(-(self.size.width/2)+itemSize.width, +(self.size.height/2));
        [self addChild:cloneAddButton];
        
        //deleteCloneNode
        MTGhostMenuCloneRemoveButtonNode *cloneRemoveButton = [[MTGhostMenuCloneRemoveButtonNode alloc] init];
        cloneRemoveButton.size = CGSizeMake(itemSize.width, itemSize.height);
        cloneRemoveButton.anchorPoint = CGPointMake(0, 1);
        cloneRemoveButton.color = [UIColor yellowColor];
        cloneRemoveButton.position = CGPointMake(-(self.size.width/2)+itemSize.width*2, +(self.size.height/2));
        [self addChild:cloneRemoveButton];
        
        ///Inicjalizacja przyciskow KONIEC
        
        self.currentGhost = [MTGhostIconNode getSelectedIconNode].myGhost;
        
        MTGhostMenuPickerNode *pickerGhost = [[MTGhostMenuPickerNode alloc] initWithCurrentGhost: self.currentGhost];
        self.picker = pickerGhost;
        
        pickerGhost.anchorPoint = CGPointMake(0, 1);
        [self addChild:pickerGhost];
        
        [pickerGhost initVariantsWithAlpha:1.0];
        pickerGhost.position = CGPointMake(pickerGhost.position.x-pickerGhost.size.width/2, pickerGhost.position.y);
        
        SKAction *act = [SKAction moveByX:pickerGhost.size.width/2 y:0.0 duration:0.7];
        
        [pickerGhost runAction:act completion:^{[pickerGhost addCenterGhostAnimation];}];
        
        for(int i = 0; i < pickerGhost.variantsElements.count; i++)
        {
            CGPoint pos = ((MTGhostMenuPickerVariantsNode*)pickerGhost.variantsElements[i]).position;
            ((MTGhostMenuPickerVariantsNode*)pickerGhost.variantsElements[i]).position = CGPointMake(pos.x-1024, pos.y);
            
            SKAction *act = [SKAction moveByX:1024 y:0.0 duration:0.7];
            [((MTGhostMenuPickerVariantsNode*)pickerGhost.variantsElements[i]) runAction: act];
        }
    }
    
    return self;
}

-(void) removeGhostVariantAnimationBlockade
{
    self.isVariantActionRunning = false;
}

-(void) addGhostIcons
{
    MTGhostsBarNode *ghostBar = ((MTGhostsBarNode *)[(SKNode *)self.scene.children[0] childNodeWithName:@"MTGhostsBarNode"]);
    MTGhostIconNode *selectedIcon = [MTGhostIconNode getSelectedIconNode];
    
    for(int i = 0; i < ghostBar.icons.count; i++)
    {
        MTGhost *ghostFromGhostBar = (MTGhost*)((MTGhostIconNode*)ghostBar.icons[i]).myGhost;
        SKTexture *texture = ((MTGhostIconNode*)ghostBar.icons[i]).texture;
        MTGhostMenuIconNode *icon = [[MTGhostMenuIconNode alloc] initWithTexture:texture andGhost:ghostFromGhostBar];
        //icon.textureName = ((MTGhostIconNode*)ghostBar.icons[i]).textureName;
        icon.position = CGPointMake(-346.5+(i*77), -310.5);
        [self addChild:icon];
        
        if(ghostBar.icons[i] == selectedIcon)
        {
            self.currentGhostIcon = icon;
        }
    }
}

-(void) addInstanceOptions
{
    MTGhostMenuCloneAddButtonNode *cloneButton = (MTGhostMenuCloneAddButtonNode *)[self childNodeWithName:@"MTGhostMenuCloneAddButtonNode"];
    
    MTGhostMenuCloneAddOneButtonNode *addOneButton = [[MTGhostMenuCloneAddOneButtonNode alloc] init];
    MTGhostMenuCloneAddMultiButtonNode *addMultiButton = [[MTGhostMenuCloneAddMultiButtonNode alloc] init];
    
    addOneButton.size = CGSizeMake(cloneButton.size.width/2, cloneButton.size.height);
    addMultiButton.size = CGSizeMake(cloneButton.size.width/2, cloneButton.size.height);
    addOneButton.position = cloneButton.position;
    addMultiButton.position = CGPointMake(cloneButton.position.x+cloneButton.size.width/2, cloneButton.position.y);
    
    [cloneButton removeFromParent];
    [self addChild:addOneButton];
    [self addChild:addMultiButton];
}

-(void) accept
{
    [(MTSceneAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] menuModeOff];
    [(MTGhostsBarNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTGhostsBarNode"] showBar];
    [self removeFromParent];
}
-(void) cancel
{
    [(MTSceneAreaNode *)[[(SKNode *)self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] menuModeOff];
    [(MTGhostsBarNode *)[[(SKNode *)self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTGhostsBarNode"] showBar];
    [self removeFromParent];
}

-(void) addOneInstance
{
    [(MTGhostsBarNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTGhostsBarNode"] hideBar];
    [(MTSceneAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] menuModeOff];
    [(MTSceneAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] addOneCloneModeOn];
    [self removeFromParent];
}

-(void) addMultiInstace
{
    [(MTGhostsBarNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTGhostsBarNode"] hideBar];
    [(MTSceneAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] menuModeOff];
    [(MTSceneAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] addMultiCloneModeOn];
    [self removeFromParent];
}

-(void) deleteAllInstances
{
    [(MTSceneAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] menuModeOff];
    
    //okienko usuwania
    MTBlockingBackground *background = [[MTBlockingBackground alloc] initFullBackgroundWithDuration:1.0 Color:[UIColor blackColor] Alpha:0.3 andWaitTime:0.0];
    MTWindowAlert *alert = [[MTWindowAlert alloc] initRemoveAllClones];
    alert.background = background;
    [((MTSceneAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"]) addChild:alert];
    
    [self removeFromParent];
}

-(void) saveChangesWithVariant:(MTGhostMenuPickerVariantsNode*)variant
{
    NSArray *nodes = [[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] nodesAtPoint:CGPointMake(0, 0)];
    MTGhostMenuPickerElementNode *center = nodes[nodes.count-1];
    
    MTGhostMenuPickerElementNode* ghostCategory = center;
    
    //////NSLog(@"ghostCategory.position.y %f", ghostCategory.position.y);
    
    NSString *selectedGhostVariant = variant.costumeName;
    MTStorage *storage = [MTStorage getInstance];
    
    MTGhostIconNode *selectedIcon = [self findGhostIconForGhostMenuIcon:self.currentGhostIcon];
    MTGhost *selectedGhost = self.currentGhost;
    
    
    if([ghostCategory isKindOfClass:[MTGhostMenuPickerElementNode class]])
    {
        for(id key in storage.ghostCostumes)
        {
            if(key == ghostCategory.imgName)
                selectedGhost.costumeCat = key;
        }
        
        selectedGhost.costumeName =
        selectedGhostVariant;
        
        [selectedIcon repaintIcon:selectedGhostVariant];
        [self.currentGhostIcon repaintIcon:selectedGhostVariant];
        
        MTSceneAreaNode *sceneAreaNode = (MTSceneAreaNode*)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"];
        
        for(int i = 0; i < selectedGhost.ghostInstances.count; i++){
            MTGhostInstance* mtgi = selectedGhost.ghostInstances[i];
            mtgi.costumeName=selectedGhostVariant;
            [sceneAreaNode refreshRepresentationNodeOfGhostInstance:mtgi];
             }
    }
    
    
}

-(MTGhostIconNode *) findGhostIconForGhostMenuIcon:(MTGhostMenuIconNode*) menuIcon
{
    MTGhostsBarNode *ghostBar = ((MTGhostsBarNode *)[(SKNode *)self.scene.children[0] childNodeWithName:@"MTGhostsBarNode"]);
    NSArray *icons = ghostBar.icons;
    
    for(int i =0; i < icons.count; i++)
    {
        if(((MTGhostIconNode*)icons[i]).myGhost == menuIcon.myGhost)
        {
            return (MTGhostIconNode*)icons[i];
        }
    }
    
    return nil;
}

-(void)pinchGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    if(!self.picker.animation)
    {
        UIPinchGestureRecognizer *sender =(UIPinchGestureRecognizer *)g;
        
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            self.lastPinchValue = 1.0;
            NSArray *children =  self.picker.children;
     
            for(int i = 0; i < children.count; i++)
            {
                if((MTGhostMenuPickerElementNode *)children[i] == self.picker.lastElement)
                {
                    self.picker.centerIndex = i;
                    break;
                }
            }
            
            [self.picker hideOrUnhideRestPicker:@"HIDE"];

        }
        
        if(((UIPinchGestureRecognizer *)g).scale <= 1)
        {
            self.xScale = ((UIPinchGestureRecognizer *)g).scale;
            self.yScale = ((UIPinchGestureRecognizer *)g).scale;
            self.alpha = ((UIPinchGestureRecognizer *)g).scale;
        }
        
        if (g.state == UIGestureRecognizerStateEnded)
        {
            if(sender.velocity < 0)
            {
                SKAction *act = [SKAction scaleTo:0 duration:0.15];
                [self runAction:act completion:^{[self destoryMe];}];
                [self runAction:act];
            }
            else
            {
                self.xScale = 1;
                self.yScale = 1;
                self.alpha = 1;
               [self.picker hideOrUnhideRestPicker:@"SHOW"];
            }
        }
    }
}

-(void) destoryMe
{
    [self removeFromParent];
}

-(void) changeGhostIconInGhostBar:(MTGhostMenuIconNode *)menuIcon
{
    MTGhostIconNode *selectedGhost = [self findGhostIconForGhostMenuIcon:menuIcon];
    [selectedGhost makeMeSelected];
}

@end
