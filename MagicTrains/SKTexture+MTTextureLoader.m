//
//  SKTexture+MTTextureLoader.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 28.05.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import "SKTexture+MTTextureLoader.h"

@implementation SKTexture (MTTextureLoader)

static NSMutableDictionary* texturesCache;

+ (instancetype)textureCachedWithImageNamed:(NSString *)name{
    
    if(texturesCache == nil){
        texturesCache = [NSMutableDictionary dictionary];
    }
    if(texturesCache[name]!=nil){
        //NSLog(@"REUSING texture: %@",name);
    }else{
        //NSLog(@"CREATING NEW texture: %@",name);
        texturesCache[name]=[SKTexture textureWithImageNamed:name];
    }
    return texturesCache[name];
    
}
@end
