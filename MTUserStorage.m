//
//  MTUserStorage.m
//  TrainsProject
//
//  Created by Przemysław Porbadnik on 15.11.2015.
//  Copyright © 2015 UMK. All rights reserved.
//

#import "MTUserStorage.h"
#import "MTWebApi.h"
#import <CloudKit/CloudKit.h>
#import "MTUserStorageLoader.h"
@implementation MTUserStorage

static MTUserStorage * myInstanceMTUS = NULL;
+ (MTUserStorage *)getInstance{
    if (myInstanceMTUS == NULL)
    {
        myInstanceMTUS = [[MTUserStorage alloc] init];
    }
    return myInstanceMTUS;
}

+(void)clear
{
    myInstanceMTUS = nil;
}
-(id) init
{
    if (self)
    {
        
        //[myInstanceMTUS getAvatarIdFromCloud];
    }
    return self;
}

-(NSString*)getAvatarId{
    
    return [self getAvatarIdNew];
}

-(void)setAvatarId:(NSString *) avatarId{
    NSUserDefaults* d = [NSUserDefaults standardUserDefaults];
    NSArray * avi = [avatarId componentsSeparatedByString:@"-"];
    NSInteger avatar_bg =  [[avi objectAtIndex:0] integerValue] ;
    NSInteger avatar_ghost = [[avi objectAtIndex:1] integerValue] ;
    NSInteger avatar_ghost_color = [[avi objectAtIndex:2] integerValue] ;
    NSInteger avatar_ghost_face = [[avi objectAtIndex:3] integerValue];
    
    [d setInteger:avatar_bg forKey:@"avatar_bg_"];
    [d setInteger:avatar_ghost forKey:@"avatar_ghost_"];
    [d setInteger:avatar_ghost_color forKey:@"avatar_ghost_color_"];
    [d setInteger:avatar_ghost_face forKey:@"avatar_ghost_face_"];
    [d synchronize];
}
- (void) setEnabledChallengeSceneNr:(int) sceneNr ForLevel:(int) lvl{
    NSUserDefaults* d = [NSUserDefaults standardUserDefaults];
    if ([self getEnabledChallengeForLevel:lvl] < sceneNr)
        [d setInteger:sceneNr forKey:
            [NSString stringWithFormat: @"MTEnabledChallenge%d",lvl]];
    MTUserStorageLoader * usl = [[MTUserStorageLoader alloc] init];
    [usl saveSucc:^void(MTUserStorage* st){}
                    Fail:^void(NSString* str){}];
}
- (int) getEnabledChallengeForLevel:(int) lvl{
    NSUserDefaults* d = [NSUserDefaults standardUserDefaults];
    return [d integerForKey:
            [NSString stringWithFormat: @"MTEnabledChallenge%d",lvl]];
}

//// IMPLEMENTACJE
-(NSString*) getAvatarIdNew{
    NSUserDefaults* d = [NSUserDefaults standardUserDefaults];
    NSInteger avatar_bg = [d integerForKey:@"avatar_bg_"] ;
    NSInteger avatar_ghost = [d integerForKey:@"avatar_ghost_"] ;
    NSInteger avatar_ghost_color = [d integerForKey:@"avatar_ghost_color_"] ;
    NSInteger avatar_ghost_face = [d integerForKey:@"avatar_ghost_face_"] ;
    return [NSString stringWithFormat:@"%d-%d-%d-%d",avatar_bg,avatar_ghost,avatar_ghost_color,avatar_ghost_face];
}

-(void) getAvatarIdFromCloud
{
    [MTWebApi getUser];
}

-(CKRecordID *) userRecordId
{
    return  self.userRecordId;
}

-(void) setUserRecordId:(CKRecordID *)recId
{
    self.userRecordId = recId;
}
@end
