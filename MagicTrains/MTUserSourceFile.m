//
//  MTUserSourceFile.m
//  TrainsProject
//
//  Created by Przemysław Porbadnik on 19.03.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import "MTUserSourceFile.h"
#import "MTUserData.h"
@import Foundation;
@implementation MTUserSourceFile

-(NSString *) path{
    NSString *val = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MTUserData.mtd"];
    return val;
}

-(void) loadSucc:(void(^)(MTUserData*))success
            Fail:(void(^)(NSString*))failure
{
    NSString *filepath = [self path];
    MTUserData* dt = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
    if(dt != nil){
        success(dt);
    }else{
        failure(@"Błąd Odczytu z pliku");
    }
    
}
-(void) saveData:(MTUserData*)data
            Succ:(void(^)(MTUserData*))success
            Fail:(void(^)(NSString*))failure
{
        if([NSKeyedArchiver archiveRootObject:data toFile:[self path]]){
        success(data);
    }else{
        failure(@"Błąd Zapisu do pliku");
    }
}

@end
