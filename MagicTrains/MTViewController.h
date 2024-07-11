//
//  MTViewController.h
//  testNodow
//

//  Copyright (c) 2013 UMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>
#import "MTINMenuViewDelegate.h"
#import "MTViewControllerGameOverScreenDelegate.h"
#import "MTAutoHelpProtocol.h"

@interface MTViewController : UIViewController <MTINMenuViewDelegate,MTViewControllerGameOverScreenDelegate,MTAutoHelpProtocol>
{
    CMMotionManager *motionManager;
    CMAttitude *referenceAttitude;
	NSTimer *timer;
}
@property SKScene *mainScene;
@property NSMutableDictionary* scene; //JSON Z INFORMACJAMI O SCENIE
@property int loadedStage;      //DEPRECATED
@property NSString*downloadedStage; //DEPRECATED
@property SKFieldNode * skf;

@property UIImageView * help;
/*Obsluga zyroskopu*/
@property CGFloat gyroRotation;
@property CGFloat gyroDirection; //Zwraca -1 w lewo; 1 w prawo
-(void) startGyroUpdateWithDurationPerSecound: (CGFloat)duration;
-(void) stopGyroUpdate;
-(void)initinmenu;
-(void)showLoading;
-(void) addTimer:(NSTimer*)t;
-(void)loadStage:(NSString*)fname;
+(MTViewController *) getInstance;

-(void)showVictory:(NSString*) costumeName;
-(void)showGameOver:(NSString*) costumeName;
@end
