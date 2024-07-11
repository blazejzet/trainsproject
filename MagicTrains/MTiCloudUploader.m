//
//  MTiCloudUploader.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 03.10.2015.
//  Copyright © 2015 UMK. All rights reserved.
//

#import "MTiCloudUploader.h"

@implementation MTiCloudUploader{
    int percent;
    NSTimer* tick; //tylok zeby zasymulowac upload.
    void (^pu)(int) ;
    void(^co)(BOOL) ;
}
@synthesize scene;

-(void)startUploadWithProgressUpdate:(void (^)(int))progressUpdate completion:(void(^)(BOOL))completion{
    pu = progressUpdate;
    percent=0;
    co =completion;
    //PONIŻEJ tutaj musi byc wlasciwy kod. ja symuluje upload.
    tick = [NSTimer scheduledTimerWithTimeInterval:1/5 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
}
-(void)tick:(NSTimer*)rt{
    ////NSLog(@"TIcking:%d",percent);
    percent+=1;
    if(percent==100){
        [tick invalidate];
        tick=nil;
        co(TRUE); //metoda wywoływana gdy się udało
        //co(FALSE); gdy sie nie udalo
    }else{
        pu(percent);
    }
    
}
@end
