//
//  MTNewMenuPoziomDisplay_sandbox.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 21.06.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTNewMenuPoziomDisplay_cloud_downloaded.h"
#import "MTButtonsView.h"
#import "MTWebApi.h"
#import "MTNewMenuButton.h"
#import "MTButtonList.h"
@interface MTNewMenuPoziomDisplay_cloud_downloaded ()
@property int page;
@property NSString * nick;
@property  NSArray* lista;
//@property MTButtonList* bl;
@property UITextField * text_input;

@end

@implementation MTNewMenuPoziomDisplay_cloud_downloaded
-(void) showElements{
            _page = 0;
        _nick = @"";
        
        [self updateList];
    
}

-(void)textFieldDidChange :(UITextField *)theTextField{
   // _nick=theTextField.text;
   // [self updateList];
}

-(void)updateList{
    void (^cb)(NSArray*)=^(NSArray* _lista){
        if (_lista.count==0){[self waiting];}else{
        [self ready];
        }
         
        NSString *homeDirectory = NSHomeDirectory();
        
        for (NSMutableDictionary *dict in _lista)
        {
            NSString *localFileBefore = dict[@"local_file"];
            NSString *localThumbnailBefore = dict[@"thumbnail"];
            
            if (![localFileBefore hasPrefix:homeDirectory])
            {
                int range = [localFileBefore rangeOfString:@"Documents/"].location;
                localFileBefore = [localFileBefore substringFromIndex:range];
                NSString *newFile = [[NSString alloc] initWithFormat:@"%@/%@", homeDirectory, localFileBefore];
                dict[@"local_file"] = newFile;
            }
            
            if (![localThumbnailBefore hasPrefix:homeDirectory])
            {
                int range = [localThumbnailBefore rangeOfString:@"Documents/"].location;
                localThumbnailBefore = [localThumbnailBefore substringFromIndex:range];
                NSString *newThumbnail = [[NSString alloc] initWithFormat:@"%@/%@", homeDirectory, localThumbnailBefore];
                dict[@"thumbnail"] = newThumbnail;
            }
        }
        
        ////NSLog(@"CALLBACK WITH LST");
        
        MTButtonList * bl = [[MTButtonList alloc]initWithList:_lista andAFM:^(MTButtonList* bl_,int page){
            
             void (^cb2)(NSArray*)=^(NSArray* _lista){
                 [self ready];
                 [bl_ updateList:_lista];
             };
            
            MTWebApi* mwi = [MTWebApi getInstance];
            //[mwi getDownloadedListcb:cb2];
            // TODO STRONNICOWANIE??? ROBIMY???? - TAAK!!!
            
            
        }];
        bl.delegate = self;
        
        [bl showList];
        [self addSubview:bl];
        [UIView animateWithDuration:0.9 animations:^{
            bl.alpha=1.0;
        } completion:^(BOOL b){
            self.xbl = bl;
        }];
    };
    void (^simpleBlock)(void);
    simpleBlock = ^{
        MTWebApi* mwi = [MTWebApi getInstance];
            //[mwi getListMyUploadedcb:cb];
            //[self waiting];
            [mwi getDownloadedListcb:cb];
        
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
    /*////NSLog(@"DOWNLOADING: %@" ,tdg);
    MTWebApi* mwi = [MTWebApi getInstance];
    [mwi downloadFromICloudScene:tdg progressUpdate:^(int progress){
        ////NSLog(@"receiving progress %d" ,progress);
        if(tdg[@"delegate"] && [tdg[@"delegate"] respondsToSelector:@selector(showProgress:)]){
            [tdg[@"delegate"] performSelector:@selector(showProgress:) withObject:[NSNumber numberWithInt:progress]];
        }
    } completion:^(NSDictionary* scene){
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
    }];*/
    
    [self.delegate openScene:tdg];
	
}
-(void)delete:(NSDictionary*)tdg{
    MTWebApi* mwi = [MTWebApi getInstance];
    
    [mwi deleteSceneFromDevice:tdg];
    
    //NALEZY DOIMPLEMENTOWAC ODSWIEZANIE LISTY POBRANYCH...
    /*[mwi deleteDownloaded:tdg completion:^(BOOL isok){
        if(tdg[@"delegate"] && [tdg[@"delegate"] respondsToSelector:@selector(setAsEmpty)]){
            [tdg[@"delegate"] performSelector:@selector(setAsEmpty) withObject:nil];
        }
    }];*/
    
}

-(void)upload:(NSDictionary*)tdg{
    ////NSLog(@"UPLOAD: %@" ,tdg);
    
    
    
    MTWebApi* mwi = [MTWebApi getInstance];
    [mwi uploadToICloudScene:tdg progressUpdate:^(int progress){
        ////NSLog(@"receiving progress %d" ,progress);
        if(tdg[@"delegate"] && [tdg[@"delegate"] respondsToSelector:@selector(showProgress:)]){
            [tdg[@"delegate"] performSelector:@selector(showProgress:) withObject:[NSNumber numberWithInt:progress]];
        }
    } completion:^(BOOL isok){
        [tdg[@"delegate"] performSelector:@selector(showProgress:) withObject:[NSNumber numberWithInt:100]];
        if(isok){
            ////NSLog(@"Finished uploading");
            if(tdg[@"delegate"] && [tdg[@"delegate"] respondsToSelector:@selector(hideProgressBarSuccess)]){
                [tdg[@"delegate"] performSelector:@selector(hideProgressBarSuccess) withObject:nil];
            }
        }else{
            ////NSLog(@"Uploading failed");
            if(tdg[@"delegate"] && [tdg[@"delegate"] respondsToSelector:@selector(hideProgressBarFailed)]){
                [tdg[@"delegate"] performSelector:@selector(hideProgressBarFailed:) withObject:nil];
            }
        }
        
        
        
    }];
}


/*-(void)share:(NSDictionary*)tdg{
    MTWebApi* mwi = [MTWebApi getInstance];
    [mwi shareScene:tdg completion:^(BOOL isok){
            }];
    
 -(void)upload:(NSDictionary*)tdg{
 ////NSLog(@"UPLOAD: %@" ,tdg);
 MTWebApi* mwi = [MTWebApi getInstance];
 [mwi uploadToICloudScene:tdg progressUpdate:^(int progress){
 ////NSLog(@"receiving progress %d" ,progress);
 if(tdg[@"delegate"] && [tdg[@"delegate"] respondsToSelector:@selector(showProgress:)]){
 [tdg[@"delegate"] performSelector:@selector(showProgress:) withObject:[NSNumber numberWithInt:progress]];
 }
 } completion:^(BOOL isok){
 [tdg[@"delegate"] performSelector:@selector(showProgress:) withObject:[NSNumber numberWithInt:100]];
 if(isok){
 ////NSLog(@"Finished uploading");
 if(tdg[@"delegate"] && [tdg[@"delegate"] respondsToSelector:@selector(hideProgressBarSuccess)]){
 [tdg[@"delegate"] performSelector:@selector(hideProgressBarSuccess) withObject:nil];
 }
 }else{
 ////NSLog(@"Uploading failed");
 if(tdg[@"delegate"] && [tdg[@"delegate"] respondsToSelector:@selector(hideProgressBarFailed)]){
 [tdg[@"delegate"] performSelector:@selector(hideProgressBarFailed:) withObject:nil];
 }
 }
 
 
 
 }];
 }
 
}*/
/*-(void)download:(NSDictionary*)tdg{
    [self download:tdg withCallback:^{}];
}
-(void)download:(NSDictionary*)tdg withCallback:(void(^)(void))cb{
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
        [tdg[@"delegate"] performSelector:@selector(showProgress:) withObject:[NSNumber numberWithInt:100]];
        if(scene!=nil){
            ////NSLog(@"Finished uploading");
            if(tdg[@"delegate"] && [tdg[@"delegate"] respondsToSelector:@selector(hideProgressBarSuccess)]){
                [tdg[@"delegate"] performSelector:@selector(hideProgressBarSuccess) withObject:nil];
            }
            //[self.delegate openScene:scene];
            //TUTAJ ZAPISANIE scene na liście pobranych
            //PLIK TEŻ MUSI SIĘ ZNALEŹĆ W JAKIMS KATALGOU
            cb();
            [mwi addSceneToList:scene];
        }else{
            ////NSLog(@"Downloading failed");
            if(tdg[@"delegate"] && [tdg[@"delegate"] respondsToSelector:@selector(hideProgressBarFailed)]){
                [tdg[@"delegate"] performSelector:@selector(hideProgressBarFailed) withObject:nil];
            }
        }
    }];
}*/




@end
