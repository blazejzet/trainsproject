//
//  MTNewMenuPoziomDisplay.h
//  TrainsProject
//
//  Created by Blazej Zyglarski on 19.06.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTMainMenuProtocol.h"
#import "MTNewMenuUptadePositionProtocol.h"
#import "MTButtonList.h"
@interface MTNewMenuPoziomDisplay : UIImageView
@property (strong) NSMutableArray * przyciski;
@property BOOL enabled;
@property BOOL waiting_flag;
@property (weak) id<MTMainMenuProtocol> delegate;
@property NSString* subtype;
@property (weak) id<MTNewMenuUptadePositionProtocol> p;
@property __block MTButtonList* xbl;


@property UIView* menuDisplay;
-(id)initWithPoint:(CGPoint)p;
-(void)prepare:(CGPoint)p;
-(void)show:(NSString*)type;
-(void)hide;
-(void)showElements;
-(void)displayElements;

-(BOOL)waiting;
-(void)ready;

-(void)setEnabled;
-(void)setDisabled;
-(void)refresh;

@end
