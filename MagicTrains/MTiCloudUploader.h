//
//  MTiCloudUploader.h
//  TrainsProject
//
//  Created by Blazej Zyglarski on 03.10.2015.
//  Copyright © 2015 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTiCloudUploader : NSObject
@property NSDictionary* scene;
-(void)startUploadWithProgressUpdate:(void (^)(int))progressUpdate completion:(void(^)(BOOL))completion;
@end
