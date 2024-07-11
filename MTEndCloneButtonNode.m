//
//  MTEndCloneButtonNode.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 16.04.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import "MTEndCloneButtonNode.h"
#import "MTViewController.h"
#import "MTSceneAreaNode.h"
#import "MTGhostsBarNode.h"

@implementation MTEndCloneButtonNode
-(id)init{
    self=[super initWithImageNamed:@"cloneEnd"];
    if(self){
        
    }
    return self;
}

-(void) destroyMe
{
    MTSceneAreaNode *san = (MTSceneAreaNode *)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTSceneAreaNode"];
    
    [san setAddOneCloneMode:false];
    [san setAddMultiCloneMode:false];
    [san setEndCloneButtonExists:false];
    
    [(MTGhostsBarNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTGhostsBarNode"] showBar];
    
    [self runAction:[SKAction sequence:@[
                                         [SKAction fadeAlphaTo:0.0 duration:0.3],
                                         [SKAction removeFromParent]
                                         ]]];
}

-(void)tapGesture:(UIGestureRecognizer *)g{

    [self destroyMe];
}

@end
