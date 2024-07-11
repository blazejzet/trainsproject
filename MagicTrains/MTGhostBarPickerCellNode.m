//
//  MTGhostBarPickerCellNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 18.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTGhostBarPickerCellNode.h"
#import "MTGhostBarPickerNode.h"

@implementation MTGhostBarPickerCellNode

-(id) initWithNode:(MTSpriteNode *) node
{
    self = [super init];
    self.texture = node.texture;
    self.name = @"pickerCell";
    
    return self;
}

-(void) panGesture:(UIGestureRecognizer *)g :(UIView *)v
{
    [(MTGhostBarPickerNode *)self.parent panGesture:g :v];
}


@end
