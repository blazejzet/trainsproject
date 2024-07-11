//
//  MTGlobalVarForSet.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 28.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTGlobalVarForSetNode.h"
#import "MTVariableOneChoicePanel.h"
#import "MTShowGlobalVarOptions.h"
#import "MTGUI.h"
#import "MTNotSandboxProjectOrganizer.h"

@implementation MTGlobalVarForSetNode
@synthesize checked;
-(id) prepareWithNumberGlobalVariable: (uint)numberGlobalVariable Image :(NSString*)image position: (CGPoint)position andParent:(NSObject*)myParent kindOfGlobalVar: (NSString*) kind size: (CGSize) size{

    self.anchorPoint = CGPointMake(0.5, 0.5);
    self.texture = [SKTexture textureWithImageNamed:image];
    self.size = size;
    self.name = @"MTGlobalVarSet";
    self.position = position;
    self.myParent = myParent;
    self.kind = kind;
    self.positionBackup = self.position;
    
    self.numberGlobalVariable = numberGlobalVariable;

    
    return self;
}

-(void)setChecked: (BOOL)aChecked
{
    if (aChecked)
    {
        [self setAlpha: 1.0];
    }
    else
    {
        [self setAlpha: 0.1];
    }
    checked = aChecked;
}

-(void)tapGesture:(UIGestureRecognizer *)g
{
    if ([[MTNotSandboxProjectOrganizer getInstance] isSelectedTabBlocked]) return;
    
    if ([self.kind  isEqual: @"setGlobal"])
    {
        if(self.checked == YES)
        {
            self.checked = NO;
            ((MTVariableOneChoicePanel*)self.myParent).numberSelectedVariableForSet = 0;
        }
        else
        {
            self.checked = YES;
            ((MTVariableOneChoicePanel*)self.myParent).numberSelectedVariableForSet = self.numberGlobalVariable;
        }
    }
    else if ([self.kind  isEqual: @"showGlobal"])
    {
        if(self.checked == YES)
        {
            self.checked = NO;
        }
        else
        {
            self.checked = YES;
        }
    }
}

-(void) setAlpha:(CGFloat)alpha
{
    [self runAction:[SKAction fadeAlphaTo:alpha duration:0.2]];
}

-(void) removeFromParent
{
    self.position = self.positionBackup;
    [super removeFromParent];
}

@end
