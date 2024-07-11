//
//  MTHpVariable.m
//  MagicTrains
//
//  Created by Kamil Tomasiak on 07.04.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTHpVariableNode.h"

@implementation MTHpVariableNode

-(id) initWithValue{
    if ((self = [super initWithImageNamed:@"heart_fill.png"]))
    {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.size = CGSizeMake(40, 40);
        //self.cartName =cartName;
        //self.value = 0;
        self.name = @"MTWheelNode";
        
        self.position = CGPointMake(100,100);
        
        
    }
    
    return self;
}

@end
