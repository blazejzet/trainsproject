//
//  MTSpriteNodeGI.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 22.11.2015.
//  Copyright © 2015 UMK. All rights reserved.
//

#import "MTSpriteNodeGI.h"

@implementation MTSpriteNodeGI
-(void)setSelected:(BOOL)selected{
    [self.parent performSelector:@selector(tapGesture:) withObject:nil];
}
-(void)tapGesture:(UIGestureRecognizer *)g{
    [self.parent performSelector:@selector(tapGesture:) withObject:g];
}
@end
