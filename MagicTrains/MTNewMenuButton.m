 //
//  MTNewMenuButton.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 19.06.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTNewMenuButton.h"
#import "MTNewMenuButtonBubble.h"
#import "MTWebApi.h"
#import "MTNewMenuButtobBlackBubble.h"
#import "MTGui.h"

@interface MTNewMenuButton ()
@property UIImageView * img;
@property UIImage * imgdis;
@property UIImage * imgenab;

@property UIImageView * bg;
@property int synch;
@property BOOL opened;
@property UILabel * l;
@property UILabel * l2;
@property BOOL enabled;
@end

@implementation MTNewMenuButton
@synthesize type;
@synthesize subtype;
@synthesize selected;
@synthesize refDisplay;
@synthesize l;
@synthesize l2;
@synthesize p;
@synthesize img;
@synthesize imgdis;
@synthesize imgenab;
@synthesize enabled;
@synthesize opened;
@synthesize bg;
@synthesize othersCollection;


    static int mayi=0;

-(void)bubbleRepeat:(NSObject*)sender{
    if (selected){
        if(_synch==0 || sender!=nil){
            _synch=1;
    [UIView animateWithDuration:0.1 animations:^{
        if(bg.alpha==1.0){
            
            bg.alpha=0.8;
        }else{
            bg.alpha=1.0;
        }
    }
    completion:^(BOOL b){
        [self bubble];
        [self performSelector:@selector(bubbleRepeat:) withObject:self afterDelay:0.1];
    
    }
    ];
        }
    }else{
        _synch=0;
        [UIView animateWithDuration:0.6 animations:^(){
            bg.alpha=0;
        }];
    }
}

-(void)select{
    [UIView animateWithDuration:0.5 animations:^{
        if(self.subtype!=nil){
           [self.p updatePositions:CGPointMake(1024/2, HEIGHT-(768-710))];
        }else{
           [self.p updatePositions:CGPointMake(1024/2, HEIGHT-(768-850))];
        }

        
    }];
    
    self.selected=YES;
    if(self.refDisplay){
        [self.refDisplay show:self.type];
        if( self.enabled) { [self.refDisplay setEnabled];}else{[self.refDisplay setDisabled];}
        
    }
}
-(void)unselect{
    self.selected=NO;
    if(self.refDisplay){
        [self.refDisplay hide];
    }
}



-(void)bubble{
    for(int i = 1;i<=10;i++){
        MTNewMenuButtonBubble * b ;
        //if(self.subtype!=nil){
        //  b = [[MTNewMenuButtobBlackBubble alloc]initWithPoint:self.center];
        //}else{
          b = [[MTNewMenuButtonBubble alloc]initWithPoint:self.center];

        //}
    [self.superview addSubview:b];
   [self.superview sendSubviewToBack:b];
   

        [UIView animateWithDuration:1.0 animations:^{
            double x =  (arc4random()%120)*1.0-60;
            double y =  (arc4random()%120)*1.0-60;
            //////NSLog(@"%f %f",x,y);
            if(b != NULL){
                @try {
                    b.center= CGPointMake(b.center.x+x*1.5, b.center.y+y*1.5);
                    b.alpha = 0;
                    b.bounds=CGRectMake(0,0,20,20);
                } @catch (NSException *exception) {
                    NSLog(@"Cos nie tak z babelkami");
                } @finally {
                }
            }
        } completion:^(BOOL co){
            @try {
                [b removeFromSuperview];
            } @catch (NSException *exception) {
                NSLog(@"Cos nie tak z babelkami");
            } @finally {
            }
        }];
    }
}

-(void)decr{
    mayi=0;
}
-(void)click{
    if(self.opened==true){
    if(self.userInteractionEnabled)
    {
    if(mayi==0){
        ////NSLog(@"OU YES OU YES");
        mayi=1;
        for(MTNewMenuButton* b in self.othersCollection){
            [b unselect];
        }
        [self select];
        [self bubbleRepeat:nil];
          [self performSelector:@selector(decr) withObject:nil afterDelay:1.5];
    }else{
        ////NSLog(@"NONO YOU DONT MENU NOW!");
    
    }
    }
    }
}


-(void)setEnabled{
    self.enabled=true;
    if ([self.type isEqualToString:@"cloud"] || [self.type isEqualToString:@"cloudmy"]){
        self.userInteractionEnabled=true;
        self.img.image = self.imgenab;
        [self.refDisplay setEnabled];
        
    }
}

-(void)setDisabled{
    self.enabled=false;
    if ([self.type isEqualToString:@"cloud"] || [self.type isEqualToString:@"cloudmy"]){
        self.img.image = self.imgdis;
        self.userInteractionEnabled=false;
        [self.refDisplay setDisabled];
    }
    
}

-(void)refresh{
    [self.refDisplay refresh];
}
-(void)show{
    self.alpha=0;
    l.alpha=0.0;

    l2.alpha=0.0;
    bg.bounds = CGRectMake(0,0,0,0);
    float x = 0.1 * (arc4random()%10);
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha=1;
        bg.alpha=1;
        bg.bounds = CGRectMake(0,0,self.bounds.size.height,self.bounds.size.width);
        
    }  completion:^(BOOL b){
        [self bubble];
       
        [UIView animateWithDuration:0.1 animations:^{
            bg.alpha=0.9;
            bg.bounds = CGRectMake(0,0,self.bounds.size.height*0.9,self.bounds.size.width*0.9);
        }  completion:^(BOOL b){
            
            
            [UIView animateWithDuration:0.1 animations:^{
                self.alpha=1;
                img.alpha=1;
                bg.alpha=0.8;
                l.alpha=1.0;
                l2.alpha=0.8;
                
                bg.bounds = CGRectMake(0,0,self.bounds.size.height*0.8,self.bounds.size.width*0.8);
            }  completion:^(BOOL b){
             
                
                [UIView animateWithDuration:0.2 animations:^{
                    self.alpha=1;
                    bg.alpha=0;
                    bg.bounds = CGRectMake(0,0,0,0);
                }  completion:^(BOOL b){
                    
                }];
            }];
        }];
    }];
}

-initWithType:(NSString*)type{
    self = [super initWithFrame:CGRectMake(0, 0, 176/2,176/2)];
    self.opened=true;
    imgdis = [UIImage imageNamed:[NSString stringWithFormat:@"menudis_%@.png",type]];
    imgenab = [UIImage imageNamed:[NSString stringWithFormat:@"menu_%@.png",type]];
    img = [[UIImageView alloc]initWithImage:self.imgenab];
    
    bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_bg"]];
    enabled=true;
    [self addSubtitle:type];
    [self addSubview:bg];
    [self addSubview:img];
    bg.alpha = 0;
    img.alpha=0;
    
    self.type=type;
    
    [img setUserInteractionEnabled:YES];
    [self setUserInteractionEnabled:YES];
    [img addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)]];
    
    return self;
}

-(id)initWithType:(NSString*)type andSubtype:(NSString*)stype{
    self = [self initWithType:type];
    imgdis = [UIImage imageNamed:[NSString stringWithFormat:@"menudis_%@_%@.png",type,stype]];
    imgenab = [UIImage imageNamed:[NSString stringWithFormat:@"menu_%@_%@.png",type,stype]];
    img.image = self.imgenab;
    
    self.subtype=stype;
    enabled=true;
    [self addSubtitle:stype];
    return self;
}

-(void)addSubtitle:(NSString*)title{
    
    NSDictionary* labels =
    @{ @"1" : @"Level 1",
       @"2" : @"Level 2",
       @"3" : @"Level 3",
       @"4" : @"Level 4",
       @"5" : @"Level 5",
       @"6" : @"Level 6",
       @"7" : @"Level 7",
       
       @"cloud" : @"Public",
       @"cloud_downloaded" : @"Downloaded",
       @"cloudmy" : @"Your Cloud",
       @"book" : @"Excersize",
       @"cloudshowcase" : @"Showcase",
       @"contest" : @"Challenge",
       @"sandbox" : @"Your Sandbox",
       @"more" : @"Classroom",
       
       @"downloaded" : @"Downloaded",
       @"my" : @"Uploaded",
       @"all" : @"Top-rated",
       @"people" : @"All",
       
       @"basics" : @"Basics",
       @"ghosts" : @"Creatures",
       @"messaging" : @"Messaging",
       @"loops" : @"Loops",
       @"math" : @"Math",
       @"physics" : @"Physics",
       
       
       };
    
    if ([[MTWebApi getLang] isEqualToString:@"pl"]){
        labels =
        @{ @"1" : @"Poziom 1",
           @"2" : @"Poziom 2",
           @"3" : @"Poziom 3",
           @"4" : @"Poziom 4",
           @"5" : @"Poziom 5",
           @"6" : @"Poziom 6",
           @"7" : @"Poziom 7",
           
           @"cloud" : @"Publiczne",
           @"cloud_downloaded" : @"Pobrane",
           @"cloudmy" : @"Twoja chmura",
           @"cloudshowcase" : @"Showcase",
           @"book" : @"Ćwiczenia",
           @"contest" : @"Wyzwania",
           @"sandbox" : @"Piaskownica",
            @"more" : @"Narzędzia klasowe",
           
           @"downloaded" : @"Sceny pobrane",
           @"my" : @"Sceny wysłane",
           @"all" : @"Najlepsze",
           @"people" : @"Wszystkie",
           
           @"basics" : @"Podstawy",
           @"ghosts" : @"Stwory",
           @"messaging" : @"Wiadomości",
           @"loops" : @"Pętle",
           @"math" : @"Matematyka",
           @"physics" : @"Fizyka",
           
           
           };
    }
    
    
    if(l==nil) {
        l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width*2, self.frame.size.height/2.0)];
        l.center=CGPointMake(self.frame.size.width/2.0, self.frame.size.height);
        l.font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:14.0 ];
        l.textColor=[UIColor blackColor];
        l.textAlignment = NSTextAlignmentCenter;
        l.numberOfLines= 1   ;
        l.alpha=0.0;

    
        l2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width*2, self.frame.size.height/2.0)];
        l2.center=CGPointMake(self.frame.size.width/2.0, self.frame.size.height+1);
        l2.font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:14.0 ];
        [self addSubview:l2];
        [self addSubview:l];
        
        l2.textColor=[UIColor whiteColor];
        l2.textAlignment = NSTextAlignmentCenter;
        l2.numberOfLines= 1   ;
        l2.alpha=0.0;
}
    l.text = [labels objectForKey:title];
    l2.text = [labels objectForKey:title];
    
}

-(id)initWithType:(NSString*)type andSubtype:(NSString*)stype opened:(BOOL)opened{
    
    self = [self initWithType:type];
    [self addSubtitle:stype];
    NSString * o =@"";
    if(!opened){o=@"c";}
    
    img.image = [UIImage imageNamed:[NSString stringWithFormat:@"menu_%@_%@%@.png",type,stype,o]];
    
    self.subtype=stype;
    self.opened=opened;
    return self;
}
@end
