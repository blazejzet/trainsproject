//
//  MTButtonListProtocol.h
//  TrainsProject
//
//  Created by Blazej Zyglarski on 30.07.2015.
//  Copyright © 2015 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTButtonListProtocol <NSObject>
-(void)resetButtons;
-(void)resetButtons:(CGFloat)point;

-(void)clicked;
@end
