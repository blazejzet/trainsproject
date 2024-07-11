//
//  MTNewMenuPoziomDisplay_sandbox.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 21.06.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTNewMenuPoziomDisplay_cloud.h"
#import "MTNewMenuPoziomDisplay_cloudmy.h"
#import "MTButtonsView.h"
#import "MTWebApi.h"
#import "MTNewMenuButton.h"
#import "MTButtonList.h"
#import "MTFileManager.h"
@interface MTNewMenuPoziomDisplay_cloud ()
@property int page;
@property NSString * nick;
@property  NSArray* lista;
//@property MTButtonList* bl;
@property UITextField * text_input;

@end

@implementation MTNewMenuPoziomDisplay_cloud
-(void) showElements{
    
    
    if(self.subtype== nil){

    self.przyciski = [NSMutableArray array];
        //[self.przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"cloud" andSubtype:@"my" opened:YES] ];
        [self.przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"cloud" andSubtype:@"all" opened:YES] ];
        [self.przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"cloud" andSubtype:@"people" opened:YES] ];
        //[self.przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"cloud" andSubtype:@"downloaded" opened:YES] ];
        
        [self displayElements];
    }else{
        _page = 0;
        _nick = @"";
        
        [self updateList];
        
    }
    
}
/*
-(void)share:(NSDictionary*)tdg{
    MTWebApi* mwi = [MTWebApi getInstance];
    [mwi shareScene:tdg completion:^(BOOL isok){
    }];
    
}*/

-(void)textFieldDidChange :(UITextField *)theTextField{
   // _nick=theTextField.text;
   // [self updateList];
}

-(void)updateList{
    void (^cb)(NSArray*)=^(NSArray* _lista){
        if(self.waiting_flag==true){
        [self ready];
        self.lista  = _lista;
        ////NSLog(@"CALLBACK WITH LST");
        MTButtonList * bl = [[MTButtonList alloc]initWithList:_lista  andAFM:^(MTButtonList* bl_,int page){
            
            void (^cb2)(NSArray*)=^(NSArray* _lista){
                [bl_ updateList:_lista];
            };
            
            MTWebApi* mwi = [MTWebApi getInstance];
            
            
            if([self.subtype isEqualToString:@"my"]){  //MOJE!!!! WYSLANE
                [mwi getListMyUploadedcb:cb2 page:page];
            }else if([self.subtype isEqualToString:@"people"]){//wszystkie (od najnowszego??) a konkretne osoby - zostawmy na później
                [mwi getCloudListForAll:page cb:cb2];
                //_lista = [mwi getCloudListForUser:@"" page:_page]; //dla kokretnych osób.
            }else if([self.subtype isEqualToString:@"all"]){  //topstarred
                [mwi getTopRatedCloudList:page cb:cb2];
            }
            
        }];
        
        if ([self.subtype isEqualToString:@"my"])
            [bl showListWithDelegate: [[MTNewMenuPoziomDisplay_cloudmy alloc] init] ];
        else
            [bl showListWithDelegate: self];
        [self addSubview:bl];
        [UIView animateWithDuration:0.9 animations:^{
            bl.alpha=1.0;
        } completion:^(BOOL b){
            self.xbl = bl;
        }];
        }
    };
    void (^simpleBlock)(void);
    simpleBlock = ^{
        MTWebApi* mwi = [MTWebApi getInstance];
        [self waiting];
        if([self.subtype isEqualToString:@"my"]){ //JEDNAK ZOSTAŁO TU
            [mwi getListMyUploadedcb:cb];
        }
        if([self.subtype isEqualToString:@"people"]){//wszystkie (od najnowszego??) a konkretne osoby - zostawmy na później
            [mwi getCloudListForAll:0 cb:cb];
            
        }
        if([self.subtype isEqualToString:@"all"]){  //topstarred
            [mwi getTopRatedCloudList:0 cb:cb];
        }
        
        
        
    };
    
    if(self.xbl!=nil){
        [UIView animateWithDuration:0.3 animations:^{
        self.xbl.alpha=0;
        } completion:^(BOOL b){
            [self.xbl removeFromSuperview];
            self.xbl=nil;
            simpleBlock();
            
        }];
    }else{
        simpleBlock();
    }
}








-(void)play:(NSDictionary*)tdg{
    
    //Pobranie i otworzenie.
    ////NSLog(@"DOWNLOADING: %@" ,tdg);
    MTWebApi* mwi = [MTWebApi getInstance];
    
    void (^onFileDownloaded)(NSDictionary*) = ^(NSDictionary* scene){
        ////NSLog(@"Zwrocona zostala scena: %@",scene);
        //scene zawiera uzupełnioną o lokalizację na urządzeniu pobranego pliku.
        [tdg[@"delegate"] performSelector:@selector(showProgress:) withObject:[NSNumber numberWithInt:100]];
        if(scene!=nil){
            ////NSLog(@"Finished uploading");
            if(tdg[@"delegate"] && [tdg[@"delegate"] respondsToSelector:@selector(hideProgressBarSuccess)]){
                [tdg[@"delegate"] performSelector:@selector(hideProgressBarSuccess) withObject:nil];
            }
            [self.delegate openScene:scene];
        }else{
            ////NSLog(@"Downloading failed");
            if(tdg[@"delegate"] && [tdg[@"delegate"] respondsToSelector:@selector(hideProgressBarFailed)]){
                [tdg[@"delegate"] performSelector:@selector(hideProgressBarFailed) withObject:nil];
            }
        }
    };
    
    void (^onFileDownloading)(int) = ^(int progress){
        ////NSLog(@"receiving progress %d" ,progress);
        if(tdg[@"delegate"] && [tdg [@"delegate"] respondsToSelector:@selector(showProgress:)]){
            [tdg[@"delegate"] performSelector:@selector(showProgress:) withObject:[NSNumber numberWithInt:progress]];
        }
    };
    
    if([self.subtype isEqualToString:@"my"]){ //JEDNAK ZOSTAŁO TU
        [mwi downloadMyProjectFromICloud:tdg progressUpdate:onFileDownloading completion: onFileDownloaded];
    }
    if([self.subtype isEqualToString:@"people"]){//wszystkie (od najnowszego??) a konkretne osoby
        [mwi downloadFromICloudScene:tdg progressUpdate: onFileDownloading completion: onFileDownloaded];
    }
    if([self.subtype isEqualToString:@"all"]){  //topstarred
        [mwi downloadFromICloudScene:tdg progressUpdate: onFileDownloading completion: onFileDownloaded];
    }
    

}

-(void)download:(NSDictionary*)tdg withCallback:(void(^)(void))cb{
    
    //Pobranie i otworzenie.
    ////NSLog(@"DOWNLOADING: %@" ,tdg);
    MTWebApi* mwi = [MTWebApi getInstance];
    
    void (^onFileDownloaded)(NSDictionary*) = ^(NSDictionary* scene){
        ////NSLog(@"Zwrocona zostala scena: %@",scene);
        //scene zawiera uzupełnioną o lokalizację na urządzeniu pobranego pliku.
        [tdg[@"delegate"] performSelector:@selector(showProgress:) withObject:[NSNumber numberWithInt:100]];
        if(scene!=nil){
            ////NSLog(@"Finished uploading");
            if(tdg[@"delegate"] && [tdg[@"delegate"] respondsToSelector:@selector(hideProgressBarSuccess)]){
                [tdg[@"delegate"] performSelector:@selector(hideProgressBarSuccess) withObject:nil];
            }
        
        
            MTFileManager *fileManager = [MTFileManager defaultManager];
            NSString *localStoragePath = scene[@"local_file"];
            NSString *localThumbnailPath = scene[@"thumbnail"];
            NSString *localDirectoryForCopy = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/DownloadedScenes"];
            NSString *localDirectoryForDict =  @"Documents/DownloadedScenes";
            NSString *newStoragePathForCopy = [[NSString alloc] initWithFormat:@"%@/%@.mtd", localDirectoryForCopy,[localStoragePath lastPathComponent]];
            NSString *newStoragePathForDict = [[NSString alloc] initWithFormat:@"%@/%@.mtd", localDirectoryForDict,[localStoragePath lastPathComponent]];
            NSString *newThumbnailPathForCopy = [[NSString alloc] initWithFormat:@"%@/%@.png", localDirectoryForCopy,[localThumbnailPath lastPathComponent]];
            NSString *newThumbnailPathForDict = [[NSString alloc] initWithFormat:@"%@/%@.png", localDirectoryForDict,[localThumbnailPath lastPathComponent]];
            
            //[fileManager removeItemAtPath:localDirectory error:nil];
            
            if (![fileManager fileExistsAtPath:localDirectoryForCopy]) {
                [fileManager createDirectoryAtPath:localDirectoryForCopy withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
            if (![fileManager fileExistsAtPath: newThumbnailPathForCopy])
            {
            
                NSMutableDictionary *sceneCopy = (NSMutableDictionary*)scene;
                
                NSError *er = [[NSError alloc] init];
                if ([fileManager copyItemAtPath:localStoragePath toPath:newStoragePathForCopy error:&er])
                {
                    sceneCopy[@"local_file"] = newStoragePathForDict;
                    //[tdg[@"delegate"] performSelector:@selector(hideProgressBarSuccess) withObject:nil];
                    
                } else {
                    
                    //[tdg[@"delegate"] performSelector:@selector(hideProgressBarFailed) withObject:nil];
                    
                }
                
                if([fileManager copyItemAtPath:localThumbnailPath toPath:newThumbnailPathForCopy error:nil])
                {
                    sceneCopy[@"thumbnail"] = newThumbnailPathForDict;
                    //[tdg[@"delegate"] performSelector:@selector(hideProgressBarSuccess) withObject:nil];
                    
                } else {
                    
                    //[tdg[@"delegate"] performSelector:@selector(hideProgressBarFailed) withObject:nil];
                }
                
                [mwi addSceneToList:sceneCopy];
            }
            //NSMutableArray *downloadedArray = [[NSMutableArray init] alloc]
            
            cb();//uruchamiane, bo sie udalo pobrac!!!!
            
            
            
        }else{
            ////NSLog(@"Downloading failed");
            if(tdg[@"delegate"] && [tdg[@"delegate"] respondsToSelector:@selector(hideProgressBarFailed)]){
                [tdg[@"delegate"] performSelector:@selector(hideProgressBarFailed) withObject:nil];
            }
        }
    };
    
    void (^onFileDownloading)(int) = ^(int progress){
        ////NSLog(@"receiving progress %d" ,progress);
        if(tdg[@"delegate"] && [tdg [@"delegate"] respondsToSelector:@selector(showProgress:)]){
            [tdg[@"delegate"] performSelector:@selector(showProgress:) withObject:[NSNumber numberWithInt:progress]];
        }
    };
    
    if([self.subtype isEqualToString:@"my"]){ //JEDNAK ZOSTAŁO TU
        [mwi downloadMyProjectFromICloud:tdg progressUpdate:onFileDownloading completion: onFileDownloaded];
    }
    if([self.subtype isEqualToString:@"people"]){//wszystkie (od najnowszego??) a konkretne osoby
        [mwi downloadFromICloudScene:tdg progressUpdate: onFileDownloading completion: onFileDownloaded];
    }
    if([self.subtype isEqualToString:@"all"]){  //topstarred
        [mwi downloadFromICloudScene:tdg progressUpdate: onFileDownloading completion: onFileDownloaded];
    }
    
    
}
/*
-(void)delete:(NSDictionary*)tdg{
    MTWebApi* mwi = [MTWebApi getInstance];
    [mwi deleteSceneFromDevice:tdg completion:^(BOOL isok){
        if(tdg[@"delegate"] && [tdg[@"delegate"] respondsToSelector:@selector(setAsEmpty)]){
            [tdg[@"delegate"] performSelector:@selector(setAsEmpty) withObject:nil];
        }
    }];
    
}*/
-(void)download:(NSDictionary*)tdg{
    [self download:tdg withCallback:^{}];
}
/*-(void)download:(NSDictionary*)tdg withCallback:(void(^)(void))cb{
    //pobranie i zapisanie w pobranych
    //[self.delegate openScene:tdg];
    //Pobranie i otworzenie.
    ////NSLog(@"DOWNLOADING: %@" ,tdg);
    MTWebApi* mwi = [MTWebApi getInstance];
    [mwi downloadFromICloudScene:tdg progressUpdate:^(int progress){
        ////NSLog(@"receiving progress %d" ,progress);
        if(tdg[@"delegate"] && [tdg[@"delegate"] respondsToSelector:@selector(showProgress:)]){
            [tdg[@"delegate"] performSelector:@selector(showProgress:) withObject:[NSNumber numberWithInt:progress]];
        }
    } completion:^(NSDictionary* scene){
        ////NSLog(@"Zwrocona zostala scena: %@",scene);
        //scene zawiera uzupełnioną o lokalizację na urządzeniu pobranego pliku.
        //metoda completion powinn abyć uruchomiona także  gdy pobieranie sie nie odbyło
        //oznacza to, że scena jest już pobrana.
        [tdg[@"delegate"] performSelector:@selector(showProgress:) withObject:[NSNumber numberWithInt:100]];
        if(scene!=nil){
            ////NSLog(@"Finished uploading");
            if(tdg[@"delegate"] && [tdg[@"delegate"] respondsToSelector:@selector(hideProgressBarSuccess)]){
                [tdg[@"delegate"] performSelector:@selector(hideProgressBarSuccess) withObject:nil];
            }
          
            
            MTFileManager *fileManager = [MTFileManager defaultManager];
            NSString *localStoragePath = scene[@"local_file"];
            NSString *localThumbnailPath = scene[@"thumbnail"];
            NSString *localDirectoryForCopy = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/DownloadedScenes"];
            NSString *localDirectoryForDict =  @"Documents/DownloadedScenes";
            NSString *newStoragePathForCopy = [[NSString alloc] initWithFormat:@"%@/%@.mtd", localDirectoryForCopy,[localStoragePath lastPathComponent]];
            NSString *newStoragePathForDict = [[NSString alloc] initWithFormat:@"%@/%@.mtd", localDirectoryForDict,[localStoragePath lastPathComponent]];
            NSString *newThumbnailPathForCopy = [[NSString alloc] initWithFormat:@"%@/%@.png", localDirectoryForCopy,[localThumbnailPath lastPathComponent]];
            NSString *newThumbnailPathForDict = [[NSString alloc] initWithFormat:@"%@/%@.png", localDirectoryForDict,[localThumbnailPath lastPathComponent]];
            
            //[fileManager removeItemAtPath:localDirectory error:nil];
            
            if (![fileManager fileExistsAtPath:localDirectoryForCopy]) {
                [fileManager createDirectoryAtPath:localDirectoryForCopy withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
            NSMutableDictionary *sceneCopy = (NSMutableDictionary*)scene;
            
            NSError *er = [[NSError alloc] init];
            if ([fileManager copyItemAtPath:localStoragePath toPath:newStoragePathForCopy error:&er])
            {
                sceneCopy[@"local_file"] = newStoragePathForDict;
                //[tdg[@"delegate"] performSelector:@selector(hideProgressBarSuccess) withObject:nil];
                
            } else {
    
                //[tdg[@"delegate"] performSelector:@selector(hideProgressBarFailed) withObject:nil];
                
            }
            
            if([fileManager copyItemAtPath:localThumbnailPath toPath:newThumbnailPathForCopy error:nil])
            {
                sceneCopy[@"thumbnail"] = newThumbnailPathForDict;
                //[tdg[@"delegate"] performSelector:@selector(hideProgressBarSuccess) withObject:nil];
                
            } else {
                
                //[tdg[@"delegate"] performSelector:@selector(hideProgressBarFailed) withObject:nil];
            }
            
            [mwi addSceneToList:sceneCopy];
            
            //NSMutableArray *downloadedArray = [[NSMutableArray init] alloc]
            
            cb();//uruchamiane, bo sie udalo pobrac!!!!
            //cb() odpai nastepne pobieranie kolejnego pliku.
        }else{
            ////NSLog(@"Downloading failed");
            if(tdg[@"delegate"] && [tdg[@"delegate"] respondsToSelector:@selector(hideProgressBarFailed)]){
                [tdg[@"delegate"] performSelector:@selector(hideProgressBarFailed) withObject:nil];
            }
        }
    }];
    
    
}*/




@end
