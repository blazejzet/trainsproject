//
//  MTCodeTabNode.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 03.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTCodeTabNode.h"
#import "MTCodeAreaNode.h"
#import "MTGUI.h"

@implementation MTCodeTabNode

static MTCodeTabNode *selectedTab;

+(MTCodeTabNode *) getSelectedTab
{
    return selectedTab;
}

+(void) resetSelectedPointer
{
    selectedTab = nil;
}

-(void) tapGesture:(UIGestureRecognizer *)g
{
    [self makeMeSelected];
}

-(void) makeMeSelected
{
    if (selectedTab)
    {
        [selectedTab makeMeDeselected];
    }
    selectedTab = self;
    
    //wstawienie obrazka
    /*NSString * image;
    
    if (self.tabNumber < CLONE_TAB)
    {
        image = @"selectedCodeTab";
        
    } else {
        
        image = @"selectedCloneCodeTab";
    }
    
    SKTexture *texture = [SKTexture textureWithImageNamed:image];
    [self setTexture: texture];*/
 
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Tab"
                                                        object:self ];
}
-(void) makeMeDeselected
{
    selectedTab = nil;
    
    //wstawienie obrazka
    /*NSString * image;
    
    if (self.tabNumber < CLONE_TAB)
    {
        image = @"codeTab";
        
    } else {
        
        image = @"cloneCodeTab";
    }
    
    SKTexture *texture = [SKTexture textureWithImageNamed:image];
    [self setTexture: texture];*/
}
@end
