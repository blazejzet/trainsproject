//
//  MTParamView.m
//  MagicTrains
//
//  Created by Blazej Zyglarski on 01.02.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import "MTParamView.h"

@interface MTParamView()
@property NSString* fname;
@property NSString* pname;
    @property int value;
@property NSMutableArray* hearts;
@property (weak) id target;
@property  SEL sel;
@end

@implementation MTParamView
@synthesize fname;
@synthesize value;
@synthesize pname;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init:(int)type :(int)def{
    
    self = [self init:type];
    
    [self setV:def];
    
    return self;
    
}

-(void)setTarget:(id)s withSelector:(SEL) selector{
    _target=s;
    _sel = selector;
}
-(id)init:(int)type{
    self = [super initWithFrame:CGRectMake(0, 0, 250, 50)];
    self.hearts=[NSMutableArray array];
    self.userInteractionEnabled=YES;
    if(type==1){ //HEARTS
        self.fname= @"HEART%d.png";
        self.pname= @"HEART%d_E.png";
    }else{
        self.fname= @"MASS%d.png";
        self.pname= @"MASS%d_E.png";
    }
    self.value=8;
    
    
    for(int i = 0;i<10;i++){
        UIImageView* m = [[UIImageView alloc]initWithImage:[UIImage imageNamed:
                                                            
                                                            [NSString stringWithFormat:self.fname,i%2]
                                                            ]];
        m.tag=i;
        [m addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateV:)]];
        [self addSubview:m];
        m.userInteractionEnabled=YES;
        m.center=CGPointMake(i*25,20);
        [self.hearts addObject:m];
    }
    
    return self;
}
-(int)getV{
    return self.value;
}
-(void)setV:(int)nv{
    self.value=nv;
    for(int i = 0;i<10;i++){
        UIImageView* m = [self.hearts objectAtIndex:i];//= [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.fname]];
        //[self addSubview:m];
        //m.center=CGPointMake(i*30,20);
        //[self.hearts addObject:m];
        if(i<nv){
            m.image=[UIImage imageNamed:[NSString stringWithFormat:self.fname,i%2]];
        }else{
            m.image=[UIImage imageNamed:[NSString stringWithFormat:self.pname,i%2]];
        }
       
    }
    if(_target!=nil){
        [_target performSelector:_sel withObject:self afterDelay:0];
    }
}
-(void)updateV:(UITapGestureRecognizer*)g{
    UIImageView *m = (UIImageView *)g.view;
    [self setV:m.tag+1];
}

@end
