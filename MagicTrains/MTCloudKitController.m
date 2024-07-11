///
//  MTCloudKitController.m
//  TrainsProject
//
//  Created by Dawid Skrzypczyński on 02.09.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>
#import "MTCloudKitController.h"

@implementation MTCloudKitController

+(bool) checkIfUserLoggedToICloud {
    __block bool is_logged = false;
    
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError *error) {
        if (accountStatus == CKAccountStatusAvailable) {
            is_logged = true;
        }
    }];
    
    return is_logged;
}


+(bool) checkIfUserLoggedToICloudOnSuccess:(void (^)()) successCB onError: (void (^)()) errorCB{
    __block bool is_logged = false;
    
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError *error) {
        if (accountStatus == CKAccountStatusAvailable) {
            is_logged = true;
            dispatch_async(dispatch_get_main_queue(), ^{
                successCB();
            });
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                          errorCB();
            });

        }
    }];
    
    return is_logged;
}

+(UIAlertView *) getAlertNotConnected:(UIViewController *)view {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign in to iCloud"
                                                    message:@"Sign in to your iCloud account to write records. On the Home screen, launch Settings, tap iCloud, and enter your Apple ID. Turn iCloud Drive on. If you don't have an iCloud account, tap Create a new Apple ID."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    return alert;
}

@end