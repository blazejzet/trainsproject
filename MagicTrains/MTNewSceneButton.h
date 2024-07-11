//
//  MTNewSceneButton.h
//  TrainsProject
//
//  Created by Blazej Zyglarski on 30.07.2015.
//  Copyright © 2015 UMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTButtonListProtocol.h"
#import "MTButtonsDelegate.h"

@interface MTNewSceneButton : UIImageView
@property (weak) id<MTButtonListProtocol> delegate;
@property (weak) UIView<MTButtonsDelegate>* buttonsdelegate;

-(void)setActiveSharedButton;

-(void)setInactiveSharedButton;

-(id)initWithScene:(NSDictionary*)scene;
-(void)invalidate;
-(void)reset;
-(void)select;
-(void)setNewPosition:(CGPoint)p;
-(void)setNewPosition:(CGPoint)p animated:(BOOL)animated;
-(void)showButtons;
-(void) showProgress:(NSNumber*)n;
-(void) hideProgressBarSuccess;
-(void) hideProgressBarFailed;
-(void)downloadWithCallback:(void(^)(void))cb;
-(void)prepareToRemove;
-(void)setEnabled;
-(void)setDisabled;


-(void)setShared;
-(void)setUnShared;


@end
