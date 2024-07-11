//
//  MTNewMenuPoziomDisplay_book.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 21.06.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTNewMenuPoziomDisplay_book.h"
#import "MTNewMenuButton.h"
#import "MTWebApi.h"
#import "MTButtonList.h"

@interface MTNewMenuPoziomDisplay_book()
@property int page;
@property NSString * nick;
@property  NSArray* lista;
//@property MTButtonList* bl;

@end
@implementation MTNewMenuPoziomDisplay_book

-(void) showElements{
    
   
    
    
    if(self.subtype== nil){
        //DODAIE PRZYCISKOW KATEGORII
        
        self.przyciski = [NSMutableArray array];
        
        [self.przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"book" andSubtype:@"basics" opened:YES] ];
        [self.przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"book" andSubtype:@"ghosts" opened:YES] ];
        [self.przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"book" andSubtype:@"messaging" opened:YES] ];
        [self.przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"book" andSubtype:@"loops" opened:YES] ];
        [self.przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"book" andSubtype:@"math" opened:YES] ];
        [self.przyciski addObject:[[MTNewMenuButton alloc] initWithType:@"book" andSubtype:@"physics" opened:YES] ];
        [self displayElements];
        
    }else{
        ////NSLog(@"Wyswietlanie zadan z kategorii %@", self.subtype);
        
        _page = 0;
        _nick = @"";
        
        [self updateList];
    }
}





-(void)play:(NSDictionary*)tdg{
    
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
        [mwi getBookFiles:self.subtype cb:cb];
        
       
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
