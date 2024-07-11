//
//  MTUserSourceGen.m
//  TrainsProject
//
//  Created by Przemysław Porbadnik on 19.03.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import "MTUserSourceGen.h"

@implementation MTUserSourceGen

-(void) loadSucc:(void(^)(MTUserData*))success
            Fail:(void(^)(NSString*))failure
{
    MTUserData* dt = [[MTUserData alloc] init];
    dt.MTEnabledChallenge1 = 0;
    dt.MTEnabledChallenge2 = 0;
    dt.MTEnabledChallenge3 = 0;
    dt.MTEnabledChallenge4 = 0;
    dt.MTUserAvatar = [self getAvatarIdNew];
    success(dt);
}

-(NSString*) getAvatarIdNew{
    NSUserDefaults* d = [NSUserDefaults standardUserDefaults];
    
    NSInteger avatar_bg = 0;
        avatar_bg = arc4random()%11+1;
        [d setInteger:avatar_bg forKey:@"avatar_bg_"];
    
    NSInteger avatar_ghost = 0;
        avatar_ghost = arc4random()%9+1;
        [d setInteger:avatar_ghost forKey:@"avatar_ghost_"];
    
    NSInteger avatar_ghost_color = 0;
        avatar_ghost_color = arc4random()%9+1;
        [d setInteger:avatar_ghost_color forKey:@"avatar_ghost_color_"];
    
    NSInteger avatar_ghost_face = 0;
        avatar_ghost_face = arc4random()%9+1;
        [d setInteger:avatar_ghost_face forKey:@"avatar_ghost_face_"];
    
    [d synchronize];
    return [NSString stringWithFormat:@"%d-%d-%d-%d",avatar_bg,avatar_ghost,avatar_ghost_color,avatar_ghost_face];
}

-(void) saveData:(MTUserData*)data
            Succ:(void(^)(MTUserData*))success
            Fail:(void(^)(NSString*))failure
{
    failure(@"Saving data to generator");
}



@end
