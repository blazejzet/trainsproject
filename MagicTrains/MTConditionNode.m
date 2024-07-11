//
//  MTConditionNode.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 27.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTConditionNode.h"
#import "MTConditionPanel.h"
//#import "MTIfCartOptions.h"

@implementation MTConditionNode
@synthesize checked;

-(id)initWithImageNamed:(NSString*)s{
    self = [super initWithImageNamed:s];
    return self;
}
-(void) prepareWithImageNamed:(NSString *)name position: (CGPoint)position andParent:(NSObject*)myParent{
    
    self.anchorPoint = CGPointMake(0.5, 0.5);
    self.size = CGSizeMake(80, 80);
    self.position = CGPointMake(position.x, position.y);
    self.myParent = myParent;
    
}
-(void)setChecked:(BOOL)aChecked
{
    if (aChecked)
    {
        self.alpha = 1;
    }
    else
    {
        self.alpha = 0.3;
    }
    checked = aChecked;
}
-(void)tapGesture:(UIGestureRecognizer *)g
{
    if ([((MTConditionPanel*)self.myParent) amountCheckedConditions] != 1)
    {
        [((MTConditionPanel*)self.myParent) uncheckConditions];
    }
    [self setChecked: YES];
}

@end
