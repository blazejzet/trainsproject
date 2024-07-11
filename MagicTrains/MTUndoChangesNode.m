//
//  MTAcceptButtonNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 16.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTUndoChangesNode.h"
#import "MTWindowAlert.h"

@implementation MTUndoChangesNode

-(id) init{
    if ((self = [super initWithImageNamed:@"windowCancel.png"]))
    {
        //self.anchorPoint = CGPointMake(0, 0);
        self.size = CGSizeMake(50, 50);
        self.color = [UIColor redColor];
        self.colorBlendFactor = 0.8;
        self.blendMode = 1;
    }
    
    return self;
}

-(void)tapGesture:(UIGestureRecognizer *)g
{
    ((MTWindowAlert *)self.parent).flag = FALSE;
    [(MTWindowAlert *)self.parent cancel];
}


@end
