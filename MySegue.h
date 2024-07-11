//
//  MySegue.h
//  TrainsProject
//
//  Created by Blazej Zyglarski on 05.10.2015.
//  Copyright © 2015 UMK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySegue : UIStoryboardSegue
@property CGPoint spoint;

@property (assign) UIViewController *delegate;
@end
