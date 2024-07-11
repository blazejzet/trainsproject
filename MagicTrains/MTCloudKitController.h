//
//  MTCloudKitController.h
//  TrainsProject
//
//  Created by Dawid Skrzypczyński on 02.09.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

@interface MTCloudKitController : NSObject
+(bool) checkIfUserLoggedToICloud;
+(UIAlertView *) getAlertNotConnected:(UIViewController *)view;
+(bool) checkIfUserLoggedToICloudOnSuccess:(void (^)()) successCB onError: (void (^)()) errorCB;
@end
