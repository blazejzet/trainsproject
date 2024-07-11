//
//  MTButtonsView.m
//  MagicTrains
//
//  Created by Blazej Zyglarski on 06.01.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTButtonsView.h"
#import "MTArchiver.h"
#import "MTViewController.h"
#import "TestView.h"
#import "MTGui.h"
@interface MTButtonsView ()
//@property UIImageView * sh;
@end
@implementation MTButtonsView
@synthesize delegate;
@synthesize a;
//@synthesize sh;
@synthesize p;
@synthesize btt;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 
 */

-(void)addButtons{
    for(int i = 0;i<10;i++){
        UIButton * b = [[UIButton alloc]initWithFrame:CGRectMake(200+64*i,50,50,50)];
        [self addSubview:b];
        [btt addObject:b];
        NSString *minatureImageName = [[MTArchiver getInstance] getMiniatureWithNr:i+1];
        ////NSLog(@"%@",minatureImageName);
        if (minatureImageName)
            [b setBackgroundImage:[UIImage imageNamed:@"BS1.png"] forState:UIControlStateNormal];
        else
            [b setBackgroundImage:[UIImage imageNamed:@"BS2.png"] forState:UIControlStateNormal];
        //[b setBackgroundImage:[UIImage imageNamed:@"BS1.png"] forState:UIControlStateSelected];
        [b addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:) ]] ;
        //[b addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(press:) ]] ;
        [b setUserInteractionEnabled:YES];
        [b setTag:i+1];
    }
}

-(void)clearButtons{
    for(UIView* v in self.subviews){
        [v removeFromSuperview];
    }
    [btt removeAllObjects];
    [self addButtons];
}


-(NSArray*)getMiniatures:(UIButton*)b{
    NSMutableArray* a = [NSMutableArray array];
    //[a insertObject:@"DE_C1.png" atIndex:0];
    [a insertObject:@"startup_tp_2014_bg3.png" atIndex:0];
    @try{
        //        [a setObject: atIndexedSubscript:0];
        [a replaceObjectAtIndex:0 withObject:[[MTArchiver getInstance] getSnapshotWithNr:b.tag]];
        [a insertObject:[[MTArchiver getInstance] getMiniatureWithNr:b.tag] atIndex:1];
    }@catch(NSException* e){
    }
    return a;
}

-(void)buttonPresssed:(UIButton*)b{
   // [delegate buttonPressed:b.tag];
}

-(BOOL)showEdit{
    return YES;
}




-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self)
    {
        //sh=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BGB.png"]];
        //sh.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        //sh.alpha=0;
        //[self addSubview:sh];
        a= [NSMutableArray array];
        btt= [NSMutableArray array];
        //[self addButtons];
        self.alpha=0;
        [self setUserInteractionEnabled:YES];
        
    }
    return self;
    
    
}
-(void)press:(UILongPressGestureRecognizer*)g{
    [self.delegate userAction];
    if(g.state == UIGestureRecognizerStateBegan){
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha=0;
            self.center=CGPointMake(self.center.x, self.center.y-25);
        } completion:^(BOOL c){
            UIButton * b =(UIButton *)g.view;
           // [delegate buttonPressed:b.tag];
        }];
    }
}

-(void)clear:(UIGestureRecognizer*)g{
    UIButton * b =(UIButton *)g.view;
    //    int i = b.tag;
    [self.delegate userAction];
    
    NSString *filename = [NSString stringWithFormat:@"SessionData%lu.mtd",(unsigned long) b.tag];
    [[MTArchiver getInstance] setFilename: filename];
    [[MTArchiver getInstance] deleteMiniature:b.tag];
    [[MTArchiver getInstance] deleteStorage];
    //    [(MTMainScene *) self.mainScene.scene prepareGUI];
    [self clearButtons];
    
}


-(void)share:(UIGestureRecognizer*)g{
    [self.delegate userAction];
    UIButton * b =(UIButton *)g.view;
    
    //    int i = b.tag;
    //b.center= CGPointMake(b.center.x-100,b.center.y);
    TestView * t = [[TestView alloc]initClear];
    [b.superview addSubview:t];
    
    [t updatePercent:0];
    t.center=b.center;
    CGRect bo = self.bounds;
    t.bounds=CGRectMake(0,0,10,10);
    [UIView animateWithDuration:0.2 animations:^{
        t.alpha=1;
        t.bounds=bo;
    }];
    [delegate shareProgressBar:t];
    [delegate uploadPressed:b.tag];
    //    [(MTMainScene *) self.mainScene.scene prepareGUI];
    
    
}


-(void)tap:(UIGestureRecognizer*)g{
    UIButton * b =(UIButton *)g.view;
    [self.delegate userAction];
    [UIView animateWithDuration:0.5 animations:^{
    [self.p updatePositions:CGPointMake(HEIGHT/2,HEIGHT-(768-740))];
    }];
    bool __block lewo=true;
    int i =0;
    for(UIButton * bo in btt){
        [UIView animateWithDuration:0.2 animations:^{
            if ([bo isEqual:b]){
                lewo=false;
                [bo setFrame:CGRectMake(200+64*i,50,50,50)];
            }else{
                if (lewo){
                    [bo setFrame:CGRectMake(200+64*i-50,50,50,50)];
                }else{
                    [bo setFrame:CGRectMake(200+64*i+50,50,50,50)];
                    
                }
            }
        }];
        i++;
    }
    
    
    if ([b isSelected]){
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha=0;
            self.center=CGPointMake(self.center.x, self.center.y-25);
        } completion:^(BOOL c){
            UIButton * b =(UIButton *)g.view;
            [self buttonPresssed:b];
        }];
    }else
    {
        for(UIButton * b in btt){
            [b setSelected:FALSE];
            
        }
        for(UIView * b in a){
            [UIView animateWithDuration:0.3 animations:^{
                b.alpha=0;
                b.center=CGPointMake(b.center.x, b.center.y-20);
            } completion:^(BOOL c){
                [b removeFromSuperview];
            }];
            
        }
        [b setSelected:YES];
        
        [a removeAllObjects];
        
        NSArray * images  = [self getMiniatures:b];
        NSString *minatureImageName;
        NSString *snapshotImageName;
        
        @try{minatureImageName = [images objectAtIndex:1];}@catch(NSException *e){}
        @try{snapshotImageName = [images objectAtIndex:0];}@catch(NSException *e){}
        
        if (minatureImageName || snapshotImageName)
        {
            UIButton * b1 = [[UIButton alloc]initWithFrame:b.frame];
            UIButton * b2 = [[UIButton alloc]initWithFrame:b.frame];
            [b1 setBackgroundImage:[UIImage imageNamed:@"BS_DEL.png"] forState:UIControlStateNormal];
            
            b1.tag=b.tag;
            [b1 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clear:)]];
            [b2 setBackgroundImage:[UIImage imageNamed:@"BS2_SHARE.png"] forState:UIControlStateNormal];
            b2.tag=b.tag;
            [b2 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(share:)]];
            
            
            
            
            [self addSubview:b1];
            [self addSubview:b2];
            [a addObject:b1];
            [a addObject:b2];
            b1.alpha=0;
            b2.alpha=0;
            if([self showEdit] && images.count==2){
                [UIView animateWithDuration:0.3 animations:^{
                    
                    b1.alpha=1;
                    b2.alpha=1;
                    b1.center=CGPointMake(b1.center.x-70, b1.center.y+70);
                    b2.center=CGPointMake(b1.center.x+140, b1.center.y);
                }];
            }
            
            
            UIImageView*cialoducha = [[UIImageView alloc]initWithImage:[UIImage imageNamed:minatureImageName]];
            UIImage* OrigImage = [UIImage imageNamed:snapshotImageName];
            UIImage *mask = [UIImage imageNamed:@"MASK2.png"];
            UIImage *maskedImage = [self maskImage:OrigImage withMask:mask];
            UIImageView*miniatura = [[UIImageView alloc]initWithImage:maskedImage];
            UIImageView*cien = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SHAD.png"]];
            UIImageView*cien2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SHAD2.png"]];
            UIImageView*usmiech = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_USMIECHNIETY_1.png", [minatureImageName substringToIndex:[minatureImageName rangeOfString:@"_"].location]]]];
            
            [cien setFrame:CGRectMake(0, 0, 160, 160)];
            [miniatura setFrame:CGRectMake(-7, 11, 173, 130)];
            //[miniatura setContentMode:UIViewContentModeScaleToFill];
            [cialoducha setFrame:CGRectMake(60, 40, 55, 55)];
            [cien2 setFrame:CGRectMake(60, 40, 55, 55)];
            
            [usmiech setFrame:CGRectMake(0, 0, 55, 55)];
            
            if([self showEdit] && images.count==2){
                [miniatura addSubview:cien2];
                [miniatura addSubview:cialoducha];
                [cialoducha addSubview:usmiech];
            }
            [cien addSubview:miniatura];
            
            
            [a addObject:cien];
            [self addSubview:cien];
            cien.center=b.center;
            cien.alpha=0;
            
            [UIView animateWithDuration:0.3 animations:^{
                cien.alpha=1;
                
            }];
            
        }
        
        
        
        
        //[UIView animateWithDuration:0.2 animations:^{
        //    self.alpha=0;
        //    self.center=CGPointMake(self.center.x, self.center.y-25);
        //} completion:^(BOOL c){
        //
        //
        //
        // }];
    }
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

-(void)show{
    [self addButtons];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha=1;
        //self.center=CGPointMake(self.center.x, 455);
    }];
}

-(void)hide{
    // [self.delegate userAction];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0;
        self.center=CGPointMake(self.center.x, 500);
    }];
}


@end
