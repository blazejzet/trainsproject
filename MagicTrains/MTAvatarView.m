//
//  MTAvatarView.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 01.10.2015.
//  Copyright © 2015 UMK. All rights reserved.
//

#import "MTAvatarView.h"
#import "MTUserStorage.h"

@implementation MTAvatarView{
    UIImageView * bg;
    UIImageView * av;
    UIImageView * avf;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithData:(NSString*)avatarid{
    self = [super initWithFrame:CGRectMake(0,0,100,100)];
    if(self){
        [self setMyAvatarWithId: avatarid];
    }
    return self;

}

-(MTAvatarView*)small{
    int x = 3;
    self.frame=CGRectMake(0, 0, 100/x, 100/x);
    bg.frame=CGRectMake(0,0,100/x,100/x);
    av.frame=CGRectMake(25/x,25/x,50/x,50/x);
    avf.frame=CGRectMake(25/x,25/x,50/x,50/x);
    return self;
}
-(id)init{
    self = [super initWithFrame:CGRectMake(0,0,100,100)];
    if(self){
        NSString *avatarid = [[MTUserStorage getInstance] getAvatarId];
        
        [self setMyAvatarWithId: avatarid];
                
    }
    return self;
}


-(NSString*)getAvatarId{
    return [[MTUserStorage getInstance] getAvatarId];
   /*
    NSUserDefaults* d = [NSUserDefaults standardUserDefaults];
    NSInteger avatar_bg = [d integerForKey:@"avatar_bg_"] ;
    NSInteger avatar_ghost = [d integerForKey:@"avatar_ghost_"] ;
    NSInteger avatar_ghost_color = [d integerForKey:@"avatar_ghost_color_"] ;
    NSInteger avatar_ghost_face = [d integerForKey:@"avatar_ghost_face_"] ;
    return [NSString stringWithFormat:@"%ld-%ld-%ld-%ld",avatar_bg,avatar_ghost,avatar_ghost_color,avatar_ghost_face];
    */
}

/// ONLY IMPLEMENTATION!!!
-(void) setMyAvatarWithId:(NSString*) avatarid{
    NSArray * avi = [avatarid componentsSeparatedByString:@"-"];
    
    NSInteger avatar_bg =  [[avi objectAtIndex:0] integerValue] ;
    NSInteger avatar_ghost = [[avi objectAtIndex:1] integerValue] ;
    NSInteger avatar_ghost_color = [[avi objectAtIndex:2] integerValue] ;
    NSInteger avatar_ghost_face = [[avi objectAtIndex:3] integerValue];
    
    ////NSLog(@"AVATAR %ld %ld %ld %ld",avatar_bg,avatar_ghost,avatar_ghost_color,avatar_ghost_face);
    bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"avatar%ld",avatar_bg]]];
    av = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"D%ld_C%ld",avatar_ghost,avatar_ghost_color]]];
    avf = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"D%ld_USMIECHNIETY_%ld",avatar_ghost,avatar_ghost_face]]];
    bg.frame=CGRectMake(0,0,100,100);
    av.frame=CGRectMake(25,25,50,50);
    avf.frame=CGRectMake(25,25,50,50);
    [bg addSubview:av];
    [bg addSubview:avf];
    [self addSubview:bg];
}

@end
