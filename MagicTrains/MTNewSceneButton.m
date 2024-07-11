//
//  MTNewSceneButton.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 30.07.2015.
//  Copyright © 2015 UMK. All rights reserved.
//

#import "MTNewSceneButton.h"
#import <QuartzCore/QuartzCore.h>
#import "MTWebApi.h"
#import "MTAvatarView.h"
#import "TestView.h"
#import "MTGUI.h"

@interface MTNewSceneButton ()
@property    UIImageView * star ;
@property    UIImageView * star2 ;
@property    UIImageView * star3 ;
@property    UIImageView * star4 ;
@property    UIImageView * star5 ;

@property    CGPoint setPoint;


@property NSMutableDictionary* scene;
@property  UIImageView* bg;
@property  UIImageView* miniature;
@property  UIImageView* miniature_bg;
@property (weak) MTAvatarView* mavatar;
@property TestView* progressBar;
@property NSMutableArray* stars;
@property BOOL shown;
@property BOOL enabled;





@end
@implementation MTNewSceneButton
@synthesize delegate;
@synthesize enabled;
@synthesize buttonsdelegate;
@synthesize stars;
@synthesize shown;

@synthesize star;
@synthesize star2;
@synthesize star3;
@synthesize star4;
@synthesize star5;
@synthesize setPoint;

-(void)setNewPosition:(CGPoint)p{
    [self setNewPosition:p animated:YES];
}
-(void)setNewPosition:(CGPoint)p animated:(BOOL)animated{
    setPoint=p;
    if(animated) {
    [UIView animateWithDuration:0.3 animations:^{
    self.center=p;
    //////NSLog()
    if(p.x>160 &&p.x<=260){
        self.center = CGPointMake(p.x+150, p.y);
    }
    if(p.x>260 ){
        self.center = CGPointMake(p.x+300, p.y);
    }
    }];
    }else{
        self.center=p;
        if(p.x>160 &&p.x<=260){
            self.center = CGPointMake(p.x+150, p.y);
        }
        if(p.x>260 ){
            self.center = CGPointMake(p.x+300, p.y);
        }
    }
    
    CGFloat x =0;
    
    p = self.center;
    
    if (p.x<100){
        x = p.x;
    }else if(p.x>WIDTH-100){
        x = WIDTH - p.x;
        
    }
    else{
        x=100;
    }
    if(x<0)x=0;
    self.alpha= x/100;
    
    if (p.x>160 && p.x<560){
        [self select];
    }else{
        [self reset];
    }
}


/*
 
 -(void)setNewPosition:(CGPoint)p animated:(BOOL)animated{
 setPoint=p;
 if (p.x<420 ){
 if (p.x>310){
 if(fabs(self.center.x-(p.x-90))>10){
 if(animated){[UIView animateWithDuration:0.2 animations:^{
 self.center=CGPointMake(p.x-90, p.y);
 [self select];
 }];}else{
 self.center=CGPointMake(p.x-90, p.y);
 [self select];
 }
 
 }else{
 self.center=CGPointMake(p.x-90, p.y);
 //[self reset];
 }
 }else{
 if(fabs(self.center.x-(p.x-170))>10){
 if(animated){[UIView animateWithDuration:0.2 animations:^{
 self.center=CGPointMake(p.x-170, p.y);
 // [self reset];
 }];}else{
 self.center=CGPointMake(p.x-170, p.y);
 }
 }else{
 self.center=CGPointMake(p.x-170, p.y);
 //  [self reset];
 }
 }
 }else{
 if(fabs(self.center.x-(p.x))>10){
 if(animated){[UIView animateWithDuration:0.2 animations:^{
 self.center=p;
 
 }];}else{
 self.center=p;
 }
 }else{
 self.center=p;
 }
 }
 
 
 
 CGFloat x =0;
 
 p = self.center;
 
 if (p.x<100){
 x = p.x;
 }else if(p.x>WIDTH-100){
 x = WIDTH - p.x;
 
 }
 else{
 x=100;
 }
 if(x<0)x=0;
 self.alpha= x/100;
 
 if (p.x<160){
 [self reset];
 }else
 if (p.x>340){
 [self reset];
 } else{
 [self select];
 }
 }
*/
-(id)initWithScene:(NSDictionary*)scene{
    
   //NSLog(@"Creating button with file: %@",scene[@"file"]);
    self = [super initWithFrame:CGRectMake(0, 0, 176/2,176/2)];
    _scene=scene;
    self.stars = [NSMutableArray array];
    if(self){
        [self setup];
       //NSLog(@"Creating retain count is %ld", CFGetRetainCount((__bridge CFTypeRef)self));
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteRemotelyFull)
                                                 name:@"RemoteAllClear"
                                               object:nil];

    return self;

}

-(void)dealloc{
   //NSLog(@"Dealloc button with file: %@",self.scene[@"file"]);
    
}
-(void)clear{
    for(UIView * s in self.subviews){
        [s removeFromSuperview];
    }
     NSMutableDictionary * d  = [[NSMutableDictionary alloc]initWithDictionary:self.scene];
        d[@"thumbnail"]=@"";
    self.scene = d;
}



-(void)setInactiveSharedButton{
    if(star5 != nil){
        [star5 setUserInteractionEnabled:false];
        star5.alpha=0.2;
    }
}
-(void)setActiveSharedButton{
    if(star5 != nil){
        [star5 setUserInteractionEnabled:true];
        star5.alpha=1.0;
    }
}
-(void)setShared{
    if(star5 != nil){
        [self setActiveSharedButton];
        UIImage * i = [UIImage imageNamed:@"scene_share_selected"];
        star5.image = i;
    }
}
-(void)setUnShared{
    
    if(star5 != nil){
         [self setActiveSharedButton];
        star5.image = [UIImage imageNamed:@"scene_share"];
    }
}

-(void)setup{
    //TRANSLATE
    ////NSLog(@"Miniature: %@",_scene[@"thumbnail"]);
    NSString * tn = _scene[@"thumbnail"];
   
    NSNumber* appVersion = [MTWebApi getAppVersion];
    if(_scene[@"AppVersion"]!=nil){
        appVersion =_scene[@"AppVersion"];
    }
    
    
    
    if([@"false" isEqualToString:self.scene[@"opened"]] || ([appVersion intValue] > [[MTWebApi getAppVersion] intValue])){
        _bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_bg_red"]];
    }else{
        _bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_bg"]];
    }
    [_bg setBounds:CGRectMake(0, 0, 156/2, 156/2)];
    [self addSubview:_bg];
    _bg.alpha = 1;
    //self.type=type;
    //[self getImage];
    //[self performSelectorInBackground:@selector(getImage) withObject:nil];
    [self setUserInteractionEnabled:YES];
    [_bg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)]];
    
    _miniature_bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_bg_black"]];
    [_miniature_bg setBounds:CGRectMake(0, 0, 146/2, 146/2)];
    _miniature = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wooden_bg"]];
    
    if ([tn hasPrefix:@"/"] || [tn hasPrefix:@"saved://"] || [tn hasPrefix:@"task://"] || [tn hasPrefix:@"book://"]){
        
        if(![tn hasPrefix:@"/"]){
        tn = [MTWebApi tanslateToLocalPath:_scene[@"thumbnail"]];
        }
        _miniature.image =[UIImage imageWithContentsOfFile:tn];
        //lokalny
    }else if([tn hasPrefix:@"icloud://"] ){ /// jak poznać sieciowy?
        
        [[MTWebApi getInstance]downloadThumbnailFromICloudScene:self.scene progressUpdate:^(int a){} completion:^(NSDictionary* scene){
                //tutaj ustawienie obrazka
                [UIView transitionWithView:_miniature
                                  duration:0.2f
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    _miniature.image = [UIImage imageWithContentsOfFile: scene[@"local_thumbnail_file"]];
                                } completion:NULL];
        }];
    }
    [_miniature setBounds:CGRectMake(0, 0, 136/2, 136/2)];
    [_miniature setContentMode: UIViewContentModeScaleAspectFill];
    
    [self addSubview:_miniature_bg];
    [self addSubview:_miniature];
    _miniature.layer.cornerRadius =  136/4;
    _miniature.layer.masksToBounds = YES;
    _miniature.center=_miniature_bg.center;
    
    [self showStars];
    [self showStars2];
    [self showAvatar];
    
    
    
    
}

-(void)showStars{
    
    ///stars
    
}


-(void)showAvatar{
    
    //stars
    NSString*  st =(NSString *)[_scene objectForKey:@"avatar"];
    //NSString* st = @"10-4-4-4";
    
    MTAvatarView * mavatar  = [[[MTAvatarView alloc]initWithData:st]small];
    self.mavatar = mavatar;
    //_mavatar.center=CGPointMake(_bg.frame.origin.x+10 ,_bg.frame.origin.y+10);
    //_mavatar.center=CGPointMake(_bg.frame.origin.x+20 ,_bg.frame.origin.y+25);
    
    [self addSubview:_mavatar];

    
}

-(void)showStars2{
    
    ///stars
    int  st = [(NSString *)[_scene objectForKey:@"stars"] intValue];
    for(int i = 0; i<st;i++){
        UIImageView * star = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"starmm"]];
        star.center=CGPointMake(_miniature.center.x-5*i,_miniature.center.y);
        star.alpha = 1.0-0.1*i;
        [self.stars addObject:star];
        [self addSubview:star];
        //_miniature_bg.clipsToBounds=YES;
    }
    
    
}

-(void)canimate:(CGPoint)p{
    UIImageView * gl = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_bg"]];
    [self addSubview:gl];
    gl.center=p;
    gl.alpha=0.5;

      [gl setBounds:CGRectMake(0, 0, 10, 10)];
    [UIView animateWithDuration:0.7 animations:^{
        [gl setBounds:CGRectMake(0, 0, 200, 200)];
        gl.alpha=0.0;
    } completion:^(BOOL b){
        [gl removeFromSuperview];
    }];
}

-(void)animplay{
    CGRect ob = star.bounds;
    [UIView animateWithDuration:0.1 animations:^{
        star.bounds=CGRectMake(0, 0, star.bounds.size.width*1.1,  star.bounds.size.height*1.1);
    } completion:^(BOOL b){
        [UIView animateWithDuration:0.1 animations:^{
            star.bounds=CGRectMake(0, 0, star.bounds.size.width*0.9,  star.bounds.size.height*0.9);
        } completion:^(BOOL b){
            star.bounds=CGRectMake(0,0,56, 56);
            [self performSelector:@selector(animplay) withObject:self afterDelay:2.0];
        }];
    }];
}



-(void)setEnabled{
    self.enabled=true;
    star4.alpha=1.0;
    star4.userInteractionEnabled=true;
    star5.alpha=1.0;
    star5.userInteractionEnabled=true;
    star2.alpha=1.0;
    star2.userInteractionEnabled=true;
    
}
-(void)setDisabled{
    self.enabled=false;
    star4.alpha=0.1;
    star4.userInteractionEnabled=false;
    star5.alpha=0.1;
    star5.userInteractionEnabled=false;
    star2.alpha=0.1;
    star2.userInteractionEnabled=false;
    
    
}

-(void)showWrongVersion{
    NSLog(@"show WW");
    NSString *  imgname = @"btt_scene_locked_wrong_version";
    star = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgname]];
    star.center=CGPointMake(30+140, _miniature.center.y );
    [self addSubview:star];
}
-(void)showButtons{
    NSNumber* appVersion = [MTWebApi getAppVersion];
    if(_scene[@"AppVersion"]!=nil){
        appVersion =_scene[@"AppVersion"];
    }
    if ([appVersion intValue] > [[MTWebApi getAppVersion] intValue]){
        
        [self showWrongVersion];
    }else{
        [self showButtonsOK];
    }

}
-(void)showButtonsOK{

    NSLog(@"show btt");
    NSString * imgname = @"scene_cloud_play";
    if([@"false" isEqualToString:self.scene[@"opened"]]){
        imgname = @"scene_locked";
    }else{
        //[self performSelector:@selector(animplay) withObject:self afterDelay:2.0];
    }
    
    star = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgname]];
    
        star.center=CGPointMake(30+140, _miniature.center.y );
    
      star2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scene_cloud_download"]];
    star2.center=CGPointMake(30+200, _miniature.center.y );
      star3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scene_delete"]];
    star3.center=CGPointMake(30+260, _miniature.center.y );
    star4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scene_cloud_upload"]];
    star4.center=CGPointMake(30+200, _miniature.center.y );
    if([((NSNumber*)(_scene[@"shared"])) boolValue]){
        star5 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scene_share_selected"]];
        
    }else{
        star5 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scene_share"]];
        
    }
    star5.center=CGPointMake(30+320, _miniature.center.y );
    
    
    [star2 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(download:)]];
    [star3 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(delete:)]];
    [star4 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upload:)]];
    [star5 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(share:)]];
    

    [star2 setUserInteractionEnabled:YES];
    [star3 setUserInteractionEnabled:YES];
    [star4 setUserInteractionEnabled:YES];
    [star5 setUserInteractionEnabled:YES];
    
    [self setUserInteractionEnabled:YES];
    
    if(![@"false" isEqualToString:self.scene[@"opened"]]){
        [star addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(play:)]];
        [star setUserInteractionEnabled:YES];
        if ([self.buttonsdelegate respondsToSelector:@selector(play:)]){
            [self addSubview:star];
        }
    }else{
        [self addSubview:star];
    }
    
    if([(NSString*)self.scene[@"file"] length]>1){ //sprawdzam czy miniatura jest okreslona - tak dla istniejacych scen.... chyba
    if ([self.buttonsdelegate respondsToSelector:@selector(download:)]){
        //Sprawdzenie czy jest available_offline
        if(![@"true" isEqualToString: self.scene[@"available_offline"]]){
            [self addSubview:star2];
        }
    }
    if(![@"" isEqualToString: self.scene[@"thumbnail"]]){//Jeżeli miniatura jest pusta, to znaczy, że nie mają się wyświetlać przyciski.
            
        if ([self.buttonsdelegate respondsToSelector:@selector(delete:)]){
            [self addSubview:star3];
        }
        if ([self.buttonsdelegate respondsToSelector:@selector(upload:)]){
            [self addSubview:star4];
        }
        if ([self.buttonsdelegate respondsToSelector:@selector(share:)]){
            [self addSubview:star5];
        }
    }
    }
}

-(void)prepareToRemove{
     NSMutableDictionary * d  = [[NSMutableDictionary alloc]initWithDictionary:self.scene];
    //NSLog(@"Scene has button: %@", d[@"delegate"]);
    d[@"delegate"]=nil;
}

-(void)upload:(UITapGestureRecognizer*)tdg{
    [self canimate:tdg.view.center];
    ////NSLog(@"------>UP");
    if ([self.buttonsdelegate respondsToSelector:@selector(upload:)]){
        [self initProgressBar];
        NSMutableDictionary * d  = [[NSMutableDictionary alloc]initWithDictionary:self.scene];
        d[@"delegate"] = self;
        [self.buttonsdelegate upload:d];
    }
}

-(void)downloadWithCallback:(void(^)(void))cb{
    ////NSLog(@"------>DOWNLOADING:");
    ////NSLog(@"%@",self.scene);
    if ([self.buttonsdelegate respondsToSelector:@selector(download:withCallback:)]){
        [self initProgressBar];
        NSMutableDictionary * d  = [[NSMutableDictionary alloc]initWithDictionary:self.scene];
        d[@"delegate"] = self;
        [self.buttonsdelegate download:d withCallback:cb];
    }
}

-(void)download:(UITapGestureRecognizer*)tdg{
    [self canimate:tdg.view.center];
    ////NSLog(@"------>DO");
    if ([self.buttonsdelegate respondsToSelector:@selector(download:)]){
        [self initProgressBar];
        NSMutableDictionary * d  = [[NSMutableDictionary alloc]initWithDictionary:self.scene];
        d[@"delegate"] = self;
        [self.buttonsdelegate download:d];
    }
}



-(void)play:(UITapGestureRecognizer*)tdg{
    [self canimate:tdg.view.center];
    ////NSLog(@"------>PL");
    if ([self.buttonsdelegate respondsToSelector:@selector(play:)]){
        [self initProgressBar];
        NSMutableDictionary * d  = [[NSMutableDictionary alloc]initWithDictionary:self.scene];
        d[@"delegate"] = self;
        
        
        [self.buttonsdelegate play:d];
    }
}

-(void)delete:(UITapGestureRecognizer*)tdg{
    [self canimate:tdg.view.center];
    ////NSLog(@"------>DE");
    if ([self.buttonsdelegate respondsToSelector:@selector(delete:)]){
        NSMutableDictionary * d  = [[NSMutableDictionary alloc]initWithDictionary:self.scene];
        d[@"delegate"] = self;
        //[self.buttonsdelegate delete:d];
        [self.buttonsdelegate performSelector:@selector(delete:) withObject:d afterDelay:0.3];
        //[self.buttonsdelegate delete:self.scene];
    }
}

-(void) deleteRemotelyFull{
    [self deleteRemotely];
    [self setAsEmpty];
}

-(void)deleteRemotely{
    //[self canimate:tdg.view.center];
    NSLog(@"------>DELETING SCENE %@", self.scene);
    if ([self.buttonsdelegate respondsToSelector:@selector(delete:)]){
        NSMutableDictionary * d  = [[NSMutableDictionary alloc]initWithDictionary:self.scene];
        d[@"delegate"] = self;
        [self.buttonsdelegate performSelector:@selector(delete:) withObject:d afterDelay:0.3];
    }
    NSLog(@"Deleted");
}


-(void)share:(UITapGestureRecognizer*)tdg{
    [self canimate:tdg.view.center];
    
    ////NSLog(@"------>DE");
    if ([self.buttonsdelegate respondsToSelector:@selector(share:)]){
        NSMutableDictionary * d  = [[NSMutableDictionary alloc]initWithDictionary:self.scene];
        d[@"delegate"] = self;
        
        [self.buttonsdelegate share:d];
        //[self.buttonsdelegate delete:self.scene];
    }
}

-(void)setAsEmpty{
    [self clear];
    [self setup];
    [self setNewPosition:setPoint];
}


-(void)delete{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0.0;
    } completion:^(BOOL b){[self removeFromSuperview];}];
}


-(void) showProgress:(NSNumber*)n{
    ////NSLog(@"showing progress %@,%@", n, _progressBar);
    [_progressBar updatePercent:[n intValue]];
    
}

-(void) hideProgressBarSuccess{
    ////NSLog(@"hidign progress");
    [UIView animateWithDuration:0.5 animations:^{
        [_progressBar setGreenColor];
    }completion:^(BOOL b){
        [UIView animateWithDuration:0.5 animations:^{
            _progressBar.alpha=0;
        }completion:^(BOOL b){
            [_progressBar removeFromSuperview];
            _progressBar=nil;
        }];
    }];
    
}
-(void) hideProgressBarFailed{
    TestView* tmp = _progressBar;
    ////NSLog(@"hidign progress");
    [UIView animateWithDuration:0.5 animations:^{
        [tmp setRedColor];
    }completion:^(BOOL b){
        [UIView animateWithDuration:0.5 animations:^{
            tmp.alpha=0;
        }completion:^(BOOL b){
            [tmp removeFromSuperview];
            //tmp=nil;
        }];
    }];

}


-(void)initProgressBar{
    if(_progressBar)
        [self hideProgressBarFailed];
    _progressBar = [[TestView alloc]initClear];
    [_bg addSubview:_progressBar];
    [_progressBar updatePercent:0];
    _progressBar.center=_bg.center;
    //CGRect bo = self.bounds;
    if(shown){
        [_progressBar setBounds:CGRectMake(0, 0, 176*1.5/2, 176*1.5/2)];
    }else{
        [_progressBar setBounds:CGRectMake(5,5, 176*1.5/2, 176*1.5/2)];
        
    }
    //_progressBar.bounds=CGRectMake(0,0,_bg.bounds.size.width*1.5,_bg.bounds.size.height*1.5);
    [_progressBar setGrayColor];
    [_progressBar show];
    
}


-(void)getImage{
 
}


- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef maskedImageRef = CGImageCreateWithMask([image CGImage], mask);
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];
    
    CGImageRelease(mask);
    CGImageRelease(maskedImageRef);
    
    // returns new image with mask applied
    return maskedImage;
}



-(void)click{
    [self.delegate resetButtons:self.center.x];
    //[self select];
}
-(void)invalidate{
    
   // self.scene[@"delegate"] = nil;
    self.scene=nil;
    //NSLog(@"Retain count might be %lu",(unsigned long)[self retainCount]);
   //NSLog(@"Invalidate retain count is %ld", CFGetRetainCount((__bridge CFTypeRef)self));
}

-(void)reset{
    self.shown=false;
    [UIView animateWithDuration:0.1 animations:^{
        if(shown){
            [_progressBar setBounds:CGRectMake(0, 0, 176*1.5/2, 176*1.5/2)];
        }else{
            [_progressBar setBounds:CGRectMake(5,5, 176*1.5/2, 176*1.5/2)];
            
        }
        int i = 0;
        for(UIImageView* starx in stars){
            starx.center=CGPointMake(_miniature.center.x-4-4*i,_miniature.center.y);
            starx.alpha = 1.0-0.1*i;
            i++;
        }

        
         [self setBounds:CGRectMake(0, 0, 176/2,176/2)];
        self.backgroundColor=[UIColor clearColor];
        [_bg setBounds:CGRectMake(0, 0, 156/2, 156/2)];
         _bg.backgroundColor=[UIColor clearColor];
        self.layer.masksToBounds = YES;
        _miniature_bg.clipsToBounds=YES;

        
        _mavatar.center=CGPointMake(_bg.center.x+28 ,_bg.center.y);
        
        //_mavatar.center=CGPointMake(_bg.frame.origin.x+10 ,_bg.frame.origin.y+10);
        
    }];
}
-(void)select{
    self.shown=true;
    [UIView animateWithDuration:0.3 animations:^{
        if(shown){
            [_progressBar setBounds:CGRectMake(0, 0, 176*1.5/2, 176*1.5/2)];
        }else{
            [_progressBar setBounds:CGRectMake(5,5, 176*1.5/2, 176*1.5/2)];
            
        }
        self.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.3];
        [self setBounds:CGRectMake(0,0,400, 176/2)];
        self.layer.cornerRadius =  176/4;
        self.layer.masksToBounds = YES;
         _miniature_bg.clipsToBounds=NO;
        _mavatar.center=CGPointMake(_bg.center.x+48 ,_bg.center.y);
        int i = 0;
        float n = stars.count-1;
        for(UIImageView* starx in stars){
            float x = (i<n/2)?n/2-i:i-n/2;
            starx.center=CGPointMake(_miniature.center.x+85-3*x*x,_miniature.center.y-(n*7)+14*i);
            starx.alpha = 1.0;
            i++;
        }
        
        [_bg setBounds:CGRectMake(0, 0, 176/2, 176/2)];
        //_bg.backgroundColor=[UIColor yellowColor];
    }];
}
@end
