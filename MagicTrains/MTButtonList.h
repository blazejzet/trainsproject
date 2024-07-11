//
//  MTButtonList.h
//  TrainsProject
//
//  Created by Blazej Zyglarski on 30.07.2015.
//  Copyright © 2015 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTButtonListProtocol.h"
#import "MTMainMenuProtocol.h"
#import "MTNewSceneButton.h"

@interface MTButtonList : UIView <MTButtonListProtocol>
@property (weak) id delegate;
@property BOOL showDownloadAll;


-(void)showList;
-(void)showListWithDelegate:(id) delegat;
-(id)initWithList:(NSArray*)list;
-(void)invalidate;
-(void)updateList:(NSArray*)list;
-(id)initWithList:(NSArray*)list andAFM:(void(^)(MTButtonList*,int))afm;
-(void)removeButton:(NSMutableDictionary*)b;
-(void)setEnabled;
-(void)setDisabled;
-(void)clear;
@end
