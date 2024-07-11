//
//  MTPhysicsManagement.h
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 11.07.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface MTPhysicsManagement : NSObject
@property (weak) SKScene *scene;
@property CGVector *gravity;

-(id) initWithScene:(SKScene *) scene;
-(void) manageCollision:(SKPhysicsContact *) contact;
@end
