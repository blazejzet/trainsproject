//
//  MTPlusButtonNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 27.02.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTPlusButtonNode.h"
#import "MTGhostsBarNode.h"
#import "MTSceneAreaNode.h"
#import "MTStorage.h"
#import "MTGhostRepresentationNode.h"

@implementation MTPlusButtonNode
-(id) init {
    if ((self = [super init]))
    {
        self = [self initWithImageNamed:@"addGhost.png"];
        self.name = @"MTPlusButtonNode";
        self.size = CGSizeMake(75, 75);
        self.anchorPoint = CGPointMake(0, 0);
        self.color = [UIColor grayColor];
        self.blendMode = SKBlendModeScreen;
        self.position = CGPointMake(2.5, 2.5);
        self.isActive = true;
        
    }
    return self;
}
/* obsluga gestu dotkniecia */

-(void) tapGesture:(UIGestureRecognizer *)g {
    
if (self.isActive)
    {
        
        if(((MTSceneAreaNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTSceneAreaNode" ]).menuMode == false)
        {
            if ([((MTGhostsBarNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName: @"MTGhostsBarNode"]) ghostIconQuota] >= MAX_GHOST_COUNT)
            {
                [self childNodeWithName:@"MTPlusButtonNode"].hidden = true;
            }
            else
            {
                /*Odznaczam aktualnie zaznaczona reprezentacje na scenie*/
                [[MTGhostRepresentationNode getSelectedRepresentationNode] makeMeUnselected];
                [((MTGhostsBarNode *) self.parent) addNewGhostIcon];
            }
        }

        /* Wywolanie funkcji z MTGhostBarNode */
    }
}

/* obsluga przesuwania GhostsBarNode na przycisku PLUS */
-(void) panGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    [(MTGhostsBarNode *)self.parent panGestureForGhostIcon:g:v];
}

-(void) makeMeUnActive {
    self.isActive = false;
    self.colorBlendFactor = 1.0;
    self.alpha = 0.5;
}

-(void) makeMeActive {
    self.isActive = true;
    self.colorBlendFactor = 0.0;
    self.alpha = 1.0;
}

@end
