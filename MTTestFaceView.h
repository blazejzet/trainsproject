//
//  MTTestFaceView.h
//  TrainsProject
//
//  Created by Blazej Zyglarski on 19.03.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestView.h"
#import "MTAutoHelpProtocol.h"

@interface MTTestFaceView : UIImageView <MTAutoHelpProtocol>
@property id<MTAutoHelpProtocol> g;

@property TestView*test;
-(void)setDelegate:(id<MTAutoHelpProtocol>)g;
@end
