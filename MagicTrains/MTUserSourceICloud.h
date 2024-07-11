//
//  MTUserSourceICloud.h
//  TrainsProject
//
//  Created by Przemysław Porbadnik on 19.03.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTUserSource.h"
#import "MTUserData.h"
#import "CloudKit/CloudKit.h"
@interface MTUserSourceICloud : NSObject<MTUserSource>
    -(void) loadSucc:(void(^)(MTUserData*))success
                       Fail:(void(^)(NSString*))failure;
-(void) saveData:(MTUserData*)data
            Succ:(void(^)(MTUserData*))success
            Fail:(void(^)(NSString*))failure;
@end
