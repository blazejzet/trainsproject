//
//  MTCollisionWithAnotherGhostLocomotivTrackNode.m
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 06.05.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCollisionWithAnotherGhostLocomotivTrackNode.h"

@implementation MTCollisionWithAnotherGhostLocomotivTrackNode
-(id) init
{
    if ((self = [super initWithImageNamed:@"MTCollisionWithAnotherGhostLocomotivTrack.png"]))
    {
        self.size = CGSizeMake(100, 105);
    }
    
    return self;
}
@end
