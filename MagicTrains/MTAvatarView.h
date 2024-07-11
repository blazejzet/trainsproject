//
//  MTAvatarView.h
//  TrainsProject
//
//  Created by Blazej Zyglarski on 01.10.2015.
//  Copyright © 2015 UMK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTAvatarView : UIView
-(id)initWithData:(NSString*)avatarid;
-(MTAvatarView*)small;
-(NSString*)getAvatarId;
@end
