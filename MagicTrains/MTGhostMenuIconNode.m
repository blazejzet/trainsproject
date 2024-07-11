//
//  MTGhostMenuIconNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 06.04.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTGhostMenuIconNode.h"
#import "MTGhostMenuNode.h"
#import "MTGhostMenuPickerNode.h"
#import "MTGhostMenuPickerVariantsNode.h"
#import "MTGhost.h"

@implementation MTGhostMenuIconNode

-(id) initWithTexture:(SKTexture*)texture andGhost:(MTGhost*)ghost {
    if ((self = [super initWithTexture:texture]))
    {
        self.myGhost = ghost;
        self.name = @"MTGhostMenuIconNode";
        self.size = CGSizeMake(75, 75);
    }
    
    return self;
}
-(void) repaintIcon:(NSString*)textureName
{
    self.texture = [SKTexture textureWithImageNamed:textureName];
}

-(void)tapGesture:(UIGestureRecognizer *)g
{
   // MTGhostMenuNode *menu = (MTGhostMenuNode*)self.parent;
    NSArray *elements = [[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode"] nodesAtPoint:CGPointMake(-505, -175)];
    MTGhostMenuPickerVariantsNode *firstVariant = elements[elements.count-1];
    int pos = (int)firstVariant.position.x;
    if(pos == -506 || pos == -506 || pos == -505 || pos == 505)
    {
        MTGhostMenuNode *menu = (MTGhostMenuNode*)self.parent;
        if(menu.isGhostPickerCenterActionRunning == false)
        {
            menu.currentGhostIcon = self;
            [menu changeGhostIconInGhostBar:self];
            [menu.picker changeGhost:self.myGhost];
            [(MTGhostMenuPickerNode*)menu.picker removeCenterGhostAnimation];
        }
    }
}

-(void)pinchGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    [((MTGhostMenuNode*)self.parent) pinchGesture:g :v];
}

@end
