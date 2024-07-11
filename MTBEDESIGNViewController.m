//
//  MTBEDESIGNViewController.m
//  MagicTrains
//
//  Created by Blazej Zyglarski on 02.03.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTBEDESIGNViewController.h"
#import "MTAudioPlayer.h"
#import "MTCloudKitController.h"
#import "MTUserStorageLoader.h"

@interface MTBEDESIGNViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *splash;

@end


@implementation MTBEDESIGNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _splash.frame=self.view.frame;
    
    [[MTAudioPlayer instanceMTAudioPlayer] play:@"background_start"];
    [MTCloudKitController checkIfUserLoggedToICloud];
    [[[MTUserStorageLoader alloc] init] loadSucc:^(MTUserStorage* us){
        ////NSLog(@"Uruchamiam gre");
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self performSelectorOnMainThread:@selector(loadGame)
                                   withObject:nil waitUntilDone:YES];
        });
        //[self performSelector:@selector(loadGame) withObject:nil afterDelay:1.01];
    } Fail:^(NSString* msg){
        //NSLog(@"%@",msg);
    
    }];
    
    //== false) {
       // UIAlertView *a = [MTCloudKitController getAlertNotConnected:self];
       // [a show];
    //}
    
  //  NSMutableURLRequest *request = [[MTWebApi getInstance] getAccessTokenRequest];
  //  [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //NSString *apiKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"apiKey"];
    
    //if(!apiKey) {
        NSError *error = nil;
        NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSString *apiKey = [jsonArray objectForKey:@"access_token"];
        
        [[NSUserDefaults standardUserDefaults] setObject:apiKey forKey:@"apiKey"];
    //}
    
    //NSMutableURLRequest *request = [[MTWebApi getInstance] saveGameWithPath:@""];
    //[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    ////NSLog(@"Did Fail");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadGame{
    [self performSegueWithIdentifier:@"PresentStartup" sender:self];
}

@end
