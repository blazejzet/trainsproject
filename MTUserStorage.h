//
//  MTUserStorage.h
//  TrainsProject
//
//  Created by Przemysław Porbadnik on 15.11.2015.
//  Copyright © 2015 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>
@interface MTUserStorage : NSObject

+ (MTUserStorage *) getInstance;
- (NSString *) getAvatarId;
@property CKRecordID * userRecordId;
- (void)setAvatarId:(NSString *) avatarId;
- (void) setEnabledChallengeSceneNr:(int) nr ForLevel:(int) lvl;
- (int) getEnabledChallengeForLevel:(int) lvl;

+(void)clear;
@end
