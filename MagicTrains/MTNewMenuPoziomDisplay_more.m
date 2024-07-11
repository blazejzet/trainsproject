//
//  MTNewMenuPoziomDisplay_sandbox.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 21.06.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTNewMenuPoziomDisplay_more.h"
#import "MTButtonsView.h"
#import "MTWebApi.h"
#import "MTNewMenuButton.h"
#import "MTButtonList.h"
#import <StoreKit/SKStoreProductViewController.h>
#import <Foundation/NSNetServices.h>

#import <Foundation/NSURLConnection.h>
#import <Foundation/NSStream.h>

@interface MTNewMenuPoziomDisplay_more () <NSNetServiceDelegate, NSNetServiceBrowserDelegate>
@property int page;
@property NSString * nick;
@property  NSArray* lista;
//@property MTButtonList* bl;
@property UITextField * text_input;
@property NSNetService* service;
@property NSNetServiceBrowser * browser;
@property UIButton * connectServiceButton;
@property UIButton * publishServiceButton;
@property NSString * classroomServiceName;
@property NSMutableArray*a;
@end

@implementation MTNewMenuPoziomDisplay_more
@synthesize service;
@synthesize browser;
@synthesize classroomServiceName;
@synthesize connectServiceButton;
@synthesize a;
@synthesize publishServiceButton;
-(void) showElements{
    
    
    for (UIView* v in self.subviews){
        [v removeFromSuperview];
        connectServiceButton=nil;
        publishServiceButton=nil;
    }
    //[self performSelector:@selector(openStore) withObject:NULL afterDelay:2.0];
    
    publishServiceButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 88, 88)];
    //[publishServiceButton setTitle:@"Register as Classroom Master" forState:UIControlStateNormal];
    
    [publishServiceButton setImage:[UIImage imageNamed:@"menu_startbroadcast"] forState:UIControlStateNormal];
    
    [publishServiceButton addTarget:self action:@selector(broadcastTI) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    [self addSubview:publishServiceButton];
    [publishServiceButton setCenter:CGPointMake( 150,100)];

    connectServiceButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 88, 88)];
    //[connectServiceButton setTitle:@"Searching for service..." forState:UIControlStateNormal];
    
    
    [connectServiceButton setImage:[UIImage imageNamed:@"menu_searching"] forState:UIControlStateNormal];
    //[connectServiceButton addTarget:self action:@selector(attachTI) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    [self addSubview:connectServiceButton];
    [connectServiceButton setCenter:CGPointMake( 280,100)];

    if ([MTWebApi checkServicing]){
        // SERWIS JUŻ ODPALONY
        //[publishServiceButton setTitle:@"Classroom service running" forState:UIControlStateNormal];
        
        [publishServiceButton setImage:[UIImage imageNamed:@"menu_broadcast"] forState:UIControlStateNormal];
        [self setupServiceButtons];
    }else{
    
    if ([MTWebApi checkMasterServiceWorking]){
         // [connectServiceButton setTitle:@"Disconnect from service" forState:UIControlStateNormal];
        [connectServiceButton setImage:[UIImage imageNamed:@"menu_established"] forState:UIControlStateNormal];
        [self.publishServiceButton setUserInteractionEnabled:false];
    }
    }
    
    
    
}


-(void)checkTI{
    if(![MTWebApi checkServicing]){
    [[MTWebApi getInstance] setDel:self];
    [[MTWebApi getInstance] performSelector:@selector(checkTI) withObject:nil afterDelay:5.0];
    }

}

-(void)attachTI{
    
        [[MTWebApi getInstance] attachTI:self.classroomServiceName];
    
}

-(void)detachTI{
    if ([MTWebApi checkMasterServiceWorking]){
        //disconnect
        [[MTWebApi getInstance] detachTI];
        //[self.connectServiceButton setTitle:@"Searching for service" forState:UIControlStateNormal];
        [connectServiceButton setImage:[UIImage imageNamed:@"menu_searching"] forState:UIControlStateNormal];
        [[MTWebApi getInstance] setDel:self];
        [[MTWebApi getInstance] checkTI];
        
    }
}




-(void)ServiceFound:(NSString *)name{
    NSLog(@"Found: %@",name);
    //[self.connectServiceButton setTitle:@"Service found. Connect" forState:UIControlStateNormal];
    [connectServiceButton setImage:[UIImage imageNamed:@"menu_established"] forState:UIControlStateNormal];
    self.classroomServiceName = name;
    [self attachTI];
}

-(void)setupButtonx:(int)x y:(int)y ide:(int)ident nam:(NSString*)name  im:(NSString*)im{
    UIButton * b = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 88, 88)];
   
    //[b setTitle:name forState:UIControlStateNormal];
    [b setImage:[UIImage imageNamed:[NSString stringWithFormat:@"menu_%@",im]] forState:UIControlStateNormal];
    [b setTag:ident];
    
    [b addTarget:self action:@selector(broadcastMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:b];
    b.userInteractionEnabled=true;
    [b setCenter:CGPointMake( 250+x*120,100)];
    [a addObject:b];
    //[b setBackgroundColor:[UIColor redColor]];
}
-(void)setupServiceButtons{
    a = [NSMutableArray array];
    [self setupButtonx:1 y:1 ide:1 nam:@"Main Screen" im:@"back"];
    [self setupButtonx:2 y:2 ide:2 nam:@"Clear All" im:@"dellall"];
    [self setupButtonx:3 y:1 ide:3 nam:@"Block" im:@"stopusing"];
    [self setupButtonx:4 y:2 ide:4 nam:@"UnBlock" im:@"startusing"];
    [self setupButtonx:5 y:2 ide:5 nam:@"Detach" im:@"detach"];
}
-(void)deleteServiceButtons{
    for (UIButton * b in a){
        [b removeFromSuperview];
    }
    a = [NSMutableArray array];
}


-(void)broadcastMessage:(UIButton*)sender{
    [[MTWebApi getInstance] broadCastMessage:[NSString stringWithFormat:@"%d",sender.tag]];
}
-(void)broadcastTI{
   // URUCHOMIENIE SERWISU W WEBAPI
    if ([MTWebApi checkServicing]){
        //TODO stop service
        [[MTWebApi getInstance] stopBroadcasting];
        [self deleteServiceButtons];
         [publishServiceButton setImage:[UIImage imageNamed:@"menu_startbroadcast"] forState:UIControlStateNormal];
    }else{
        if([MTWebApi broadcastService]){
        //[publishServiceButton setTitle:@"Classroom service running" forState:UIControlStateNormal];
        [publishServiceButton setImage:[UIImage imageNamed:@"menu_broadcast"] forState:UIControlStateNormal];

        [self setupServiceButtons];
        }
    }
}



-(void)openStore{
    [self openStoreProductViewControllerWithITunesItemIdentifier:1118705874];
    // [self updateList];
    
    
}
- (void)openStoreProductViewControllerWithITunesItemIdentifier:(NSInteger)iTunesItemIdentifier {
    
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
    
    storeViewController.delegate = self;
    
    NSNumber *identifier = [NSNumber numberWithInteger:iTunesItemIdentifier];
    
    NSDictionary *parameters = @{ SKStoreProductParameterITunesItemIdentifier:identifier };
    UIViewController *viewController = self.window.rootViewController;
    [storeViewController loadProductWithParameters:parameters
                                   completionBlock:^(BOOL result, NSError *error) {
                                       if (result)
                                           [topController presentViewController:storeViewController
                                                                        animated:YES
                                                                      completion:nil];
                                       else NSLog(@"SKStoreProductViewController: %@", error);
                                   }];
    
    
}

#pragma mark - SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
    
    
   
    
    
    
    

@end
