//
//  SKTexture+MTTextureLoader.h
//  TrainsProject
//
//  Created by Blazej Zyglarski on 28.05.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKTexture (MTTextureLoader)

+ (instancetype)textureCachedWithImageNamed:(NSString *)name;
@end
