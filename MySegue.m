//
//  MySegue.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 05.10.2015.
//  Copyright © 2015 UMK. All rights reserved.
//

#import "MySegue.h"
#import "MTViewController.h"

@implementation MySegue
@synthesize spoint;

@synthesize delegate = delegate_;


-(void)perform{
    UIViewController *sourceViewController = self.sourceViewController;
    
    
    
    UIImageView* u = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_bg_red"]];
    UIImageView* dv= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading"]];
    dv.contentMode=UIViewContentModeCenter;
    dv.clipsToBounds=true;
    dv.frame=sourceViewController.view.frame;
    u.center=self.spoint;
    u.bounds=CGRectMake(0,0,10,10);
    u.alpha=0.5;
    
    
    [sourceViewController.view addSubview:u];
    
    [sourceViewController.view addSubview:dv];
    
    CGPoint originalCenter = CGPointMake(sourceViewController.view.center.x+sourceViewController.view.frame.size.width, sourceViewController.view.center.y) ;
    
    dv.center = CGPointMake(sourceViewController.view.center.x, sourceViewController.view.center.y+sourceViewController.view.frame.size.height) ;
    
    CGPoint newCenter = CGPointMake(sourceViewController.view.center.x, sourceViewController.view.center.y-sourceViewController.view.frame.size.height) ;
    
    //destinationViewController.view.clipsToBounds=YES;
    sourceViewController.view.clipsToBounds=NO;
    [UIView animateWithDuration:0.9
     
                     animations:^{
                         u.bounds=CGRectMake(0,0,2000, 2000);
                         u.alpha=0;
                     }];
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         sourceViewController.view.center = newCenter;
                         
                     }
                     completion:^(BOOL finished){
                         
                         [sourceViewController presentViewController:self.destinationViewController animated:NO completion:^{
                             
                             [(MTViewController*)self.destinationViewController
                              performSelector:@selector(initinmenu) withObject:nil afterDelay:0.0];
                             
                         }];
                         
                     }];
}




-(void)performx{
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;
    
    
    UIImageView* u = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_bg_red"]];
    u.center=self.spoint;
    u.bounds=CGRectMake(0,0,10,10);
    u.alpha=0.5;
    
    
    [sourceViewController.view addSubview:u];
    
    [sourceViewController.view addSubview:destinationViewController.view];
    
    CGPoint originalCenter = CGPointMake(sourceViewController.view.center.x+sourceViewController.view.frame.size.width, sourceViewController.view.center.y) ;
    
    destinationViewController.view.center = CGPointMake(sourceViewController.view.center.x, sourceViewController.view.center.y+sourceViewController.view.frame.size.height) ;
    
    CGPoint newCenter = CGPointMake(sourceViewController.view.center.x, sourceViewController.view.center.y-sourceViewController.view.frame.size.height) ;
    
    destinationViewController.view.clipsToBounds=YES;
    sourceViewController.view.clipsToBounds=NO;
    [UIView animateWithDuration:0.9
     
                     animations:^{
                         u.bounds=CGRectMake(0,0,2000, 2000);
                         u.alpha=0;
                     }];
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         sourceViewController.view.center = newCenter;
                         
                     }
                     completion:^(BOOL finished){
                         
                         sourceViewController.view.clipsToBounds=YES;
                         
                         [destinationViewController.view removeFromSuperview];
                         
                         [sourceViewController presentViewController:destinationViewController animated:NO completion:^{
                             
                             [(MTViewController*)destinationViewController performSelector:@selector(initinmenu) withObject:nil afterDelay:0.0];
                             
                         }];
                         
                     }];
}
@end
