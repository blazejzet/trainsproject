//
//  MTStarView.h
//  TrainsProject
//
//  Created by Blazej Zyglarski on 06.10.2015.
//  Copyright © 2015 UMK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTStarView : UIImageView
-(id)initWithMyStars:(int)my worldStars:(int)world starCallback:(void (^)(int))scb_;
@end
