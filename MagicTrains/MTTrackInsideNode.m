//
//  MTCartConnectorNode.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 29.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTTrackInsideNode.h"
#import "MTGUI.h"
@implementation MTTrackInsideNode

-(id)init
{
    if (self = [super initWithImageNamed:@"trackInside.png"])
    {
        self.size = CGSizeMake(TRACK_WIDTH, TRACK_HEIGHT);
        self.anchorPoint = CGPointMake(0.5, 1);
        self.name = @"MTTrackInsideNode";
    }
    return self;
}


@end
