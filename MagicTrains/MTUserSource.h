//
//  MTUserSource.h
//  TrainsProject
//
//  Created by Przemysław Porbadnik on 19.03.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#ifndef MTUserSource_h
#define MTUserSource_h
#import "MTUserData.h"

@protocol MTUserSource

-(void) loadSucc:(void(^)(MTUserData*))success
            Fail:(void(^)(NSString*))failure;
-(void) saveData:(MTUserData*)data Succ:(void(^)(MTUserData*))success Fail:(void(^)(NSString*))failure;
@end



#endif /* MTUserSource_h */
