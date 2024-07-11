//
//  MTNewMenuPoziomDisplay_sandbox.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 21.06.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTNewMenuPoziomDisplay_sandbox.h"
#import "MTButtonsView.h"
#import "MTWebApi.h"
#import "MTNewMenuButton.h"
#import "MTButtonList.h"
@interface MTNewMenuPoziomDisplay_sandbox ()
@property int page;
@property NSString * nick;
@property  NSArray* lista;
//@property MTButtonList* bl;
@property UITextField * text_input;

@end

@implementation MTNewMenuPoziomDisplay_sandbox
-(void) showElements{
    
    

        [self updateList];
        
    
    
}

-(void)refresh{
    [self updateList];
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    _nick=theTextField.text;
    [self updateList];
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
-(void)delete:(NSDictionary*)tdg{
    MTWebApi* mwi = [MTWebApi getInstance];
    [mwi deleteSceneFromDevice:tdg completion:^(BOOL isok){
        if(tdg[@"delegate"] && [tdg[@"delegate"] respondsToSelector:@selector(setAsEmpty)]){
            [tdg[@"delegate"] performSelector:@selector(setAsEmpty) withObject:nil];
        }
    }];

}
-(void)play:(NSDictionary*)tdg{
     ////NSLog(@"PLAY: %@" ,tdg);
    [self.delegate openScene:tdg];

   }

-(void)updateList{
    void (^cb)(NSArray*)=^(NSArray* _lista){
        self.lista = _lista;
        MTButtonList * bl = [[MTButtonList alloc]initWithList:_lista];
        if(self.enabled){[bl setEnabled];}else{[bl setDisabled];}
        bl.delegate = self;
        
        bl.showDownloadAll=FALSE;
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
        
            [mwi getSandboxListcb:(void (^)(NSArray*))cb];
        
            };
    
    
    if(self.xbl!=nil){
            [self.xbl clear];
            [self.xbl removeFromSuperview];
            [self.xbl invalidate];
            self.xbl=nil;
            simpleBlock();
    }else{
        simpleBlock();
    }
    
    
    
    
   
    
    
    
    
}
@end
