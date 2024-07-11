//
//  MTiCloudDownloader.h
//  TrainsProject
//
//  Created by Blazej Zyglarski on 03.10.2015.
//  Copyright © 2015 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTiCloudDownloader : NSObject
 @property (nonatomic,strong) NSDictionary* scene;
-(void)startDownloadWithProgressUpdate:(void (^)(int))progressUpdate completion:(void(^)(NSDictionary*))completion;
-(void)startDownloadThumbnailWithProgressUpdate:(void (^)(int))progressUpdate completion:(void(^)(NSDictionary*))completion;
-(void)startDownloadObjectiveWithProgressUpdate:(void (^)(int))progressUpdate completion:(void(^)(NSDictionary*))completion;
@end
