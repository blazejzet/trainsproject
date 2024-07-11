//
//  MTCollisionWithAnotherGhostLocomotiv.h
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 15.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCart.h"
#import "MTGhost.h"

@class MTCollisionWithAnotherGhostLocomotivOptions;
@interface MTCollisionWithAnotherGhostLocomotiv : MTCart <NSCoding>
@property MTCollisionWithAnotherGhostLocomotivOptions *options;
@property MTGhost *selectedGhost;
@property bool optionsOpen;
@end
