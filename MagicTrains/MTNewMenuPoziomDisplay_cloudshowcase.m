//
//  MTNewMenuPoziomDisplay_sandbox.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 21.06.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

// TO JEST CKLASA KTÓRA POKAZUJE FANJE RZECZY Z CLOUDA.
// NA RAZIE JEST KOPIA CLOUDMY
// TRZEBA DODAĆ INNE ZAPYTANIE.

// PROPONUJĘ DODAC jakieś pole typu "isshowcase" i wtedy w chmurze ogólnej te elementy pomijać
// a tutaj pobrać wszystkie które mają to ustawione
// wtedy będzie załatwione chmurowe dodawanie rzeczy.

#import "MTNewMenuPoziomDisplay_cloudshowcase.h"
#import "MTButtonsView.h"
#import "MTWebApi.h"
#import "MTNewMenuButton.h"
#import "MTButtonList.h"
#import "MTFileManager.h"
@interface MTNewMenuPoziomDisplay_cloudshowcase ()
@property int page;
@property NSString * nick;
@property  NSArray* lista;
//@property MTButtonList* bl;
@property UITextField * text_input;

@end

@implementation MTNewMenuPoziomDisplay_cloudshowcase

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
        
                
        ////NSLog(@"CALLBACK WITH LST");
        
        MTButtonList * bl = [[MTButtonList alloc]initWithList:_lista andAFM:^(MTButtonList* bl_,int page){
            
            void (^cb2)(NSArray*)=^(NSArray* _lista){
                [self ready];
                [bl_ updateList:_lista];
            };
            
            MTWebApi* mwi = [MTWebApi getInstance];
            
            
            
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
        [mwi getShowcaseListcb:cb];
        
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
    
   
    
    [self.delegate openScene:tdg];
    
}

@end
