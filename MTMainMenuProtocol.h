//
//  MTMainMenuProtocol.h
//  MagicTrains
//
//  Created by Blazej Zyglarski on 06.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestView.h"

@protocol MTMainMenuProtocol <NSObject>

//-(void)buttonPressed:(int)i; //deprecated

-(void)openScene:(NSDictionary*)scene;

-(void)uploadPressed:(int)i;
-(void)netPressed:(NSString*)s;
-(void)taskPressed:(NSString*)s;
-(void)learnPressed:(NSString*)s;
-(void)userAction;
-(void)shareProgressBar:(TestView*)t;

@end

