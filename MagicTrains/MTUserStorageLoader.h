//
//  MTUserStorageLoader.h
//  TrainsProject
//
//  Created by Przemysław Porbadnik on 19.03.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTUserStorage.h"
#import "MTUserData.h"
#import "MTUserSourceFile.h"
#import "MTUserSource.h"
#import "MTUserSourceGen.h"
#import "MTUserSourceICloud.h"

@interface MTUserStorageLoader : NSObject

-(void)loadSucc:(void(^)(MTUserStorage*))success
                     Fail:(void(^)(NSString*))failure;

-(void)saveSucc:(void(^)(MTUserStorage*))success
           Fail:(void(^)(NSString*))failure;
@end
