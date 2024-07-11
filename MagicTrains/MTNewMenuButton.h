//
//  MTNewMenuButton.h
//  TrainsProject
//
//  Created by Blazej Zyglarski on 19.06.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTNewMenuPoziomDisplay.h"
#import "MTNewMenuUptadePositionProtocol.h"

@interface MTNewMenuButton : UIImageView
@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) NSString* subtype;
@property (strong) NSMutableArray* othersCollection;
@property BOOL selected;
@property (strong) MTNewMenuPoziomDisplay* refDisplay;
@property (weak) id<MTNewMenuUptadePositionProtocol> p;

-(id)initWithType:(NSString*)type;
-(id)initWithType:(NSString*)type andSubtype:(NSString*)stype;
-(id)initWithType:(NSString*)type andSubtype:(NSString*)stype opened:(BOOL) opened;
-(void)show;
-(void)select;
-(void)bubbleRepeat;
-(void)unselect;
-(void)setEnabled;
-(void)setDisabled;
-(void)refresh;

@end
