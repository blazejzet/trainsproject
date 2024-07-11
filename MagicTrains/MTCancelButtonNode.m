//
//  MTCancelButtonNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 16.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTCancelButtonNode.h"
#import "MTGhostMenuNode.h"

@implementation MTCancelButtonNode
-(id) initWithDialogName: (NSString *)dialogName {
    if ((self = [super initWithImageNamed:@"cancel.png"]))
    {
        self.anchorPoint = CGPointMake(0, 0);
        self.size = CGSizeMake(50, 50);
        self.dialogName =dialogName;
    }
    
    return self;
}

-(void)tapGesture:(UIGestureRecognizer *)g
{
    if([self.dialogName isEqualToString:@"MTGhostMenuNode"])
    {
        [(MTGhostMenuNode *) self.parent cancel];
    }
    
    if ([self.dialogName isEqualToString:@"MTCategoryBarNode"])
    {
       // [(MTCategoryBarNode *) self.parent hideOptions];
    }
}
@end
