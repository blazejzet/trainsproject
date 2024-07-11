///
//  MTGhostMenuPickerNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 26.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTGhostMenuPickerNode.h"
#import "MTCategoryBarNode.h"
#import "MTGhostIconNode.h"
#import "MTGhostMenuPickerElementNode.h"
#import "MTGhostMenuHpBarNode.h"
#import "MTGhostMenuPickerVariantsNode.h"
#import "MTStorage.h"
#import "MTGhostMenuNode.h"
#import "MTGhostMenuHpButtonNode.h"
#import "MTGhost.h"

@implementation MTGhostMenuPickerNode
static float startPos = 0;
static int centerGhostIndex;
static float lastX = 0;
static float currPos = 0;
static float blockPositionXBegan;
static float blockPositionXEnded;
static int ghostCount;

-(id) initWithCurrentGhost:(MTGhost *)currentG {
    if ((self = [super init]))
    {
        self.name = @"MTGhostMenuPickerNode";
        MTStorage *storage = [MTStorage getInstance];
        int elSize = storage.ghostCostumes.count;
        int elementsInPicker = 75;
        float sizeX = elementsInPicker*114*elSize;
        self.pickersElements = [[NSMutableArray alloc] init];
        self.ringPickersElements = [[NSMutableArray alloc] init];
        //self.ringPickersElements2 = [[NSMutableArray alloc] init];
        self.variantsElements = [[NSMutableArray alloc] init];
        self.anchorPoint = CGPointMake(0.5, 0);
        self.size = CGSizeMake(sizeX, 112);
        self.position = CGPointMake(-(sizeX/2)+7.5, 70);
        

        NSString *currentGhostCostume = currentG.costumeCat;
        int currentGhostNumber;
        int centerGhostCat;
        int i = 0;
        for(id key in storage.ghostCostumes)
        {
            NSString *costumeName = key;
            CGPoint position = CGPointMake((112*i)+(2*i), 0);
            MTGhostMenuPickerElementNode *costume = [[MTGhostMenuPickerElementNode alloc] initWithPosition:position AndCostume:costumeName AndNumber:i+1];
            costume.name = costumeName;
            
            if([currentGhostCostume isEqualToString: costumeName])
            {
                currentGhostNumber = i;
            }
            [self.ringPickersElements addObject:costume];
            [self addChild:costume];
            i++;
        }
        
        
        int lastI = i;
        
        self.currentGhostCostumeCat = [MTGhostIconNode getSelectedIconNode].myGhost.costumeCat;
        centerGhostCat = (self.ringPickersElements.count/2);
        
        ///Zapelnienie pickera elementami
        int j=0;
        while(j < elementsInPicker-1)
        {
            for(int i = 0; i < self.ringPickersElements.count; i++)
            {
                NSString *costumeName = ((MTGhostMenuPickerElementNode*)self.ringPickersElements[i]).imgName;
                
                CGPoint position = CGPointMake((112*lastI)+(2*lastI), 0);
                MTGhostMenuPickerElementNode *costume = [[MTGhostMenuPickerElementNode alloc] initWithPosition:position AndCostume:costumeName AndNumber:i];
                costume.name = costumeName;
                [self addChild:costume];
                
                lastI++;
            }
            j++;
        }
        ///Ustawianie pozycji pickera
        
        if((int)(self.ringPickersElements.count*elementsInPicker)%2!=0){}
        else
        {
            centerGhostIndex = (int)(self.ringPickersElements.count/2);
            self.position = CGPointMake(self.position.x + 56, self.position.y);
        }
        
        if(self.ringPickersElements.count%2 == 0)
        {
            centerGhostCat = centerGhostCat-1;
        }
        
        if(self.ringPickersElements.count%2!=0 && elementsInPicker%2==0)
        {
            self.position = CGPointMake(self.position.x-(114*(currentGhostNumber+1)), self.position.y);
        }
        else if(self.ringPickersElements.count%2!=0 && elementsInPicker%2!=0)
        {
            self.position = CGPointMake(self.position.x+((self.ringPickersElements.count/2)*114)-(114*currentGhostNumber), self.position.y);
        }
        else if(self.ringPickersElements.count%2==0 && elementsInPicker%2==0)
        {
            self.position = CGPointMake(self.position.x-(114*(currentGhostNumber+1)), self.position.y);
        }
        else if(self.ringPickersElements.count%2==0 && elementsInPicker%2!=0)
        {
            self.position = CGPointMake(self.position.x+(((self.ringPickersElements.count/2)-1)*114)-(114*currentGhostNumber), self.position.y);
        }
        
        blockPositionXBegan=blockPositionXEnded=self.position.x;
    }
    
    NSArray *nodes = [[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] nodesAtPoint:CGPointMake(0, 0)];
    self.lastElement = nodes[nodes.count-1];
    
    nodes = [[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] nodesAtPoint:CGPointMake(0, -175)];
    self.lastVariant = nodes[nodes.count-1];
    
    return self;
}

-(void) changeGhost:(MTGhost *)ghost
{
    MTGhost *currentGhost = ghost;
    MTGhostMenuNode *menu = (MTGhostMenuNode*)self.parent;
    menu.currentGhost = ghost;
    NSString *currentGhostCostume = currentGhost.costumeCat;
    
    MTGhostMenuHpButtonNode *button = self.parent.children[0];
    MTGhostMenuHpBarNode *hpBar = button.children[0];
    [hpBar refreshBar];
    
    NSArray *nodesInCenter = [[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] nodesAtPoint:CGPointMake(0, 0)];
    if([nodesInCenter[nodesInCenter.count-1] isKindOfClass:[MTGhostMenuPickerElementNode class]])
    {
        MTGhostMenuPickerElementNode *center = nodesInCenter[nodesInCenter.count-1];
        int ghostNumber = center.myNumber;
        self.currentGhostCostumeCat = ghost.costumeCat;
        BOOL turnLeft = false;
        BOOL turnRight = false;
        int leftSteps=0;
        int rightSteps=0;
        int i = ghostNumber;
        while(true)
        {
            leftSteps++;
            NSString *left = ((MTGhostMenuPickerElementNode*)self.ringPickersElements[i]).imgName;
            if([left isEqualToString: currentGhostCostume]) break;
            if(i == 0) {i = self.ringPickersElements.count;}
            i--;
        }
        
        i = ghostNumber;
        while(true)
        {
            rightSteps++;
            NSString *right = ((MTGhostMenuPickerElementNode*)self.ringPickersElements[i]).imgName;
            if([right isEqualToString: currentGhostCostume]) break;
            i++;
            if(i == self.ringPickersElements.count) {i = 0;}
        }
        
        if(leftSteps < rightSteps) {turnLeft=true; turnRight=false;}
        else {turnRight=true; turnLeft=false;}
        
        MTGhostMenuNode *menu = (MTGhostMenuNode*)self.parent;
        menu.isGhostPickerCenterActionRunning = true;
        
        if(turnLeft == true)
        {
            if(leftSteps > 1) leftSteps--;
            else leftSteps=0;
            float step2 = leftSteps*114;
            SKAction *act = [SKAction moveByX:step2 y:0.0 duration:0.4];
            [self runAction:act completion:^{[self addCenterGhostAnimation];}];
            blockPositionXEnded = self.position.x+step2;
        }
        else
        {
            if(rightSteps > 1) rightSteps--;
            else rightSteps=0;
            float step2 = rightSteps*114;
            SKAction *act = [SKAction moveByX:-step2 y:0.0 duration:0.4];
            [self runAction:act completion:^{[self addCenterGhostAnimation];}];
            blockPositionXEnded = self.position.x-step2;
        }
        
       self.animation = true;

        for(int i = 0; i < self.variantsElements.count; i++)
        {
            SKAction *act = [SKAction fadeAlphaTo:0 duration:0.5];
            [((MTGhostMenuPickerVariantsNode*)self.variantsElements[i]) runAction: act];
        }
        
        [self initVariantsWithAlpha:0.0];
        for(int i = 0; i < self.variantsElements.count; i++)
        {
            SKAction *act = [SKAction fadeAlphaTo:1.0 duration:0.5];
            [((MTGhostMenuPickerVariantsNode*)self.variantsElements[i]) runAction: act];
        }
    }
}

-(void) changeGhostFromTapGesture:(MTGhostMenuPickerElementNode *)element
{
    if(!self.animation)
    {
        NSArray *nodes = [[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] nodesAtPoint:CGPointMake(0, 0)];
        MTGhostMenuPickerVariantsNode *center = nodes[nodes.count-1];

        float diff = abs(element.position.x-center.position.x);
        SKAction *act;
        
        if(element.position.x < center.position.x)
            act = [SKAction moveByX:diff y:0.0 duration:0.3];
        else
            act = [SKAction moveByX:-diff y:0.0 duration:0.3];
        
        [self removeCenterGhostAnimation];
        [self runAction:act completion:^{[self saveChangesWhenAnimationIsOver];}];
        
        self.animation = true;
    }
}

-(void)panGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    if(g.state == UIGestureRecognizerStateBegan)
    {
        float selfX = self.position.x;
        if(selfX >= (blockPositionXEnded-0.05) && selfX <=blockPositionXEnded+0.05)
        {
            [self removeCenterGhostAnimation];
            self.animation = false;
            startPos = self.position.x;
            currPos = self.position.x;
            lastX = self.position.x;
            ghostCount = 0;
            blockPositionXBegan = self.position.x;
        }
    }

    if(self.animation==false)
    {
        self.position = [self newPositionHorizontallyWithGesture:g inView:v inReferenceTo:self.parent];
        [self updateGhostPicker];
        
        if(g.state == UIGestureRecognizerStateEnded)
        {
            self.position = CGPointMake(roundf(self.position.x), self.position.y);
            float moveCheck = ((self.position.x - startPos));
            float rest = ((int)moveCheck % 114);
            float x;
            
            // ROZNICA PO PRZECINKU DO PRAWIDLOWEGO DOPASOWANIA DUSZKA
            int a = (int)moveCheck/114;
            float b = moveCheck-(114*a);
            
            rest=b;
            
            if (-57.0f < rest && rest < 57.0f)
            {
                x = -rest;
            }
            else
            {
                if (rest > 0)
                {
                    x = (114 - rest);
                }
                else
                {
                    x = (-114 - rest);
                }
            }
            
            
            blockPositionXEnded = self.position.x+x;
            SKAction *act = [SKAction moveByX:x y:0.0 duration:0.12];
            [self runAction:act completion:^{[self saveChangesWhenAnimationIsOver];}];
        }
    }
}

-(void) updateGhostPicker
{
    NSArray *elements = [[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] nodesAtPoint:CGPointMake(0, 0)];
    MTGhostMenuPickerElementNode *element = NULL;
    
    if([elements[elements.count-1] class] == [MTGhostMenuPickerElementNode class])
    {
        element = elements[elements.count-1];
        if(1==1)
        {
            self.currentGhostCostumeCat = element.imgName;
        }
    }
}

-(void) showVariants
{
    [self initVariantsWithAlpha:0.0];
    for(int i = 0; i < self.variantsElements.count; i++)
    {
        SKAction *act = [SKAction fadeAlphaTo:1.0 duration:0.5];
        [((MTGhostMenuPickerVariantsNode*)self.variantsElements[i]) runAction: act];
    }
}

-(void) unshowVariants
{
    //[self initVariantsWithAlpha:0.0];
    for(int i = 0; i < self.variantsElements.count; i++)
    {
        SKAction *act = [SKAction fadeAlphaTo:0 duration:0.5];
        [((MTGhostMenuPickerVariantsNode*)self.variantsElements[i]) runAction: act];
    }
}

-(void) addCenterGhostAnimation
{
    NSArray *nodes;

    MTGhostMenuPickerVariantsNode *node = nodes[nodes.count-1];
    
    nodes = [[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] nodesAtPoint:CGPointMake(0, 0)];
    node = nodes[nodes.count-1];
    self.lastElement = (MTGhostMenuPickerElementNode *) node;
    
    if([node isKindOfClass:[MTGhostMenuPickerElementNode class]])
    {
        SKAction *centerNodesUpAction = [SKAction moveByX:0 y:12.5 duration:0.5];
        SKAction *centerNodesDownAction = [SKAction moveByX:0 y:-12.5 duration:0.4];
        SKAction *centerUpAndDownAction = [SKAction sequence:@[centerNodesUpAction,centerNodesDownAction]];
        SKAction *movingUpAndDownCenterGhostAction = [SKAction repeatActionForever:centerUpAndDownAction];
        [node runAction:movingUpAndDownCenterGhostAction];
    }
    
    MTGhostMenuNode *menu = (MTGhostMenuNode*)self.parent;
    menu.isGhostPickerCenterActionRunning = false;
}

-(void) removeCenterGhostAnimation
{
    
    NSArray *nodes = [[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] nodesAtPoint:CGPointMake(0, 0)];
    MTGhostMenuPickerVariantsNode *center = nodes[nodes.count-1];
    
    if([center isKindOfClass:[MTGhostMenuPickerElementNode class]])
    {
        [center removeAllActions];
        SKAction *toInitPositionAnimation = [SKAction moveTo:CGPointMake(center.position.x, 0) duration:0.2];
        [center runAction:toInitPositionAnimation];
    }
}

-(void) saveChangesWhenAnimationIsOver
{
    NSArray *elements = [[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] nodesAtPoint:CGPointMake(0, 0)];
    MTGhostMenuPickerElementNode *element = NULL;
    
    if([elements[elements.count-1] class] == [MTGhostMenuPickerElementNode class])
    {
        element = elements[elements.count-1];
        
        self.currentGhostCostumeCat = element.imgName;
    }
    if([element isKindOfClass:[MTGhostMenuPickerElementNode class]])
    {
        [self unshowVariants];
        [self showVariants];
        NSArray *nodesInCenter = [[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] nodesAtPoint:CGPointMake(0, -175)];
        MTGhostMenuPickerVariantsNode *center = nodesInCenter[nodesInCenter.count-1];
        self.lastVariant = center;
        
        MTGhostMenuNode *menu = (MTGhostMenuNode*)self.parent;
        [menu saveChangesWithVariant:center];

        [self.lastElement removeAllActions];
        SKAction *toInitPositionAnimation = [SKAction moveTo:CGPointMake(self.lastElement.position.x, 0) duration:0.2];
        [self.lastElement runAction:toInitPositionAnimation];
        
        //[self removeCenterGhostAnimation];
        [self addCenterGhostAnimation];
        //[self updateGhostPicker];
        
        self.animation = false;
    }
}

-(void)pinchGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    [((MTGhostMenuNode*)self.parent) pinchGesture:g :v];
}

-(void) initVariantsWithAlpha:(CGFloat)alpha
{
    self.variantsElements = [[NSMutableArray alloc] init];
    
    MTStorage *storage = [MTStorage getInstance];
    
    NSMutableArray *ghostVariants = [storage.ghostCostumes objectForKey:self.currentGhostCostumeCat];
    
    self.variantsElements = [[NSMutableArray alloc]init];
    
    MTGhostMenuNode *menu = (MTGhostMenuNode*)self.parent;
    
    for(int i = 0; i < ghostVariants.count; i++)
    {
        CGPoint position = CGPointMake(-512+((112*i)+(2*i))+6, -195);
        MTGhostMenuPickerVariantsNode *ghostVariantElement = [[MTGhostMenuPickerVariantsNode alloc] initWithPosition:position andCostume:ghostVariants[i]];
        ghostVariantElement.alpha = alpha;
        
        [self.variantsElements addObject:ghostVariantElement];
        [menu addChild:ghostVariantElement];
    }
    
    [self centerGhostCostume:ghostVariants];
}

-(void) centerGhostCostume:(NSArray *)ghostVariants
{
    MTGhostMenuNode *menu = (MTGhostMenuNode*)self.parent;
    NSString *currentGhostCostume = menu.currentGhost.costumeName;
    if(currentGhostCostume == nil)
    {
        currentGhostCostume = [MTGhostIconNode getSelectedIconNode].myGhost.costumeName;
    }
    
    
    MTGhostMenuPickerVariantsNode *center = self.variantsElements[4];
    CGPoint centerPosTmp = center.position;
    
    for(int i = 0; i < ghostVariants.count; i++)
    {
        if(ghostVariants[i] == currentGhostCostume) {
            center.position = ((MTGhostMenuPickerVariantsNode*)self.variantsElements[i]).position;
            ((MTGhostMenuPickerVariantsNode*)self.variantsElements[i]).position = centerPosTmp;
        }
    }
}

-(void) hideOrUnhideRestPicker:(NSString *)op
{
    NSArray *children =  self.children;
    
    for(int i = 0; i < self.centerIndex-4; i++)
    {
        MTGhostMenuPickerElementNode * n = (MTGhostMenuPickerElementNode *)children[i];
        if([op isEqualToString:@"HIDE"])
            n.alpha = 0.0;
        else
            n.alpha = 1.0;
    }
    
    for(int i = self.centerIndex+5; i < children.count; i++)
    {
        MTGhostMenuPickerElementNode * n = (MTGhostMenuPickerElementNode *)children[i];
        if([op isEqualToString:@"HIDE"])
            n.alpha = 0.0;
        else
            n.alpha = 1.0;
    }
    
}

@end
