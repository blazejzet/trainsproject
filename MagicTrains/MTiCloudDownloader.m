//
//  MTiCloudDownloader.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 03.10.2015.
//  Copyright © 2015 UMK. All rights reserved.
//

#import "MTiCloudDownloader.h"
#import "MTWebApi.h"
@interface MTiCloudDownloader()
    @property (nonatomic) int percent;
    @property (nonatomic,strong) void (^pu)(int) ;
    @property (nonatomic,strong) void(^co)(NSDictionary*) ;
    @property (nonatomic,strong) NSTimer* tick;
   
@end

@implementation MTiCloudDownloader
@synthesize scene;


//NSDictionary* Zawiera opis sceny wraz z informacjami gdzie znajduje się plik. zmienna file wskazująca na lokalny plik???
-(void)startDownloadWithProgressUpdate:(void (^)(int))progressUpdate completion:(void(^)(NSDictionary*))completion{
    _pu = progressUpdate;
    _percent=0;
    _co =completion;
    //PONIŻEJ tutaj musi byc wlasciwy kod. ja symuluje upload.
    
    _tick = [NSTimer scheduledTimerWithTimeInterval:1/5 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
}
-(void)tick:(NSTimer*)rt{
    ////NSLog(@"Dowloadning scene:%d",_percent);
    _percent+=1;
    if(_percent==100){
        [_tick invalidate];
        _tick=nil;
        NSMutableDictionary* d = [[NSMutableDictionary alloc]initWithDictionary:scene];
        //tymczasowo uzupełniam ścieżką z bundla
        //po popbraniu powinno to być w jakiejś zapisywalnej ścieżce
    
        
        //d[@"local_file"]=[[NSBundle mainBundle] pathForResource:@"u1" ofType:@"mtd"];
        _co(d);
        
        //_co(nil); //metoda wywoływana gdy się udało
        
    }else{
        _pu(_percent);
    }
    
}

-(void)startDownloadThumbnailWithProgressUpdate:(void (^)(int))progressUpdate completion:(void(^)(NSDictionary*))completion{
    _pu = progressUpdate;
    _percent=0;
    _co =completion;
    //PONIŻEJ tutaj musi byc wlasciwy kod. ja symuluje upload.
    //losowanie czasu, żeby zasymulować  różne predkości
    _tick = [NSTimer scheduledTimerWithTimeInterval:1/(8+arc4random()%20) target:self selector:@selector(tickThumbnail:) userInfo:nil repeats:YES];
}
-(void)tickThumbnail:(NSTimer*)rt{
    //////NSLog(@"Dowloadning Thumbnail:%d",_percent);
    _percent+=1;
    if(_percent==100){
        [_tick invalidate];
        _tick=nil;
        NSMutableDictionary* d = [[NSMutableDictionary alloc]initWithDictionary:scene];
        //tymczasowo uzupełniam ścieżką z bundla
        //po popbraniu powinno to być w jakiejś zapisywalnej ścieżce
        if([scene[@"file"] hasPrefix:@"icloud://"]) d[@"local_thumbnail_file"]=[[NSBundle mainBundle] pathForResource:@"i1" ofType:@"jpg"];
        if([scene[@"file"] hasPrefix:@"book://"]) d[@"local_thumbnail_file"]=[[NSBundle mainBundle] pathForResource:@"b1" ofType:@"jpg"];
        if([scene[@"file"] hasPrefix:@"task://"]) d[@"local_thumbnail_file"]=[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"t%d",arc4random()%3] ofType:@"jpg"];
        _co(d);
        
        //_co(nil); //metoda wywoływana gdy się udało
        
    }else{
        _pu(_percent);
    }
    
}


-(void)startDownloadObjectiveWithProgressUpdate:(void (^)(int))progressUpdate completion:(void(^)(NSDictionary*))completion{
    _pu = progressUpdate;
    _percent=0;
    _co =completion;
    //PONIŻEJ tutaj musi byc wlasciwy kod. ja symuluje upload.
    _tick = [NSTimer scheduledTimerWithTimeInterval:1/5 target:self selector:@selector(tickObjective:) userInfo:nil repeats:YES];
}
-(void)tickObjective:(NSTimer*)rt{
    ////NSLog(@"Dowloadning Objective:%d",_percent);
    _percent+=1;
    if(_percent==100){
        [_tick invalidate];
        _tick=nil;
        NSMutableDictionary* d = [[NSMutableDictionary alloc]initWithDictionary:scene];
        //tymczasowo uzupełniam ścieżką z bundla
        //po popbraniu powinno to być w jakiejś zapisywalnej ścieżce
        d[@"local_objective_file"]=[[NSBundle mainBundle] pathForResource:@"ob1" ofType:@"jpg"];
        _co(d);
        
        //_co(nil); //metoda wywoływana gdy się udało
        
    }else{
        _pu(_percent);
    }
    
}
@end