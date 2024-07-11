//
//  MTNewMenuPoziomDisplay_book.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 21.06.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTNewMenuPoziomDisplay_contest.h"
#import "MTNewMenuButton.h"
#import "MTWebApi.h"
#import "MTButtonList.h"

@interface MTNewMenuPoziomDisplay_contest()
@property int page;
@property NSString * nick;
@property  NSArray* lista;
//@property MTButtonList* bl;

@end
@implementation MTNewMenuPoziomDisplay_contest

-(void) showElements{
    
   
    
    
    if(self.subtype== nil){
        //DODAIE PRZYCISKOW KATEGORII
        
        self.przyciski = [NSMutableArray array];
        [self.przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"contest" andSubtype:@"1" opened:YES] ];
        [self.przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"contest" andSubtype:@"2" opened: YES ]];
        
        [self.przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"contest" andSubtype:@"3" opened: false ]];
        
        [self.przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"contest" andSubtype:@"4" opened: false ]];
        
        [self.przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"contest" andSubtype:@"5" opened: false ]];
        
        [self.przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"contest" andSubtype:@"6" opened: false ]];
        [self.przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"contest" andSubtype:@"7" opened: false ]];
        
        [self displayElements];
        
    }else{
        ////NSLog(@"Wyswietlanie zadan z kategorii %@", self.subtype);
        
        _page = 0;
        _nick = @"";
        
        [self updateList];
    }
}





-(void)play:(NSMutableDictionary*)tdg{
    //Sprawdzenie czy jest available_offline
    //Zawsze offline!
    //Tłumaczymy napisy typu "task://" na prawdziwe ścieżki
    tdg[@"local_file"]=[MTWebApi tanslateToLocalPath:tdg[@"file"]];
    tdg[@"local_thumbnail"]=[MTWebApi tanslateToLocalPath:tdg[@"thumbnail"]];
    tdg[@"local_limits"]=[MTWebApi tanslateToLocalPath:tdg[@"limits"]];
    tdg[@"local_task"]=[MTWebApi tanslateToLocalPath:tdg[@"task"]];
    tdg[@"local_taskPro"]=[MTWebApi tanslateToLocalPath:tdg[@"taskPro"]];
    
    [self.delegate openScene:tdg];
    
    /*
    if([@"true" isEqualToString: tdg[@"available_offline"]]){
        //jest offline
        [self.delegate openScene:tdg];
    }else{
        //Pobranie i otworzenie zadania
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
            [self.delegate openScene:scene];
        }else{
            ////NSLog(@"Downloading failed");
            if(tdg[@"delegate"] && [tdg[@"delegate"] respondsToSelector:@selector(hideProgressBarFailed)]){
                [tdg[@"delegate"] performSelector:@selector(hideProgressBarFailed) withObject:nil];
            }
        }
    }];
    }*/
}



-(void)download:(NSDictionary*)tdg{
    [self download:tdg withCallback:^{}];
}
-(void)download:(NSDictionary*)tdg withCallback:(void(^)(void))cb{

    
    //Pobranie i otworzenie zadania
    ////NSLog(@"DOWNLOADING Contest: %@" ,tdg);
    
    //uzupełnić ścieżkę!!!.
    
    cb();
//w zasadzie to niepotrzebne, od kiedy zadania są znów w paczce.
    /*
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
            cb();//nie otwieramy sceny
        }else{
            ////NSLog(@"Downloading failed");
            if(tdg[@"delegate"] && [tdg[@"delegate"] respondsToSelector:@selector(hideProgressBarFailed)]){
                [tdg[@"delegate"] performSelector:@selector(hideProgressBarFailed) withObject:nil];
            }
        }
    }];
     */
}


-(void)updateList{
    void (^simpleBlock)(void);
    void (^cb)(NSArray*)=^(NSArray* _lista){
        if(_lista.count>0){
            [self ready];
        }else{
            [self waiting];
        }
        
        ////NSLog(@"%@",_lista);
        MTButtonList * bl = [[MTButtonList alloc]initWithList:_lista];
        bl.delegate = self;

        self.lista=_lista;
        [bl showList];
        [self addSubview:bl];
        [UIView animateWithDuration:0.9 animations:^{
            bl.alpha=1.0;
        } completion:^(BOOL b){
            self.xbl = bl;
        }];
    };
    
    simpleBlock = ^{
        MTWebApi* mwi = [MTWebApi getInstance];
        [mwi getContestFiles:self.subtype cb:cb];
        
       
    };
    //[self waiting];
    
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





@end
