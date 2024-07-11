//
//  MTUserStorageLoader.m
//  TrainsProject
//
//  Created by Przemysław Porbadnik on 19.03.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import "MTUserStorageLoader.h"

@implementation MTUserStorageLoader

-(void)loadSucc:( void(^)(MTUserStorage*))success
                     Fail:(void(^)(NSString*))failure
{
    __block MTUserSourceFile* srcFile = [[MTUserSourceFile alloc] init];
    __block MTUserSourceGen* srcGen = [[MTUserSourceGen alloc] init];
    __block MTUserSourceICloud* srcICloud = [[MTUserSourceICloud alloc] init];
    __block void(^arSuccess)(MTUserStorage*) = success;
    __block void(^arFail)(NSString*) = failure;
    
    __block void(^finishSuccess)(MTUserData*)=^(MTUserData* udata){
        [srcICloud saveData:udata
                       Succ:^(MTUserData* ud){}
                       Fail:^(NSString * msg) {
                          //NSLog(@"%@",msg);
                       }];
        arSuccess([self putToStorage:udata]);
        
    };
    __block void(^ finishFail)(NSString *) = ^(NSString * msg){
        arFail(msg);
    };
    
    
    
    void (^ saveFile)(MTUserData*) = ^(MTUserData* udata){
        [srcFile saveData: udata
                     Succ: finishSuccess
                     Fail: ^(NSString* msg){
                         //NSLog(@"%@",msg);
                         finishSuccess(udata);
                     }];
    };
   
    void (^ generate)(NSString*) = ^(NSString* msg){
        //NSLog(@"%@",msg);
        [srcGen loadSucc: saveFile
                    Fail: finishFail];
    };
    
    void (^ getFile)(NSString*) = ^(NSString* msg){
        //NSLog(@"%@",msg);
        [srcFile loadSucc: finishSuccess
                     Fail: generate];
    };
    
    void (^ cloudLoaded)(MTUserData*) = ^(MTUserData* udata){
        NSString *ava = [udata MTUserAvatar];
        if (ava == nil ||
            [ava isEqualToString:@""] ||
            [ava isEqualToString:@"0-0-0-0"])
            [srcGen loadSucc:saveFile Fail:getFile];
        else
            saveFile(udata);
    };
   
    [srcICloud loadSucc:cloudLoaded
                   Fail:getFile];
    
}

-(MTUserStorage*) putToStorage:(MTUserData*) udata{
    MTUserStorage* US = [MTUserStorage getInstance];
    [US setAvatarId:udata.MTUserAvatar];
    [US setEnabledChallengeSceneNr:(int)udata.MTEnabledChallenge1 ForLevel:1];
    [US setEnabledChallengeSceneNr:(int)udata.MTEnabledChallenge2 ForLevel:2];
    [US setEnabledChallengeSceneNr:(int)udata.MTEnabledChallenge3 ForLevel:3];
    [US setEnabledChallengeSceneNr:(int)udata.MTEnabledChallenge4 ForLevel:4];
    return US;
}

-(MTUserData*) getFromStorage{
    MTUserData * udata = [[MTUserData alloc] init];
    MTUserStorage* US = [MTUserStorage getInstance];
    udata.MTUserAvatar = [US getAvatarId];
    udata.MTEnabledChallenge1 = [US getEnabledChallengeForLevel:1];
    udata.MTEnabledChallenge2 = [US getEnabledChallengeForLevel:2];
    udata.MTEnabledChallenge3 = [US getEnabledChallengeForLevel:3];
    udata.MTEnabledChallenge4 = [US getEnabledChallengeForLevel:4];
    return udata;
}
-(void)saveSucc:(void(^)(MTUserStorage*))success
           Fail:(void(^)(NSString*))failure
{
    MTUserData * udata = [self getFromStorage];
    __block MTUserSourceFile* srcFile = [[MTUserSourceFile alloc] init];
    __block MTUserSourceGen* srcGen = [[MTUserSourceGen alloc] init];
    __block MTUserSourceICloud* srcICloud = [[MTUserSourceICloud alloc] init];
    __block void(^arSuccess)(MTUserStorage*) = success;
    __block void(^arFail)(NSString*) = failure;
    
    __block void(^finishSuccess)(MTUserData*)=^(MTUserData* udata){
        [srcICloud saveData:udata
                       Succ:^(MTUserData* ud){}
                       Fail:^(NSString * msg) {
                           //NSLog(@"%@",msg);
                       }];
        arSuccess([self putToStorage:udata]);
        
    };
    __block void(^ finishFail)(NSString *) = ^(NSString * msg){
        arFail(msg);
    };
    
    
    
    void (^ saveFile)(MTUserData*) = ^(MTUserData* udata){
        [srcFile saveData: udata
                     Succ: finishSuccess
                     Fail: ^(NSString* msg){
                         //NSLog(@"%@",msg);
                         finishSuccess(udata);
                     }];
    };
    
    void (^ generate)(NSString*) = ^(NSString* msg){
        //NSLog(@"%@",msg);
        [srcGen loadSucc: saveFile
                    Fail: finishFail];
    };
    
    void (^ getFile)(NSString*) = ^(NSString* msg){
        //NSLog(@"%@",msg);
        [srcFile loadSucc: finishSuccess
                     Fail: generate];
    };
    
    void (^ cloudLoaded)(MTUserData*) = ^(MTUserData* udata){
        NSString *ava = [udata MTUserAvatar];
        if (ava == nil ||
            [ava isEqualToString:@""] ||
            [ava isEqualToString:@"0-0-0-0"])
            [srcGen loadSucc:saveFile Fail:getFile];
        else
            saveFile(udata);
    };
    
    [srcICloud saveData:udata
                   Succ:saveFile
                   Fail:failure];
    
}
@end
