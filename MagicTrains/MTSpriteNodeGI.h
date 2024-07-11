//
//  MTSpriteNodeGI.h
//  TrainsProject
//
//  Created by Blazej Zyglarski on 22.11.2015.
//  Copyright © 2015 UMK. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MTSpriteNode.h"

@interface MTSpriteNodeGI : MTSpriteNode
-(void)setSelected:(BOOL)selected;
-(void)tapGesture:(UIGestureRecognizer *)g;
@end
