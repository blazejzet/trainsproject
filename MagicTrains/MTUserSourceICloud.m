//
//  MTUserSourceICloud.m
//  TrainsProject
//
//  Created by Przemysław Porbadnik on 19.03.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import "MTUserSourceICloud.h"

@implementation MTUserSourceICloud

-(void) loadSucc:(void(^)(MTUserData*))success Fail:(void(^)(NSString*))failure
{
    CKContainer *myContainer = [CKContainer containerWithIdentifier:@"iCloud.pl.bedesign.TrainsProject"];
    
    [myContainer fetchUserRecordIDWithCompletionHandler:^(CKRecordID *recordID, NSError *error) {
        //Jeśli w iCloud jeszcze nie ma tej infomracji...
        if(recordID==nil){
            failure(@"RecordID is null");
        }else{
            [[myContainer publicCloudDatabase] fetchRecordWithID:recordID completionHandler:
             ^(CKRecord * _Nullable record, NSError* _Nullable err) {
                 MTUserData* dt = [[MTUserData alloc] init];
                 dt.MTUserAvatar = record[@"MTUserAvatar"];
                 dt.MTEnabledChallenge1 = [(NSNumber*) record[@"MTEnabledChallenge1"] intValue];
                 dt.MTEnabledChallenge2 = [(NSNumber*) record[@"MTEnabledChallenge2"] intValue];
                 dt.MTEnabledChallenge3 = [(NSNumber*) record[@"MTEnabledChallenge3"] intValue];
                 dt.MTEnabledChallenge4 = [(NSNumber*) record[@"MTEnabledChallenge4"] intValue];
                 
                 success(dt);
             }];
            
        }
    }];
}
-(void) saveData:(MTUserData*)data
            Succ:(void(^)(MTUserData*))success
            Fail:(void(^)(NSString*))failure
{
    CKContainer *myContainer = [CKContainer containerWithIdentifier:@"iCloud.pl.bedesign.TrainsProject"];
    [myContainer fetchUserRecordIDWithCompletionHandler:^(CKRecordID *recordID, NSError *error) {
        if(recordID==nil){
            failure(@"RecordID is null");
        }else{
            [[myContainer publicCloudDatabase] fetchRecordWithID:recordID completionHandler:
             ^(CKRecord * _Nullable userRecord, NSError* _Nullable err) {
                 userRecord[@"MTUserAvatar"] = data.MTUserAvatar;
                 userRecord[[NSString stringWithFormat:@"MTEnabledChallenge%d",1]] = [NSNumber numberWithLongLong: data.MTEnabledChallenge1];
                 userRecord[[NSString stringWithFormat:@"MTEnabledChallenge%d",2]] = [NSNumber numberWithLongLong: data.MTEnabledChallenge2];
                 userRecord[[NSString stringWithFormat:@"MTEnabledChallenge%d",3]] = [NSNumber numberWithLongLong: data.MTEnabledChallenge3];
                 userRecord[[NSString stringWithFormat:@"MTEnabledChallenge%d",4]] = [NSNumber numberWithLongLong: data.MTEnabledChallenge4];
                 if(userRecord==nil){
                     failure(@"userRecord is null");
                 }else{
                    [[myContainer publicCloudDatabase] saveRecord:userRecord completionHandler:^(CKRecord                                                                      *savedRecord, NSError *saveError) {
                        if (saveError)
                            failure(@"Błąd zapisu do ICloud");
                        else
                            success(data);
                        // Error handling for failed save to public database
                        
                    }];}
             }];
        }
    }];
}

@end
