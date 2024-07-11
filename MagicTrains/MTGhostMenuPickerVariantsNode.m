//
//  MTGhostMenuPickerVariantsNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 29.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTGhostMenuPickerVariantsNode.h"
#import "MTGhostMenuPickerElementNode.h"
#import "MTGhostMenuPickerNode.h"
#import "MTStorage.h"
#import "MTGhostMenuNode.h"

@implementation MTGhostMenuPickerVariantsNode

-(id) initWithPosition:(CGPoint)point andCostume:(NSString*)costume {
    if ((self = [super initWithImageNamed:costume]))
    {
        self.costumeName = costume;
        self.name = @"MTGhostMenuPickerVariantsNode";
        self.anchorPoint = CGPointMake(0, 0);
        self.size = CGSizeMake(100, 100);
        self.position = point;
    }
    
    return self;
}

-(void) tapGesture:(UIGestureRecognizer *)g
{
    MTGhostMenuNode *menu = (MTGhostMenuNode*)self.parent;
    
    if(menu.isVariantActionRunning == false)
    {
        NSArray *nodesInCenter = [[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] nodesAtPoint:CGPointMake(0, -175)];
        MTGhostMenuPickerVariantsNode *center = nodesInCenter[nodesInCenter.count-1];
        CGPoint tmp = center.position;
        
        self.zPosition = 1;
        center.zPosition = 0;
        
        MTGhostMenuNode *menu = (MTGhostMenuNode*)self.parent;
        
        SKAction *act = [SKAction moveToX:tmp.x duration:0.8];
        SKAction *act2 = [SKAction moveToX:self.position.x duration:0.8];
    
        menu.isVariantActionRunning = true;
        [self runAction:act completion:^{[menu removeGhostVariantAnimationBlockade];}];
        [center runAction:act2 completion:^{[menu removeGhostVariantAnimationBlockade];}];
        
        [menu saveChangesWithVariant:self];
    }
}

-(void)pinchGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    [((MTGhostMenuNode*)self.parent) pinchGesture:g :v];
}

@end
